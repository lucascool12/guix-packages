(define-module (packages gtkgreet)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages)
	       #:use-module (guix download)
	       #:use-module (guix utils)
	       #:use-module (guix build utils)
	       #:use-module (guix gexp)
	       #:use-module (guix monads)
           #:use-module (gnu packages pkg-config)
           #:use-module (gnu packages gtk)
           #:use-module (gnu packages web)
	       #:use-module (guix build-system meson))


(define-public gtkgreet
  (package
    (name "gtkgreet")
    (version "0.7.0")
    (source (origin
	      (method url-fetch)
	      (uri "https://git.sr.ht/~kennylevinsen/gtkgreet/archive/0.7.tar.gz")
	      (sha256
		(base32
		  "0wwkmp5zx1mv0vy8qqijf0kw48bmz4ivjcmrwy68ikzrwkhs0jzb"))))
    (build-system meson-build-system)
    (native-inputs (list
                     pkg-config))
    (inputs (list
              json-c
              gtk+))
    (synopsis "gtkgreet")
    (description "gtk greeter")
    (home-page "https://git.sr.ht/~kennylevinsen/gtkgreet")
    (license license:gpl3)))

