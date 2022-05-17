(define-module (system grex-01)
  #:use-module (system base)
  #:use-module (gnu))

(define host "grex-01")

(operating-system
 (inherit base-operating-system)
 (host-name host)
 (file-systems (cons*
                (file-system
                 (device (uuid "abc123"))
                 (mount-point "/")
                 (type "ext4"))
                (file-system
                 (device "/dev/foobar")
                 (mount-point "/boot/efi")
                 (type "vfat"))
                %base-file-systems)))
