(define-module (grex packages katcp)
 #:use-module (guix packages)
 #:use-module (guix licenses)
 #:use-module (guix build-system python))

(define-public python-katcp
  (package
  (name "python-katcp")
  (version "0.9.1")
  (source (origin
           (method url-fetch)
           (uri (pypi-uri "katcp" version))
           (sha256
            (base32
             "0s10qg2b7b360js9hp8s8g1dzlp9gkffqgj80jfh1kbs8998vmck"))))
  (build-system python-build-system)
  (propagated-inputs (list python-future python-ply python-tornado))
  (home-page "https://github.com/ska-sa/katcp-python")
  (synopsis "Karoo Array Telescope Communication Protocol library")
  (description "Karoo Array Telescope Communication Protocol library")
  (license license:bsd-3)))
