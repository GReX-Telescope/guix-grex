(define-module (grex packages psrdada)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mpi)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (grex packages cuda))

(define-public psrdada
  (let ((commit "78b01e857a765caade0c1efaaab4558913e035ec")
        (revision "1"))
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
