(define-module (grex packages dedisp)
  #:use-module (guix packages)
  #:use-module (gnu packages algebra)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (non-free cuda))

(define-public dedisp
  (let ((commit "a146973db0b5080f1e2d8891af5285e66bee9829")
        (revision "1"))
    (package
     (name "dedisp")
     (version (git-version "0.0.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/dedisp")
                    (commit commit)))
              (sha256 (base32 "14nr4mp9gwgq2a4bbm1442dv0pkx7w72wszvcbig5d5yk62vkjw6"))))
     (build-system cmake-build-system)
     (inputs
      `(("cuda-toolkit",cuda)
        ("fftw",fftw)
        ("fftwf",fftwf)))
     (synopsis "CUDA Based De-dispersion library")
     (description
      "This repository is derived from Ben Barsdell's original GPU De-dedispersion library
(code.google.com/p/dedisp) And forked from https://github.com/ajameson/dedisp. This fork adds
an improved (performance) implementation of dedisp, referred to as Time Domain Dedispersion
(TDD) and adds a new dedispersion algorithm for Fourier Domain Dedispersion (FDD).")
     (home-page "https://github.com/GReX-Telescope/dedisp")
     (license asl2.0))))

dedisp
