;;; This module extends GNU Guix and is licensed under the same terms, those
;;; of the GNU GPL version 3 or (at your option) any later version.
;;;
;;; However, note that this module provides packages for "non-free" software,
;;; which denies users the ability to study and modify it.  These packages
;;; are detrimental to user freedom and to proper scientific review and
;;; experimentation.  As such, we kindly invite you not to share it.
;;;
;;; Copyright © 2018, 2019, 2020 Inria
;;; Copyright 2022, Kiran Shila

(define-module (grex packages cuda)
  #:use-module (guix)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages python)
  #:use-module (ice-9 match))

(define (make-cuda version origin)
  (package
    (name "cuda-toolkit")
    (version version)
    (source origin)
    (build-system gnu-build-system)
    (outputs '("out"
               "doc"))                            ;196 MiB
    (arguments
     `(#:modules ((guix build utils)
                  (guix build gnu-build-system)
                  (ice-9 match))

       ;; Let's not publish or obtain substitutes for that.
       #:substitutable? #f

       #:strip-binaries? #f                       ;no need

       ;; XXX: This would check DT_RUNPATH, but patchelf populate DT_RPATH,
       ;; not DT_RUNPATH.
       #:validate-runpath? #f

       #:phases (modify-phases %standard-phases
                  (replace 'unpack
                    (lambda* (#:key inputs #:allow-other-keys)
                      (let ((source (assoc-ref inputs "source")))
                        (invoke "sh" source "--keep" "--noexec")
                        (chdir "pkg/run_files")
                        (match (find-files "." "^cuda-linux64-rel.*\\.run$")
                          ((run)
                           (invoke "sh" run "--keep" "--noexec")))
                        (chdir "pkg"))))
                  (delete 'configure)
                  (delete 'check)
                  (replace 'build
                    (lambda* (#:key inputs outputs #:allow-other-keys)
                      (define out
                        (assoc-ref outputs "out"))
                      (define libc
                        (assoc-ref inputs "libc"))
                      (define gcc-lib
                        (assoc-ref inputs "gcc:lib"))
                      (define ld.so
                        (string-append libc ,(glibc-dynamic-linker)))
                      (define rpath
                        (string-join (list "$ORIGIN"
                                           (string-append out "/lib")
                                           (string-append out "/nvvm/lib64")
                                           (string-append libc "/lib")
                                           (string-append gcc-lib "/lib"))
                                     ":"))

                      (define (patch-elf file)
                        (make-file-writable file)
                        (unless (string-contains file ".so")
                          (format #t "Setting interpreter on '~a'...~%" file)
                          (invoke "patchelf" "--set-interpreter" ld.so
                                  file))
                        (format #t "Setting RPATH on '~a'...~%" file)
                        (invoke "patchelf" "--set-rpath" rpath
                                "--force-rpath" file))

                      (for-each (lambda (file)
                                  (when (elf-file? file)
                                    (patch-elf file)))
                                (find-files "."
                                            (lambda (file stat)
                                              (eq? 'regular
                                                   (stat:type stat)))))
                      #t))
                  (replace 'install
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let* ((out   (assoc-ref outputs "out"))
                             (lib   (string-append out "/lib"))
                             (lib64 (string-append out "/lib64")))
                        (mkdir-p out)
                        (setenv "PERL5LIB" (getcwd)) ;for InstallUtils.pm
                        (invoke "perl" "install-linux.pl"
                                (string-append "--prefix=" out))
                        (rename-file lib64 lib)
                        #t)))
                  (add-after 'install 'move-documentation
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let* ((out    (assoc-ref outputs "out"))
                             (doc    (assoc-ref outputs "doc"))
                             (docdir (string-append doc "/share/doc/cuda")))
                        (mkdir-p (dirname docdir))
                        (rename-file (string-append out "/doc") docdir)
                        #t))))))
    (native-inputs
     `(("patchelf" ,patchelf)
       ("perl" ,perl)
       ("python" ,python-2)))
    (inputs
     `(("gcc:lib" ,gcc "lib")))
    (synopsis
     "Compiler for the CUDA language and associated run-time support")
    (description
     "This package provides the CUDA compiler and the CUDA run-time support
libraries for NVIDIA GPUs, all of which are proprietary.")
    (home-page "https://developer.nvidia.com/cuda-toolkit")
    (license #f)
    (supported-systems '("x86_64-linux"))))

(define-syntax-rule (cuda-source url hash)
  ;; Visit
  ;; <https://developer.nvidia.com/cuda-10.2-download-archive?target_os=Linux&target_arch=x86_64&target_distro=Fedora&target_version=29&target_type=runfilelocal> or similar to get the actual URL.
  (origin
    (uri url)
    (sha256 (base32 hash))
    (method url-fetch)))

(define-public cuda-8.0
  (make-cuda "8.0.61"
             (cuda-source
              "https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run"
              "1i4xrsqbad283qffvysn88w2pmxzxbbby41lw0j1113z771akv4w")))

(define-public cuda-11.7
  (package
    (inherit cuda-8.0)
    (version "11.7.0")
    (source
     (cuda-source
      "https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda_11.7.0_515.43.04_linux.run"
      "09igi62w2vg143ldshnh8ar6spxczn6kmr3q3wxm8y8zpb5xyzq8"))
    (outputs '("out"))                         ;XXX: no documentation for now
    (arguments
     (substitute-keyword-arguments (package-arguments cuda-8.0)
       ((#:modules modules)
        `((guix build utils)
          (guix build gnu-build-system)
          (ice-9 match)
          (ice-9 ftw)))                           ;for 'scandir'
       ((#:phases phases)
        `(modify-phases ,phases
           (replace 'unpack
             (lambda* (#:key inputs #:allow-other-keys)
               (define libc
                 (assoc-ref inputs "libc"))
               (define ld.so
                 (string-append libc ,(glibc-dynamic-linker)))

               (let ((source (assoc-ref inputs "source")))
                 (invoke "sh" source "--keep" "--noexec")
                 (chdir "pkg")
                 #t)))
           (add-after 'unpack 'remove-superfluous-stuff
             (lambda _
               ;; Remove things we have no use for.
               (with-directory-excursion "builds"
                 (for-each delete-file-recursively
                           '("nsight_compute" "nsight_systems" "cuda_gdb")))
               #t))
           (replace 'install
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let ((out (assoc-ref outputs "out")))
                 (define (copy-from-directory directory)
                   (for-each (lambda (entry)
                               (define sub-directory
                                 (string-append directory "/" entry))

                               (define target
                                 (string-append out "/" (basename entry)))

                               (when (file-exists? sub-directory)
                                 (copy-recursively sub-directory target)))
                             '("bin" "targets/x86_64-linux/lib"
                               "targets/x86_64-linux/include"
                               "nvvm/bin" "nvvm/include"
                               "nvvm/lib64")))

                 (setenv "COLUMNS" "200")         ;wide backtraces!
                 (with-directory-excursion "builds"
                   (for-each copy-from-directory
                             (scandir "." (match-lambda
                                            ((or "." "..") #f)
                                            (_ #t))))

                   ;; 'cicc' needs that directory.
                   (copy-recursively "cuda_nvcc/nvvm/libdevice"
                                     (string-append out "/nvvm/libdevice")))
                 #t)))
           ;; XXX: No documentation for now.
           (delete 'move-documentation)))))
    (native-inputs
     `(("which" ,which)
       ,@(package-native-inputs cuda-8.0)))))

(define-public cuda-11.6
  (package
   (inherit cuda-11.7)
   (version "11.6.2")
   (source
    (cuda-source
     "https://developer.download.nvidia.com/compute/cuda/11.6.2/local_installers/cuda_11.6.2_510.47.03_linux.run"
     "14s53nxdmvyrfwb2q204cjdsq59h1jkb9khz9kpjr9ajrhysgdwr"))))

(define-public cuda-11.5
  (package
   (inherit cuda-11.7)
   (version "11.5.2")
   (source
    (cuda-source
     "https://developer.download.nvidia.com/compute/cuda/11.5.2/local_installers/cuda_11.5.2_495.29.05_linux.run"
     "14s53nxdmvyrfwb2q204cjdsq59h1jkb9khz9kpjr9ajrhysgdwr"))))

(define-public cuda-grex cuda-11.5)
