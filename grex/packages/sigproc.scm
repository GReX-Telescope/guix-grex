(define-module (grex packages sigproc)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages astronomy)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses))

(define-public sigproc
  (let ((commit "8f3a9a6632f15a146dd9e058a9a1ec807d1f992d")
        (revision "218"))
    (package
     (name "sigproc")
     (version (git-version "2014.5" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/FRBs/sigproc")
                    (commit commit)))
              (sha256
               (base32 "15qnjsmd84dwhfbqdk9khwms2558sn2h1qydlqwvn7w93bkbsny3"))))
     (build-system gnu-build-system)
     (native-inputs (list libtool autoconf automake))
     (inputs (list fftw cfitsio))
     (synopsis "Evan Keane's fork of Michael Keith's release of Duncan Lorimer's SIGPROC")
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
