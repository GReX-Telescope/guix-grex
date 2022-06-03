(define-module (grex packages capture)
  #:use-module (grex packages psrdada)
  #:use-module (grex packages cuda)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages astronomy)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses))

(define-public capture
  (let ((commit "a9241e287b4f69a47f33a2673b54744989bbc827")
        (revision "7"))
    (package
     (name "capture")
     (version (git-version "0.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/capture")
                    (commit commit)))
              (sha256
               (base32 "1d71yrjbb48l3h29vcp1lbkfz8v37y9f38ywf6q8avx19n0rd9h2"))))
     (build-system cmake-build-system)
     (inputs (list cuda-grex psrdada dedisp cfitsio))
     (synopsis "Chris' packet capture code from STARE2")
     (description "")
     (home-page "https://github.com/GReX-Telescope/capture")
     (license unknown))))
