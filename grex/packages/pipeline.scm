(define-module (grex packages pipeline)
  #:use-module (guix-science-nonfree packages cuda)
  #:use-module (grex packages python)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages base)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages )
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (guix build-system cargo)
  #:use-module (guix licenses))

(define-public heimdall-dsa
  (let ((commit "77a6a02396795d6e9369f66f602793cb6410279e")
        (revision "117"))
    (package
     (name "heimdall-astro")
     (version (git-version "0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/heimdall-astro")
                    (commit commit)
                    (recursive? #t)))
              (sha256
               (base32 "07k4lbqv2pa0lpjbgd7p13mch6y9v5l0dxz3xyv1kj3rvwcyjd5y"))))
     (build-system cmake-build-system)
     (arguments '(#:tests? #f))
     (inputs (list cuda psrdada boost rdma-core))
     (synopsis "Transient Detection Pipeline - DSA110 single beam branch")
     (description "")
     (home-page "https://github.com/GReX-Telescope/heimdall-astro")
     (license gpl3))))

(define-public psrdada
  (let ((commit "78b01e857a765caade0c1efaaab4558913e035ec")
        (revision "1998"))
    (package
     (name "psrdada")
     (version (git-version "1.0.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/psrdada")
                    (commit commit)))
              (sha256 (base32 "17v5ab1zgjbfnyj0ky1hf2ls6ps658a2dg7i78s38fk8yp243q7m"))))
     (build-system cmake-build-system)
     (inputs (list cuda rdma-core hwloc))
     (synopsis "PSRDADA is an Open Source software project to support the development of data acquisition and distributed analysis systems")
     (description
      "DADA stands for Distributed Acquisition and Data Analysis, and it consist of a C library and applications.
The modular design of PSRDADA includes:
    relatively small, independent processes that perform specific tasks, neatly separating data transport, command and control, and data reduction;
    data transfer between processes via a flexible ring buffer in shared memory and a variety of internet protocols; and
    control and monitoring of distributed processes via scripts, configuration files, text-based socket connections, and a web-based user interface.")
     (license gpl3)
     (home-page "https://github.com/GReX-Telescope/psrdada"))))

(define-public snapctl
  (let ((commit "0f6131834a7f721fcc8e5113fdcd7000fbb2bc84")
        (revision "41"))
    (package
     (name "snapctl")
     (version (git-version "0.1.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/snapctl")
                    (commit commit)))
              (sha256
               (base32
                "0cv37lh6g7jpv13lmsrlszrcndkx8d9k9x3m92y037wvbiw5d6zz"))))
     (build-system python-build-system)
     (propagated-inputs (list python-loguru python-casperfpga))
     (native-inputs (list python-black))
     (home-page "https://github.com/GReX-Telescope/snapctl")
     (synopsis "SNAP FPGA bringup routines for GReX")
     (description "SNAP FPGA bringup routines for GReX")
     (license expat))))
