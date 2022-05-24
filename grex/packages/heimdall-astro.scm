(define-module (grex packages heimdall-astro)
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
  (let ((commit "a63949249ae333bbe4253141019c62517c3baa81")
        (revision "3"))
    (package
     (name "heimdall-astro")
     (version (git-version "0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/heimdall-astro")
                    (commit commit)))
              (sha256
               (base32 "1d71yrjbb48l3h29vcp1lbkfz8v37y9f38ywf6q8avx19n0rd9h2"))))
     (build-system cmake-build-system)
     (arguments '(#:tests? #f))
     (inputs (list cuda-grex psrdada dedisp boost rdma-core))
     (synopsis "Transient Detection Pipeline")
     (description "")
     (home-page "https://github.com/GReX-Telescope/heimdall-astro")
     (license gpl3))))
