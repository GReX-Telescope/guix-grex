(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/Los_Angeles")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "grex-01")
  (users (cons* (user-account
                  (name "grex")
                  (comment "Grex")
                  (group "users")
                  (home-directory "/home/grex")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (service network-manager-service-type)
            (service wpa-supplicant-service-type))
      %base-services))
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (target "/dev/sda")
      (keyboard-layout keyboard-layout)))
  (initrd-modules
    (append '("mptspi") %base-initrd-modules))
  (swap-devices
    (list (uuid "9a4ae2a3-ec7b-4e88-a0cf-12d06e813d85")))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "7a2286d6-aa8f-41ff-84dc-e5dfad291aa4"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))
