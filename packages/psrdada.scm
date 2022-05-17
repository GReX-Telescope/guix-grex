(define-module (packages psrdada)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages mpi)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (non-free cuda))

(define-public psrdada
  (let ((commit "98d820ea95c055c65547fcdea11d7db3c7be86c6")
        (revision "1"))
    (package-with-c-toolchain
     (package
      (name "psrdada")
      (version (git-version "0.0.0" revision commit))
      (source (origin
               (method git-fetch)
               (uri (git-reference
                     (url "https://github.com/GReX-Telescope/psrdada")
                     (commit commit)))
               (sha256 (base32 "1zwi7jln2j5kb3zyr1csh616zh59wiqswds45fsqi0ylnr6amz9d"))))
      (build-system cmake-build-system)
      (inputs (list cuda-11.0 rdma-core hwloc))
      (synopsis "PSRDADA is an Open Source software project to support the development of data acquisition and distributed analysis systems")
      (description
       "DADA stands for Distributed Acquisition and Data Analysis, and it consist of a C library and applications.
The modular design of PSRDADA includes:
    relatively small, independent processes that perform specific tasks, neatly separating data transport, command and control, and data reduction;
    data transfer between processes via a flexible ring buffer in shared memory and a variety of internet protocols; and
    control and monitoring of distributed processes via scripts, configuration files, text-based socket connections, and a web-based user interface.")
      (license gpl3)
      (home-page "https://github.com/GReX-Telescope/psrdada"))
     `(("toolchain" ,(specification->package "gcc-toolchain@8"))))))
