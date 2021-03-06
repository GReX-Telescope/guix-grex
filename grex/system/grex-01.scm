;;; This is the system configuration for the "minor" test server
(define-module (grex system grex-01)
  #:use-module (gnu packages shells)
  #:use-module (guix gexp)
  #:use-module (grex system base)
  #:use-module (gnu services networking)
  #:use-module (gnu))

(define host "grex-01")

(operating-system
 ;; We start off the same as the "base" system
 (inherit base-operating-system)

 ;; And set the host name accordingly
 (host-name host)

 ;; We can be specific about the filesystem layout, fstab etc.
 (file-systems
  (cons*
   (file-system
    (device "/dev/sda2")
    (mount-point "/")
    (type "ext4"))
   (file-system
    (device "/dev/sda1")
    (mount-point "/boot/efi")
    (type "vfat"))
   ;; 8TB Storage Drive, not sure what goes here yet
   (file-system
    (device "/dev/sdb1")
    (mount-point "/mnt/storage")
    (type "ext4"))
   %base-file-systems))

 ;; We need to configure system-specific NIC as they need
 ;; to match the RPI that talks to the SNAP FPGA board
 (services
  (cons*
   (service nftables-service-type
            (nftables-configuration
             (ruleset (plain-file "nftables.conf"
                                  "
flush ruleset

table inet nat {
    chain postrouting {
        type nat hook postrouting priority 100;
        # Masquerade the Pi's addresses for the internet (eno1)
        oifname eno1 masquerade;
    }
}
"))))
   (service static-networking-service-type
            (list (static-networking
                   (addresses
                    (list
                     (network-address
                      (device "eno2")
                      (value "192.168.0.1/24"))
                     (network-address
                      (device "enp129s0f0")
                      (value "192.168.5.1/24"))))
                   (provision '(fpga-static-networking)))))
   (operating-system-user-services base-operating-system)))

 ;; This server will have a couple admin users
 (users
  (cons
   (user-account
    (inherit (admin-user "kiran"))
    (shell (file-append fish "/bin/fish")))
   (append
    (map admin-user '("liam" "vikram"))
    (operating-system-users base-operating-system)))))
