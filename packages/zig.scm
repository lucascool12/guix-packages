(define-module (packages zig)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages)
	       #:use-module (guix download)
	       #:use-module (guix utils)
	       #:use-module (guix build utils)
	       #:use-module (guix gexp)
	       #:use-module (guix monads)
	       #:use-module (guix build-system copy))


(define-public zig-0.11
  (package
    (name "zig")
    (version "0.11.0")
    (source (origin
	      (method url-fetch)
	      (uri "https://ziglang.org/download/0.11.0/zig-linux-x86_64-0.11.0.tar.xz")
	      (sha256
		(base32
		  "0irh895lgz3fjvywahz8bqy98r6mj7zq7gz7ls81gxy4zs4yf01d"))))
    (build-system copy-build-system)
    (arguments
      `(#:install-plan
        '(("zig" "bin/")
         ("lib/" "lib/"))))
    (synopsis "zig")
    (description "zig")
    (home-page "https://ziglang.org")
    (license license:expat)))
