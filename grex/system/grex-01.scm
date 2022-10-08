;;; This is the system configuration for the "minor" test server
(define-module (grex system grex-01)
  #:declarative? #f
  #:use-module (gnu packages shells)
  #:use-module (gnu packages linux)
  #:use-module (guix gexp)
  #:use-module (grex system base)
  #:use-module (gnu services networking)
  #:use-module (gnu services shepherd)
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
             (ruleset (local-file "./nftables.conf"))))
   (service dhcpd-service-type
            (dhcpd-configuration
             (config-file (local-file "./dhcpd.conf"))
             (interfaces '("enp129s0f0"))))
   (service static-networking-service-type
            (list (static-networking
                   (addresses
                    (list
                     (network-address
                      (device "enp129s0f0")
                      (value "192.168.0.1/24"))))
                   (provision '(fpga-static-networking)))))
   (simple-service 'set-mtu shepherd-root-service-type
                   (list (shepherd-service
                          (provision '(set-mtu))
                          (requirement '(networking))
                          (one-shot? #t)
                          (start #~(make-system-constructor
                                    #$iproute "/sbin/ip link set dev enp129s0f0 mtu 9000")))))
   (operating-system-user-services base-operating-system)))

 ;; This server will have a couple admin users
 (users
  (append
    (map admin-user '("liam" "vikram" "kiran"))
    (operating-system-users base-operating-system))))
