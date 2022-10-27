(define-module (grex packages pipeline)
  #:use-module (grex packages cuda)
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
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (guix licenses))

(define-public heimdall-dsa
  (let ((commit "25f0da0bb2ae13cfbcfbfbf71e301b5609b8d238")
        (revision "112"))
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
               (base32 "10xhg2lyiv8i0r93bm5kzbny03nv9p2w0y4h2j29rkgy8fpm3aq5"))))
     (build-system cmake-build-system)
     (arguments '(#:tests? #f))
     (inputs (list cuda-grex psrdada boost rdma-core))
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
     (inputs (list cuda-grex rdma-core hwloc))
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
  (let ((commit "c419d32315206de7dfb5064c3ea62ab2e6d78239")
        (revision "14"))
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
                "0an5h2ls7mrpnsss99r6h59f6h57vv5a6g2qxxqi767q5aa434ri"))))
     (build-system python-build-system)
     (propagated-inputs (list python-loguru python-casperfpga))
     (native-inputs (list python-black))
     (home-page "https://github.com/GReX-Telescope/snapctl")
     (synopsis "SNAP FPGA bringup routines for GReX")
     (description "SNAP FPGA bringup routines for GReX")
     (license expat))))
