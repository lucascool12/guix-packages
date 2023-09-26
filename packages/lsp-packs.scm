(define-module (packages lsp-packs)
           #:use-module (srfi srfi-1)
           #:use-module (srfi srfi-26)
           #:use-module (ice-9 regex)
           #:use-module (ice-9 match)
           #:use-module (srfi srfi-1)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages)
	       #:use-module (gnu packages ninja)
	       #:use-module (guix download)
	       #:use-module (guix utils)
	       #:use-module (guix build utils)
	       #:use-module (guix gexp)
	       #:use-module (guix monads)
           #:use-module (guix git-download)
           #:use-module (guix build-system copy))

(define-public lua-language-server
  (package
    (name "lua-language-server")
    (version "3.6.25")
    (source
      (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/LuaLS/lua-language-server.git")
               (commit (string-append  version))
               (recursive? #t)))
         (sha256
          (base32
           "146y7cnkmymni432y9ki8d0375pxk6r4201ill7j4rgfx2l6qi3w"))))
    (build-system copy-build-system)
    (arguments
      `(#:phases
        (modify-phases %standard-phases
            (add-before 'install 'build
                (lambda _
                  (with-directory-excursion "3rd/luamake"
                    (invoke "./compile/build.sh"))
                  (invoke "./3rd/luamake/luamake" "rebuild")))
            (add-after 'install 'wrap-program
                (lambda* (#:key outputs #:allow-other-keys)
                    (let ((out (assoc-ref outputs "out"))
                          (luals-bin (string-append (assoc-ref outputs "out") "/bin/lua-language-server")))
                      (mkdir-p (string-append out "/bin"))
                      (call-with-output-file luals-bin
                        (lambda (output-port)
                          (display 
                              (string-append
                                "#!/bin/bash\n"
                                out "/share/bin/lua-language-server -E " out "/share/main.lua "
                                "--logpath=${XDG_CACHE_HOME:-$HOME/.cache}/lua-language-server/log "
                                "--metapath=${XDG_CACHE_HOME:-$HOME/.cache}/lua-language-server/meta $@") 
                              output-port)))
                      (chmod luals-bin #o555)))))
        #:install-plan
        '(("bin" "share/")
         ("build" "share/")
         ("main.lua" "share/")
         ("debugger.lua" "share/")
         ("script" "share/")
         ("locale" "share/")
         ("meta" "share/")
         ("changelog.md" "share/"))))
    (native-inputs (list
                     ninja))
    (home-page "https://github.com/Z3Prover/z3")
    (synopsis "Theorem prover")
    (description "Z3 is a theorem prover and @dfn{satisfiability modulo
theories} (SMT) solver.  It provides a C/C++ API, as well as Python bindings.")
    (license license:expat)))

