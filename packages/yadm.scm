(define-module (yadm)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages)
	       #:use-module (guix download)
	       #:use-module (guix utils)
	       #:use-module (guix build-system gnu))

(define-public yadm
  (package
    (name "yadm")
    (version "3.2.2")
    (source (origin
	      (method url-fetch)
	      (uri (string-append
		     "https://github.com/TheLocehiliosan/" name "/archive/refs/tags/" version ".tar.gz"))
	      (sha256
		(base32
		  "1b9k9izi9kxwicqsa06gdh8q1mkad3dbrn11ib0f8p4r923m1yy5"))))
    (build-system gnu-build-system)
    (arguments
      (list
	#:phases
	#~(modify-phases %standard-phases
	     (delete 'configure)
	     (delete 'bootstrap')
	     (delete 'build'))))
    (synopsis "yadm")
    (description "yadm")
    (home-page "https://yadm.io/")
    (license license:gpl3+)))
