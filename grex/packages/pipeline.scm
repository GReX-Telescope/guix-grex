(define-module (grex packages pipeline)
  #:use-module (grex packages cuda)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages base)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages mpi)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix licenses))

(define-public heimdall-dsa
  (let ((commit "557aea04ce91329adc0d454a8199ee4f4593139c")
        (revision "109"))
    (package
     (name "heimdall-astro")
     (version (git-version "0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/heimdall-astro")
                    (commit commit)))
              (sha256
               (base32 "1nw35ci10xsihi9abihsqcsa12mpvyfhhywfb03b6jpl4rcij78z"))))
     (build-system cmake-build-system)
     (arguments '(#:tests? #f))
     (inputs (list cuda-grex psrdada dedisp boost rdma-core))
     (synopsis "Transient Detection Pipeline - DSA110 single beam branch")
     (description "")
     (home-page "https://github.com/GReX-Telescope/heimdall-astro")
     (license gpl3))))

(define-public dedisp
  (let ((commit "4e05d601c8fa6730dae9a94e41c6b3af2e693776")
        (revision "61"))
    (package
     (name "dedisp")
     (version (git-version "1.0.1" revision commit))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/GReX-Telescope/dedisp")
                    (commit commit)))
              (sha256 (base32 "050swi2dx3nzkvii9w9j9524f64s78f00m7hdmqahj7d9z0csywj"))))
     (build-system cmake-build-system)
     (arguments '(#:tests? #f)) ; Requires a CUDA runtime
     (inputs (list cuda-grex))
     (synopsis "CUDA Based De-dispersion library")
     (description
      "This repository is derived from Ben Barsdell's original GPU De-dedispersion library
(code.google.com/p/dedisp) And forked from https://github.com/ajameson/dedisp. This fork adds
an improved (performance) implementation of dedisp, referred to as Time Domain Dedispersion
(TDD) and adds a new dedispersion algorithm for Fourier Domain Dedispersion (FDD).")
     (home-page "https://github.com/GReX-Telescope/dedisp")
     (license asl2.0))))

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
