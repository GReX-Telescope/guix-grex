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
  (let ((commit "3b9179fef29875baa3226b76b2cac449b7c514fe")
        (revision "95"))
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
               (base32 "1v52hx6fjxj06j2rjskaayg2kfnkd04mfjmi9liij7g0mcwckqqh"))))
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

(define-public snap-bringup
  (let ((commit "283b68575efd614ad63dba5ccd889f474b6ba177")
        (revision "44"))
    (package
     (name "snap_bringup")
     (version (git-version "0.1.0" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/snap_bringup")
                    (commit commit)))
              (sha256
               (base32
                "073iad3njfy7xbxy6xbw6f376bshqf566xhd1rdk9462lj1m7a2y"))))
     (build-system python-build-system)
     (propagated-inputs (list python-loguru python-casperfpga))
     (native-inputs (list python-black))
     (home-page "https://github.com/GReX-Telescope/snap_bringup")
     (synopsis "SNAP FPGA bringup routines for GReX")
     (description "SNAP FPGA bringup routines for GReX")
     (license expat))))
