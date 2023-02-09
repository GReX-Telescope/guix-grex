(define-module (grex packages rust)
  #:use-module (gnu packages)
  #:use-module (gnu packages crates-io)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system cargo)
  #:use-module (guix git-download)
  #:use-module (guix licenses))

(define-public rust-casperfpga
  (let ((commit "58ce65d013e7ae15cb37eada67652cc33506a3c2")
        (revision "49"))
    (package
     (name "rust-casperfpga")
     (version (git-version "0.1.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/kiranshila/casperfpga_rs")
                    (commit commit)))
              (sha256
               (base32
                "1g70kkqazapdgy0fh8srzmdfc57czh4asxb5c7bwh3kbqcdnviny"))))
     (build-system cargo-build-system)
     (inputs (list rust-anyhow-1
                   rust-fixed-1
                   rust-indicatif-0.16)) ;; FIXME
     (home-page "https://github.com/kiranshila/casperfpga_rs")
     (synopsis "CASPER FPGA library for rust")
     (description "CASPER FPGA library for rust")
     (license expat))))
