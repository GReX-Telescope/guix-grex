(define-module (grex packages heimdall-astro)
  #:use-module (grex packages psrdada)
  #:use-module (grex packages dedisp)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages boost)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (non-free cuda))

(define-public heimdall-astro
  (let ((commit "05de726d2b78c41de6439eb12583da2437829e7d")
        (revision "1"))
    (package-with-c-toolchain
     (package
      (name "heimdall-astro")
      (version (git-version "0.1" revision commit))
      (source (origin
               (method git-fetch)
               (uri (git-reference
                     (url "https://github.com/GReX-Telescope/heimdall-astro")
                     (commit commit)))
               (sha256 (base32 "0yj0bizdzch37qksga1cw2l251il37vl0759z2swi5af13alnbj8"))))
      (build-system cmake-build-system)
      (inputs (list cuda-11.0 psrdada dedisp boost))
      (synopsis "Transient Detection Pipeline")
      (description "")
      (home-page "https://github.com/GReX-Telescope/heimdall")
      (license gpl3))
     `(("toolchain" ,(specification->package "gcc-toolchain@8"))))))
