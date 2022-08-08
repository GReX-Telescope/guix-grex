(define-module (grex packages cuda)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (non-free cuda))

(define-public cuda-11.5
  (package
   (inherit cuda-11.0)
   (version "11.5.2")
   (source
    (origin
     (uri "https://developer.download.nvidia.com/compute/cuda/11.5.2/local_installers/cuda_11.5.2_495.29.05_linux.run")
     (sha256 (base32 "19kkgfcq33q30xnj7mnc82h5vcj1fqn35bis19pm5fmw0azrm5bl"))
     (method url-fetch)))))

;; Pin this to 11.5 to make sure CMake/Thrust is happy
(define-public cuda-grex cuda-11.5)
