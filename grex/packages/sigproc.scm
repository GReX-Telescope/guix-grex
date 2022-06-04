(define-module (grex packages sigproc)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages astronomy)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages xml)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses))

(define-public sigproc
  (let ((commit "50619d280329318a24c65902de43e2eb3368d2c6")
        (revision "176"))
    (package
     (name "sigproc")
     (version (git-version "5.0.4" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/UCBerkeleySETI/bl_sigproc")
                    (commit commit)))
              (sha256
               (base32 "0vvbbkx5cksy6dxsmggfscjfasmzdyhi6gra90skk4b024a6l0wf"))))
     (build-system gnu-build-system)
     (native-inputs (list
                     libtool autoconf automake tcsh gfortran-toolchain fftw cfitsio libxml2 perl gsl))
     (synopsis "Michael Keith's release of Duncan Lorimer's SIGPROC")
     (description "SIGPROC is a package designed to standardize the initial analysis of
the many types of fast-sampled pulsar data. Currently recognized machines are the
Wide Band Arecibo Pulsar Processor (WAPP), the Penn State Pulsar Machine (PSPM),
the Arecibo Observatory Fourier Transform Machine (AOFTM), the Berkeley Pulsar
Processors (BPP), the Parkes/Jodrell 1-bit filterbanks (SCAMP) and the filterbank
at the Ooty radio telescope (OOTY). The SIGPROC tools should help users look at their
data quickly, without the need to write (yet) another routine to read data or worry
about big/little endian compatibility (byte swapping is handled automatically).")
     (home-page "http://sigproc.sourceforge.net/")
     (license public-domain))))
