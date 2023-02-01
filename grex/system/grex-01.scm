;;; This is the system configuration for the "minor" test server
(define-module (grex system grex-01)
  #:declarative? #f
  #:use-module (gnu packages shells)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages networking)
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

 (services
  (cons*
   ;; Setup our simple firewall
   (service nftables-service-type
            (nftables-configuration
             (ruleset (local-file "./nftables.conf"))))
   ;; DHCP Client on the WAN ports
   (service dhcp-client-service-type
            (dhcp-client-configuration
             (interfaces '("eno1" "eno2"))))
   ;; Setup the static network for the 10 GbE port
   (service static-networking-service-type
            (list (static-networking
                   (provision '(static-networking))
                   (addresses
                    (list (network-address
                           (device "enp129s0f0")
                           (value "192.168.0.1/24")))))))
   ;; DHCP Server on the 10GbE line for SNAP, Pi, and ourselves
   (service dhcpd-service-type
            (dhcpd-configuration
             (config-file (local-file "./dhcpd.conf"))
             (interfaces '("enp129s0f0"))))
   ;; Hacky MTU setting
   (simple-service 'set-mtu shepherd-root-service-type
                   (list (shepherd-service
                          (provision '(set-mtu))
                          (requirement '(networking))
                          (one-shot? #t)
                          (start #~(make-system-constructor
                                    #$iproute "/sbin/ip link set dev enp129s0f0 mtu 9000")))))
   ;; Set the output queue length
   (simple-service 'set-queue shepherd-root-service-type
                   (list (shepherd-service
                          (provision '(set-queue))
                          (requirement '(networking))
                          (one-shot? #t)
                          (start #~(make-system-constructor
                                    #$iproute "/sbin/ip link set enp129s0f0 txqueuelen 138888")))))
   ;; Set the RX FIFO to maximum
   (simple-service 'set-ethtool shepherd-root-service-type
                   (list (shepherd-service
                          (provision '(set-ethtool))
                          (requirement '(networking))
                          (one-shot? #t)
                          (start #~(make-system-constructor
                                    #$ethtool "/sbin/ethtool -G enp129s0f0 rx 4078;/sbin/ethtool -C enp129s0f0 rx-usecs 0")))))
   (operating-system-user-services base-operating-system)))

 ;; This server will have a couple admin users
 (users
  (append
   (map admin-user '("liam" "vikram" "kiran"))
   (operating-system-users base-operating-system))))
