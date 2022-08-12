(define-module (grex packages python)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (gnu packages astronomy)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages machine-learning)
  #:use-module (gnu packages python-science)
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

(define-public python-attrs
  (package
   (name "python-attrs")
   (version "22.1.0")
   (source (origin
            (method url-fetch)
            (uri (pypi-uri "attrs" version))
            (sha256
             (base32
              "1di2kd18bc0sdq61sa24sdr9c7xjg3g8ymkw1qfikra7aikc5b99"))))
   (build-system python-build-system)
   (native-inputs (list python-cloudpickle python-coverage python-hypothesis python-mypy
                        python-pre-commit python-pympler python-pytest))
   (arguments '(#:tests? #f))
   (home-page "https://www.attrs.org/")
   (synopsis "Classes Without Boilerplate")
   (description "Classes Without Boilerplate")
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
