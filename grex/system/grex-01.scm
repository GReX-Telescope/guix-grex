(define-module (grex system grex-01)
  #:use-module (grex system base)
  #:use-module (gnu))

(define host "grex-01")

(operating-system
 (inherit base-operating-system)
 (host-name host)
 (file-systems (cons*
                (file-system
                 (device "/dev/sda2")
                 (mount-point "/")
                 (type "ext4"))
                (file-system
                 (device "/dev/sda1")
                 (mount-point "/boot/efi")
                 (type "vfat"))
                %base-file-systems)))
