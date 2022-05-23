(define-module (grex packages heimdall-astro)
  #:use-module (grex packages psrdada)
  #:use-module (grex packages dedisp)
  #:use-module (grex packages cuda)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages boost)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses))

(define-public heimdall-astro
  (let ((commit "d6047187e407cf22e6bd9a8bdfd77a683f6a1835")
        (revision "1"))
    (package
     (name "heimdall-astro")
     (version (git-version "0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/heimdall-astro")
                    (commit commit)))
              (sha256
               (base32 "0pc8xgjvl860ska5xgkmnk2j5fz2ljx73jq54x9wl74sd9cqvh7w"))))
     (build-system cmake-build-system)
     (arguments '(#:tests? #f))
     (inputs (list cuda-11.7 psrdada dedisp boost))
     (synopsis "Transient Detection Pipeline")
     (description "")
     (home-page "https://github.com/GReX-Telescope/heimdall-astro")
     (license gpl3))))
