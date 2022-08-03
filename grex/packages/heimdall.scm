(define-module (grex packages heimdall)
  #:use-module (grex packages psrdada)
  #:use-module (grex packages dedisp)
  #:use-module (grex packages cuda)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages boost)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses))

(define-public heimdall-astro
  (let ((commit "9d3cb9e90678ac1761aec12928b865ef0dd5dcf6")
        (revision "106"))
    (package
     (name "heimdall-astro")
     (version (git-version "0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/heimdall-astro")
                    (commit commit)))
              (sha256
               (base32 "05x7g5fcm0v3s3bgg88ldnl27d49vdd39glf5cc39zx6gi69vi7g"))))
     (build-system cmake-build-system)
     (arguments '(#:tests? #f))
     (inputs (list cuda-grex psrdada dedisp boost rdma-core))
     (synopsis "Transient Detection Pipeline")
     (description "")
     (home-page "https://github.com/GReX-Telescope/heimdall-astro")
     (license gpl3))))
