(define-module (system base)
  #:use-module (gnu)
  #:use-module (gnu services networking)
  #:use-module (gnu services ssh)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages python)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages package-management)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(define-public base-operating-system
  (operating-system
   (host-name "grex-base")
   (timezone "America/Los_Angeles")
   (locale "en_US.utf8")

   ;; Use non-free Linux and firmware
   (kernel linux)
   (firmware (list linux-firmware))
   (initrd microcode-initrd)

   ;; Guix told me to add this
   (initrd-modules (append (list "mptspi")
                           %base-initrd-modules))

   ;; US English Keyboard Layout
   (keyboard-layout (keyboard-layout "us"))

   ;; UEFI variant of GRUB with EFI System
   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (target "/boot/efi")
                (keyboard-layout keyboard-layout)))

   ;; Dummy file system we'll overwrite
   (file-systems (cons*
                  (file-system
                   (mount-point "/tmp")
                   (device "none")
                   (type "tmpfs")
                   (check? #f))
                  %base-file-systems))

   ;; Default User
   (users (cons (user-account
                 (name "grex")
                 (comment "GReX User")
                 (group "users")
                 (home-directory "/home/grex")
                 (supplementary-groups '("wheel"  ;; sudo
                                         "netdev" ;; network devices
                                         "tty"
                                         "input")))
                %base-user-accounts))

   ;; Services
   (services (cons* (service dhcp-client-service-type)
                    %base-services))

   ;; Base system packages
   (packages (append (map specification->package
                          (list
                           ;; Core stuff
                           "git"
                           ;; Python nonsense
                           "python2"
                           "python"
                           "conda"
                           ;; Editors
                           "emacs"
                           "vim"
                           ;; SS
                           "nss-certs"))
                     %base-packages))))
