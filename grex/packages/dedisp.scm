(define-module (grex packages dedisp)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (grex packages cuda))

(define-public dedisp
  (let ((commit "76b1e7bf82ccee64934fdb757eb538b9d5da8a28")
        (revision "58"))
    (package
     (name "dedisp")
     (version (git-version "1.0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/dedisp")
                    (commit commit)))
              (sha256 (base32 "1m99bbjsc67j9sagrq7afcwhl645g7bd23dgg8l113q4z1m84c0n"))))
     (build-system cmake-build-system)
     (arguments '(#:tests? #f))
     (inputs (list cuda-grex))
     (synopsis "CUDA Based De-dispersion library")
     (description
      "This repository is derived from Ben Barsdell's original GPU De-dedispersion library
(code.google.com/p/dedisp) And forked from https://github.com/ajameson/dedisp. This fork adds
an improved (performance) implementation of dedisp, referred to as Time Domain Dedispersion
(TDD) and adds a new dedispersion algorithm for Fourier Domain Dedispersion (FDD).")
     (home-page "https://github.com/GReX-Telescope/dedisp")
     (license asl2.0))))
