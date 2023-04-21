(define-module (grex packages python)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (gnu packages astronomy)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages sphinx)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages machine-learning)
  #:use-module (gnu packages python-science)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages databases)
  #:use-module (guix build-system python)
  #:use-module (guix git-download)
  #:use-module (guix licenses))

(define-public python-iqrm
  (package
   (name "python-iqrm")
   (version "0.1.0")
   (source (origin
            (method url-fetch)
            (uri (pypi-uri "iqrm" version))
            (sha256
             (base32 "0nmj3zna6v77b3d2cac9a698h4lc2wa3a07ymqxmvvxfzhmhr9ay"))))
   (build-system python-build-system)
   (propagated-inputs (list python-numpy))
   (native-inputs (list python-pytest python-pytest-cov))
   (home-page "https://github.com/v-morello/iqrm")
   (synopsis
    "A minimal implementation of the IQRM interference flagging algorithm")
   (description
    "This package provides a minimal implementation of the IQRM interference flagging
algorithm")
   (license expat)))

(define-public python-sigpyproc
  (let ((commit "8c2103c0194e254019fa94b765e65b66f10f58b0")
        (revision "145"))
    (package
     (name "python-sigpyproc")
     (version (git-version "1.0.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/FRBs/sigpyproc3")
                    (commit commit)))
              (sha256
               (base32 "0mnxqnf9ysjv355849wnym7rwy1dkr9jl3vq69ws4gq3w6gwia0f"))))
     (build-system python-build-system)
     (propagated-inputs (list python-numpy python-astropy python-numba python-bottleneck python-scipy
                              python-bidict python-h5py python-attrs python-rich python-click python-iqrm))
     (native-inputs (list python-pytest python-pytest-cov))
     (home-page "https://github.com/FRBs/sigpyproc3")
     (synopsis "Python3 version of Ewan Barr's sigpyproc library")
     (description "sigpyproc is a pulsar and FRB data analysis library for python.
It provides an OOP approach to pulsar data handling through the use of objects
representing different data types (e.g. SIGPROC filterbank, PSRFITS, time-series,
fourier-series, etc.). As pulsar data processing is often time critical, speed
is maintained using the excellent numba library.")
     (license expat))))

(define-public python-loguru
  (package
   (name "python-loguru")
   (version "0.6.0")
   (source (origin
            (method url-fetch)
            (uri (pypi-uri "loguru" version))
            (sha256
             (base32
              "076l16ilgdb0pjbbkx21d39kzysvlyswdnbghgli79fhb1kx0sq6"))))
   (build-system python-build-system)
   (native-inputs (list python-black
                        python-colorama
                        python-docutils
                        python-flake8
                        python-isort
                        python-pytest
                        python-pytest-cov
                        python-sphinx
                        python-sphinx-autobuild
                        python-sphinx-rtd-theme
                        python-tox))
   (home-page "https://github.com/Delgan/loguru")
   (synopsis "Python logging made (stupidly) simple")
   (description "Python logging made (stupidly) simple")
   (license expat)))

(define-public python-odict
  (package
   (name "python-odict")
   (version "1.9.0")
   (source (origin
            (method url-fetch)
            (uri (pypi-uri "odict" version))
            (sha256
             (base32
              "0i1bdkrzjdpwcmriz6j18si8859zm8ikx6pqkjzp9mfkdz20ajpw"))))
   (build-system python-build-system)
   (propagated-inputs (list python-setuptools))
   (home-page "https://github.com/conestack/odict")
   (synopsis "Ordered Dictionary.")
   (description "Ordered Dictionary.")
   (license psfl)))

(define-public python-crcmod
  (package
   (name "python-crcmod")
   (version "1.7")
   (source (origin
            (method url-fetch)
            (uri (pypi-uri "crcmod" version))
            (sha256
             (base32
              "07k0hgr42vw2j92cln3klxka81f33knd7459cn3d8aszvfh52w6w"))))
   (build-system python-build-system)
   (home-page "http://crcmod.sourceforge.net/")
   (synopsis "CRC Generator")
   (description "CRC Generator")
   (license expat)))

(define-public python-katversion
  (package
   (name "python-katversion")
   (version "1.2")
   (source (origin
            (method url-fetch)
            (uri (pypi-uri "katversion" version))
            (sha256
             (base32
              "18k4d7fpw2iaxh1793bxazvx4limx253pc4avvsdx3s4kadd9ic7"))))
   (build-system python-build-system)
   (native-inputs (list python-wheel))
   (arguments '(#:tests? #f))
   (home-page "https://github.com/ska-sa/katversion")
   (synopsis "Reliable git-based versioning for Python packages")
   (description "Reliable git-based versioning for Python packages")
   (license bsd-3)))

(define-public python-katcp
  (let ((commit "eaffc934bc543508ac68c5b205a2e4b67a1c958d")
        (revision "1721"))
    (package
     (name "python-katcp")
     (version (git-version "0.9.3" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/katcp-python")
                    (commit commit)))
              (sha256
               (base32
                "1vxvzlajazxdhvswx3nifvbbziwii1s7qga1gs3kwsb7ij4mqcal"))))
     (build-system python-build-system)
     (propagated-inputs (list python-future python-ply python-tornado python-katversion python-wheel))
     (native-inputs (list python-nose python-mock))
     ;; Lots of stuff failing because SARAO doesn't know how to use python 3
     (arguments '(#:tests? #f))
     (home-page "https://github.com/ska-sa/katcp-python")
     (synopsis "Karoo Array Telescope Communication Protocol library")
     (description "Karoo Array Telescope Communication Protocol library")
     (license bsd-3))))

(define-public python-casperfpga
  (let ((commit "bd5aac4a50c79f7576b6c5678dadff9da82a91d8")
        (revision "1347"))
    (package
     (name "python-casperfpga")
     (version (git-version "0.1.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/casperfpga")
                    (commit commit)))
              (sha256
               (base32
                "0rapaw7cyjbh0faywyshl0x26bf8nsc6psi7qapj29rqcnjrrhwg"))))
     (build-system python-build-system)
     (arguments '(#:tests? #f))
     (propagated-inputs (list python-numpy
                              python-katcp
                              python-tornado
                              python-redis
                              python-future
                              python-tftpy
                              python-odict
                              python-crcmod
                              python-requests
                              python-progressbar2))
     (home-page "https://github.com/GReX-Telescope/casperfpga")
     (synopsis "Software control for CASPER FPGAs ")
     (description "Software control for CASPER FPGAs ")
     (license gpl2))))
