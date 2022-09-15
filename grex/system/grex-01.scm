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

# A simple firewall
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    # early drop of invalid connections
    ct state invalid drop
    # allow established/related connections
    ct state { established, related } accept
    # allow from loopback
    iifname lo accept
    # allow from 10gbe
    ifname enp129s0f0 accept
    # allow icmp
    ip protocol icmp accept
    ip6 nexthdr icmpv6 accept
    # allow ssh
    tcp dport ssh accept
    # reject everything else
    reject with icmpx type port-unreachable
  }
  chain output {
    type filter hook output priority 0; policy accept;
  }
}

# Allow the internet on eno1 to be shared
table inet nat {
    chain postrouting {
        type nat hook postrouting priority 100;
        oifname eno1 masquerade;
    }
}
"))))
   (service dhcpd-service-type
            (dhcpd-configuration
             (config-file (plain-file "dhcpd.conf" "
subnet 192.168.0.0 netmask 255.255.255.0 {
  range 192.168.0.2 192.168.0.10;
  option routers 192.168.0.1;
}
"))
             (interfaces '("enp129s0f0"))))
   (service static-networking-service-type
            (list (static-networking
                   (addresses
                    (list
                     (network-address
                      (device "enp129s0f0")
                      (value "192.168.0.1/24"))))
                   (provision '(fpga-static-networking)))))
   (operating-system-user-services base-operating-system)))

 ;; This server will have a couple admin users
 (users
  (append
    (map admin-user '("liam" "vikram" "kiran"))
    (operating-system-users base-operating-system))))
