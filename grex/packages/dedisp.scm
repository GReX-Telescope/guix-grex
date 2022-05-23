(define-module (grex packages dedisp)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (non-free cuda))

(define-public dedisp
  (let ((commit "24b909e0df2d0c3834f72789f6e655a6265ed23f")
        (revision "1"))
    (package-with-c-toolchain
     (package
      (name "dedisp")
      (version (git-version "1.0.1" revision commit))
      (source (origin
               (method git-fetch)
               (uri (git-reference
                     (url "https://github.com/GReX-Telescope/dedisp")
                     (commit commit)))
               (sha256 (base32 "0b2r4s89gfhy6ygnkbf9g4v5328gwdvxfh0037q7bwyx2mpf46a2"))))
      (build-system cmake-build-system)
      (arguments '(#:tests? #f))
      (inputs (list cuda-11.0))
      (synopsis "CUDA Based De-dispersion library")
      (description
       "This repository is derived from Ben Barsdell's original GPU De-dedispersion library
(code.google.com/p/dedisp) And forked from https://github.com/ajameson/dedisp. This fork adds
an improved (performance) implementation of dedisp, referred to as Time Domain Dedispersion
(TDD) and adds a new dedispersion algorithm for Fourier Domain Dedispersion (FDD).")
      (home-page "https://github.com/GReX-Telescope/dedisp")
      (license asl2.0))
     `(("toolchain" ,(specification->package "gcc-toolchain@8"))))))
