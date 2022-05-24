(define-module (grex packages dedisp)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (grex packages cuda))

(define-public dedisp
  (let ((commit "3b3d24d31ce09220810d3130d335d86739b0bdb5")
        (revision "54"))
    (package
     (name "dedisp")
     (version (git-version "1.0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/dedisp")
                    (commit commit)))
              (sha256 (base32 "1n2wi9q5awnjfmfrqqrvpjffmbih2rzpf34s57i18vc29923awfv"))))
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
