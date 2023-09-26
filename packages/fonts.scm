(define-module (packages fonts)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages)
	       #:use-module (guix download)
	       #:use-module (guix utils)
	       #:use-module (guix build utils)
	       #:use-module (guix gexp)
	       #:use-module (guix monads)
	       #:use-module (guix build-system copy))

(define-public font-nerdfonts-dejavusansmono
  (package
    (name "font-nerdfonts-dejavusansmono")
    (version "3.0.2")
    (source (origin
	      (method url-fetch)
	      (uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/DejaVuSansMono.tar.xz")
	      (sha256
		(base32
		  "1j22f5jnpmyli686r67c4c07g07ac78aq9wg8hy1vwblxfzdvq9f"))))
    (build-system copy-build-system)
    (arguments
      `(#:install-plan
        '(("." "share/fonts/truetype/" #:include-regexp ("DejaVuSansM*")))))
    (synopsis "NerdFonts DejaVuSansMono")
    (description "NerdFonts DejaVuSansMono")
    (home-page "https://www.nerdfonts.com/")
    (license license:expat)))
