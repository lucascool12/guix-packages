(define-module (packages zotero)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages)
	       #:use-module (guix download)
	       #:use-module (guix utils)
	       #:use-module (guix build utils)
	       #:use-module (guix gexp)
	       #:use-module (guix monads)
	       #:use-module (gnu packages nss)
	       #:use-module (gnu packages gtk)
	       #:use-module (gnu packages gcc)
	       #:use-module (gnu packages glib)
	       #:use-module (gnu packages xorg)
	       #:use-module (gnu packages tls)
	       #:use-module (gnu packages fontutils)
	       ;; #:use-module (nongnu packages mozilla)
	       #:use-module (nonguix build-system binary))

(define-public zotero
  (package
    (name "zotero")
    (version "6.0.27")
    (source (origin
	      (method url-fetch)
	      (uri "https://download.zotero.org/client/release/6.0.27/Zotero-6.0.27_linux-x86_64.tar.bz2")
	      (sha256
		(base32
		  "06wdkrilpkb3fb7rklr62risrph2v3svgcb2hfs4p421alnqyw7s"))))
    (build-system binary-build-system)
    (arguments
      `(#:strip-binaries? #f
        #:install-plan
        '(
          ;; ("application.ini" "bin/" )
          ;; ("dictionaries" "bin/" )
          ;; ("plugin-container.sig" "bin/" )
          ;; ("zotero" "bin/" )
          ;; ("zotero-bin" "bin/" )
          ;; ("zotero.desktop" "bin/" )
          ;; ("extensions" "bin/" )
          ;; ("icons" "bin/" )
          ;; ("chrome.manifest" "bin/" )
          ;; ("firefox-bin.sig" "bin/" )
          ;; ("firefox.sig" "bin/" )
          ;; ("components" "bin/" )
          ;; ("defaults" "bin/" )
          ;; ("zotero.jar" "bin/" )
          ("." "bin/")
          ;; ("libnspr4.so" "bin/")
          ;; ("libplc4.so" "bin/")
          ;; ("libplds4.so" "bin/")
          ;; ("libmozsandbox.so" "bin/")
          ;; ("libmozsqlite3.so" "bin/")
          ;; ("fonts/" "share/fonts/truetype/" )
          )
        #:patchelf-plan
        `(
          ("zotero-bin"
           ("gcc" "cairo" "gtk+" "nspr" "glib" "atk" "libxcb" "libx11" "dbus"
            "libxdamage" "libxcursor" "libxrender" "libxfixes" "libxcomposite"
            "libxext" "libxi" "libxt" "pango" "dbus-glib" "freetype" "fontconfig-minimal"
            "gdk-pixbuf"))
          ("updater"
           ("libc" "glib" "cairo" "gtk+"))
          ("plugin-container"
           ("libc"))
          ("minidump-analyzer"
           ("libc"))
          ("libmozgtk.so"
           ("gtk+"))
          ("libxul.so"
           ("libc" "cairo" "gtk+" "gcc" "glib" "atk" "libxcb" "libx11" "dbus" "openssl"
            "nss" "libxdamage" "libxcursor" "libxrender" "libxfixes" "libxcomposite"
            "libxext" "libxi" "libxt" "pango" "nspr" "dbus-glib" "freetype" "fontconfig-minimal"
            "gdk-pixbuf"))
          )
        #:phases
        (modify-phases %standard-phases
            (delete 'validate-runpath)
            (delete 'make-dynamic-linker-cache)
            ;; (add-before 'patchelf 'fixnames
            ;;     (lambda _
            ;;       (apply
            ;;         (lambda (elf)
            ;;           (invoke "patchelf" "--replace-needed" "libnss3.so" "nss/libnss3.so" elf)
            ;;           (invoke "patchelf" "--replace-needed" "libnssutil3.so" "nss/libnssutil3.so" elf)
            ;;           (invoke "patchelf" "--replace-needed" "libsmime3.so" "nss/libsmime3.so" elf)
            ;;           (invoke "patchelf" "--replace-needed" "libmozgtk.so" "firefox/libmozgtk.so" elf)
            ;;           (invoke "patchelf" "--replace-needed" "libmozsqlite3.so" "firefox/libmozsqlite3.so" elf)
            ;;           (invoke "patchelf" "--replace-needed" "libmozsandbox.so" "firefox/libmozsandbox.so" elf)
            ;;           (invoke "patchelf" "--replace-needed" "liblgpllibs.so" "firefox/liblgpllibs.so" elf)
            ;;           (invoke "patchelf" "--replace-needed" "libssl3.so" "libssl.so" elf))
            ;;         '("libxul.so"))))
            )))
    (propagated-inputs
      (list
        gtk+
        atk
        libxcb
        libx11
        `(,gcc "lib")
        glib
        dbus
        dbus-glib
        openssl-3.0
        libxdamage
        libxcursor
        libxrender
        libxfixes
        libxcomposite
        libxext
        libxi
        libxt
        freetype
        fontconfig
        gdk-pixbuf
        pango
        nss
        nspr))
    (synopsis "zig")
    (description "zig")
    (home-page "https://ziglang.org")
    (license license:expat)))
