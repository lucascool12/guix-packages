(define-module (packages 1pass)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages)
	       #:use-module (guix download)
	       #:use-module (guix utils)
	       #:use-module (guix build utils)
	       #:use-module (guix gexp)
	       #:use-module (guix monads)
	       #:use-module (gnu packages gcc)
	       #:use-module (gnu packages xorg)
	       #:use-module (gnu packages glib)
	       #:use-module (gnu packages cups)
	       #:use-module (gnu packages nss)
	       #:use-module (gnu packages xdisorg)
	       #:use-module (gnu packages gtk)
	       #:use-module (gnu packages video)
	       #:use-module (nonguix build-system binary))


(define-public 1password
  (package
    (name "1password")
    (version "1.0.0")
    (source (origin
              (method url-fetch)
              (uri "https://downloads.1password.com/linux/tar/stable/x86_64/1password-latest.tar.gz")
              (sha256
                (base32
                  "0v8ikayjl0kqgfarq4bvsbrmkrrk2hj1zx2jp0sgxk4b4y2nsjd3"))))
    (build-system binary-build-system)
    (supported-systems '("x86_64-linux" "i686-linux"))
    (arguments
      `(#:patchelf-plan
          `(("1password"
             ;; ("libc" "glib" "nss" "atk" "cups" "dbus" "libdrm" "gtk" "pango" "cairo" "libx11" "libgccjit" "libxext" "libxcb" "libxkbcommon" "libxrandr" "libxfixes" "libxdamage" "libxcomposite" "ffmpeg")
             ))
        #:install-plan
        `(("." ("1password") "bin/"))
        ))
    (propagated-inputs
      (list 
        glib atk cups nss atk dbus libdrm gtk pango cairo libx11 libgccjit libxext libxcb libxkbcommon libxrandr libxfixes libxdamage libxcomposite ffmpeg))
    (synopsis "1password")
    (description "lisense is incorrect")
    (home-page "https://1password.com")
    (license license:epl1.0)))
