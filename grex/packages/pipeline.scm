(define-module (grex packages pipeline)
  #:use-module (non-free cuda)
  #:use-module (grex packages python)
  #:use-module (grex packages rust)
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
  (let ((commit "53290bccee17f7bb4224d18b65ffcf032f48e922")
        (revision "38"))
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
                "15b4lf6a8z4k7q2vh2xqklh16cgr3h9m6jnzndqw9prxn0245jir"))))
     (build-system python-build-system)
     (propagated-inputs (list python-loguru python-casperfpga))
     (native-inputs (list python-black))
     (home-page "https://github.com/GReX-Telescope/snapctl")
     (synopsis "SNAP FPGA bringup routines for GReX")
     (description "SNAP FPGA bringup routines for GReX")
     (license expat))))

(define-public grex-t0
  (let ((commit "3377ca2366bfa6275350bfb8a01f9bce48c24cc4")
        (revision "303"))
    (package
     (name "grex-t0")
     (version (git-version "0.4.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/GReX-T0")
                    (commit commit)))
              (sha256
               (base32
                "1fgrr4yqjsfjmdx4lj2p8ljab5bfh2l927f53350aixiykb5fix0"))))
     (build-system cargo-build-system)
     (inputs (list))
     (home-page "https://github.com/GReX-Telescope/GReX-T0")
     (synopsis "Tier-0 processing for GReX")
     (description "Capture packets, decode them, sort, downsample, and exfil")
     (license expat))))
