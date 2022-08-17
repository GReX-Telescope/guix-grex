(define-module (grex system base)
  #:use-module (gnu)
  #:use-module (gnu services networking)
  #:use-module (gnu services sysctl)
  #:use-module (gnu services monitoring)
  #:use-module (gnu services ssh)
  #:use-module (gnu services linux)
  #:use-module (gnu services base)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages monitoring)
  #:use-module (gnu packages python)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages package-management)
  #:use-module (gnu system pam)
  #:use-module (nongnu packages linux)
  #:use-module (grex packages nvidia)
  #:use-module (grex packages pipeline)
  #:use-module (nongnu system linux-initrd))

(define admin-groups '("wheel" "netdev" "tty" "input"))

(define-public (admin-user username)
  (user-account
   (name username)
   (group "users")
   (comment "")
   (home-directory (string-append "/home/" username))
   (supplementary-groups admin-groups)))

(define-public base-operating-system
  (operating-system
   (host-name "grex-base")
   (timezone "America/Los_Angeles")
   (locale "en_US.utf8")

   ;; Use non-free Linux and firmware
   (kernel linux-lts)
   (firmware (list linux-firmware))
   (initrd microcode-initrd)

   ;; Blacklist the nouveau driver as we're using non-free nvidia
   ;; At least until we get a build of the FOSS driver
   (kernel-arguments (append
                      '("modprobe.blacklist=nouveau")
                      %default-kernel-arguments))

   ;; Tell guix that the nvidia driver is loadable
   (kernel-loadable-modules (list nvidia-driver))

   ;; Guix told me to add this
   (initrd-modules
    (append (list "mptspi")
            %base-initrd-modules))

   ;; US English Keyboard Layout
   (keyboard-layout (keyboard-layout "us"))

   ;; UEFI variant of GRUB with EFI System
   (bootloader
    (bootloader-configuration
     (bootloader grub-efi-bootloader)
     (targets '("/boot/efi"))
     (keyboard-layout keyboard-layout)))

   ;; Dummy file system we'll overwrite
   (file-systems
    (cons*
     (file-system
      (mount-point "/tmp")
      (device "none")
      (type "tmpfs")
      (check? #f))
     %base-file-systems))

   ;; Default User
   (users
    (cons
     (admin-user "grex")
     %base-user-accounts))

   ;; Services
   (services
    (cons*
     ;; Elogind, because users and we're not running a desktop env
     (service elogind-service-type)

     ;; DHCP all network cards by default
     (service dhcp-client-service-type)

     ;; Enable SSH
     (service openssh-service-type
              (openssh-configuration
               ;; Allow ports exposed from the Pi to be accessed via this server (MnC)
               (gateway-ports? #t)
               (password-authentication? #t)
               (x11-forwarding? #t)))

     ;; Create udev rule for nvidia
     (simple-service
      'custom-udev-rules udev-service-type
      (list nvidia-driver))

     ;; Enable realtime stuff and unlimited memory locking (for PSRDADA)
     (pam-limits-service
      (list
       (pam-limits-entry "*" 'both 'rtprio 99)
       (pam-limits-entry "*" 'both 'memlock 'unlimited)))

     ;; Hard code in the LD_LIBRARY_PATH to the CUDA driver
     ;; We need this because *all* CUDA stuff pretty much needs
     ;; dynamic access to the driver's specific cuda runtime
     ;; RMS forgive me
     (simple-service
      'cuda-ld-path session-environment-service-type
      (list (cons "LD_LIBRARY_PATH" (file-append nvidia-driver "/lib"))))

     ;; Ensure the nvidia kernel modules load
     (service kernel-module-loader-service-type
              '("ipmi_devintf"
                "nvidia"
                "nvidia_modeset"
                "nvidia_uvm"))

     ;; Use the Prometheus Node Exporter Service to get data to Grafana
     (service prometheus-node-exporter-service-type
              (prometheus-node-exporter-configuration
               (web-listen-address "0.0.0.0:8082")))

     (modify-services
      %base-services
      ;; Allow forwarding
      (sysctl-service-type
       config =>
       (sysctl-configuration
        (settings (append '(("net.ipv4.ip_forward" . "1"))
                          %default-sysctl-settings))))
     ;; Allow substitutes
      (guix-service-type
       config => (guix-configuration
                  (inherit config)
                  (substitute-urls
                   (append (list "https://substitutes.nonguix.org")
                           %default-substitute-urls))
                  (authorized-keys
                   (append (list (local-file "./nonguix-key.pub")
                                 (local-file "./guixhpc-key.pub"))
                           %default-authorized-guix-keys)))))))

   ;; Base system packages
   (packages
    (append
     (list
      ;; Nvidia Driver itself and accoutrements
      nvidia-driver
      nvidia-libs
      ;; Core stuff
      git
      ;; Python nonsense
      python
      conda
      ;; Editors
      emacs-no-x-toolkit
      vim
      ;; SS
      nss-certs
      ;; 7z needed for Julia's package manager
      p7zip
      ;; Bake in pipeline software
      psrdada
      heimdall-dsa)
     %base-packages))))
