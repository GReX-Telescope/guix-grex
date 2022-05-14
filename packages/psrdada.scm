(define-module (packages psrdada)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages mpi)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix licenses)
  #:use-module (non-free cuda)
  #:use-module (non-free mkl))

(define-public psrdada
  (let ((commit "e9870e2f13778193424a235b06ca56e53a94f832")
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
               (sha256 (base32 "1vifwp2ygxa7kh10n972dqpcx49d3j7wfbjfriq88kq6klj2q7r0"))))
      (build-system cmake-build-system)
      (inputs (list cuda-11.0 fftw fftwf rdma-core mkl gsl hwloc))
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
