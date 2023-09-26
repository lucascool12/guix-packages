(define-module (packages yadm)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages)
	       #:use-module (guix download)
	       #:use-module (guix utils)
	       #:use-module (guix build utils)
	       #:use-module (guix gexp)
	       #:use-module (guix monads)
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
      `(#:make-flags (list (string-append "PREFIX=" (assoc-ref %outputs "out")))
	#:phases
	   (modify-phases %standard-phases
	     (delete 'configure)
	     (delete 'bootstrap)
	     (delete 'check)
	     (delete 'build)
	     (add-after 'install 'completion-install
		(lambda* (#:key outputs #:allow-other-keys)
		  (let* ((out (assoc-ref outputs "out"))
			 (bash_completion_dir (string-append out "/etc/bash_completion.d"))
			 (bash_completion "completion/bash/yadm")
			 )
		    (mkdir-p (string-append bash_completion_dir))
		    (install-file "completion/bash/yadm" bash_completion_dir)
		  )))
	     ))
	)
    (synopsis "yadm")
    (description "yadm")
    (home-page "https://yadm.io/")
    (license license:gpl3+)))
