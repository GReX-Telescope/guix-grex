(define-module (grex packages nvidia)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (nongnu packages nvidia))

(define nvidia-version "510.73.05")

(define driver-source
  (origin
   (uri (format #f "http://us.download.nvidia.com/XFree86/Linux-x86_64/~a/~a.run"
                version
                (format #f "NVIDIA-Linux-x86_64-~a" version)))
   (sha256 (base32 "1cjp12p6kwpdq9m9j7a6hzy7p307kg4gy6jyslfr9lkkpiqzm1w0"))
   (method url-fetch)
   (file-name (string-append "nvidia-driver-" nvidia-version "-checkout"))))

(define-public nvidia-driver-510
  (package
   (inherit nvidia-driver)
   (version nvidia-version)
   (source driver-source)))

(define-public nvidia-libs-510
  (package
   (inherit nvidia-libs)
   (version nvidia-version)
   (source driver-source)))

(define-public nvidia-settings-510
  (package
   (inherit nvidia-settings)
   (version nvidia-version)
   (source
    (origin
     (uri (git-reference
           (url "https://github.com/NVIDIA/nvidia-settings")
           (commit version)))
     (sha256 (base32 "0lnj5hwmfkzs664fxlhljqy323394s1i7qzlpsjyrpm07sa93bky"))
     (method git-fetch)
     (file-name (git-file-name "nvidia-settings" version))))))
