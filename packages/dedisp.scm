(define-module (packages dedisp)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (non-free cuda))

(define-public dedisp
  (let ((commit "ea08d4f2faaea885afca0d522f611a71642d298a")
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
               (sha256 (base32 "0cwsi4k90rj5p6zxb855pdgv4msnqj8x3is4z3gwwnxzwgb753ns"))))
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
