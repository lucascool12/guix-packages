(define-module (packages python-packs)
           #:use-module (srfi srfi-1)
           #:use-module (srfi srfi-26)
           #:use-module (ice-9 regex)
           #:use-module (ice-9 match)
           #:use-module (srfi srfi-1)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages)
	       #:use-module (guix download)
	       #:use-module (guix utils)
	       ;; #:use-module (guix build utils)
	       #:use-module (guix gexp)
	       #:use-module (guix monads)
           #:use-module (gnu packages python-xyz)
           #:use-module (gnu packages)
           #:use-module (gnu packages base)
           #:use-module (gnu packages python-build)
           #:use-module (gnu packages check)
           #:use-module (gnu packages xml)
           #:use-module (gnu packages cmake)
           #:use-module (gnu packages maths)
           #:use-module (gnu packages time)
           #:use-module (gnu packages python-check)
           #:use-module (gnu packages python-web)
           #:use-module (gnu packages python)
           #:use-module (guix git-download)
           #:use-module (guix build-system python)
           #:use-module (guix build-system cmake)
	       #:use-module (guix build-system pyproject))


(define-public python-textx
  (package
    (name "python-textx")
    (version "3.1.1")
    (source (origin
	      (method url-fetch)
	      (uri (string-append
		     "https://github.com/textX/textX/archive/refs/tags/" version ".tar.gz"))
	      (sha256
		(base32
		  "0vjb641q0vvxkzgvv76jgv5775qki848c6a2zmhx69xsma4d5v0q"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda* (#:key tests? inputs outputs #:allow-other-keys)
             (when tests?
               (invoke "sh" "-c" "virtualenv venv --system-site-packages; . ./venv/bin/activate;\
                       python -m pip install -e .;\
                       python -m pip install -e tests/functional/subcommands/example_project;\
                       python -m pip install -e tests/functional/registration/projects/types_dsl;\
                       python -m pip install -e tests/functional/registration/projects/data_dsl;\
                       python -m pip install -e tests/functional/registration/projects/flow_dsl;\
                       python -m pip install -e tests/functional/registration/projects/flow_codegen;\
                       python -m coverage run --source textx -m pytest tests/functional || exit 1;\
                       python -m coverage report --fail-under 90 || exit 1;\
                       flake8 || exit 1")))))))
    (native-inputs (list
                     python-pip
                     python-virtualenv
                     python-flake8
                     python-pytest
                     python-wheel
                     python-click-7
                     python-html5lib
                     python-jinja2
                     python-attrs-23
                     python-coveralls
                     python-coverage
                     ))
    (propagated-inputs (list
                         python-arpeggio
                         ))
    (synopsis "attrs")
    (description "attrs")
    (home-page "https://attrs.io/")
    (license license:gpl3+)))

(define-public python-textx-2
  (package/inherit python-textx
    (version "2.3.0")
    (source (origin
	      (method url-fetch)
	      (uri (string-append
		     "https://github.com/textX/textX/archive/refs/tags/" version ".tar.gz"))
	      (sha256
		(base32
		  "0v780nmlfv7211s3ssp0f172g9cy1w3chnrim7qqqzvh253jqw6g"))))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda* (#:key tests? inputs outputs #:allow-other-keys)
             (when tests?
               (invoke "sh" "-c" "virtualenv venv --system-site-packages; . ./venv/bin/activate;\
                       python -m pip install -e .;\
                       python -m pip install -e tests/functional/subcommands/example_project;\
                       python -m pip install -e tests/functional/registration/projects/types_dsl;\
                       python -m pip install -e tests/functional/registration/projects/data_dsl;\
                       python -m pip install -e tests/functional/registration/projects/flow_dsl;\
                       python -m pip install -e tests/functional/registration/projects/flow_codegen;\
                       python -m coverage run --omit textx/six.py --source textx -m py.test tests/functional || exit 1;\
                       python -m coverage report --fail-under 90 || exit 1;\
                       flake8 || exit 1")))))))))

(define-public python-pytest-7.4.0
  (package
    (inherit python-pytest)
    (version "7.4.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/pytest-dev/pytest/archive/refs/tags/" version ".tar.gz"))
              (sha256
                (base32
                  "0rjqyddhwiqk5kl4pnwynxs9k8rnjl74rdv96a6i6066l82s174m"))))
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'pretend-version
            ;; The version string is usually derived via setuptools-scm, but
            ;; without the git metadata available, the version string is set to
            ;; '0.0.0'.
            (lambda _
              (setenv "SETUPTOOLS_SCM_PRETEND_VERSION"
                      #$(package-version this-package))))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (setenv "TERM" "dumb")    ;attempt disabling markup tests
              (if tests?
                  (invoke "pytest" "-vv" "-k"
                          (string-append
                           ;; This test involves the /usr directory, and fails.
                           " not test_argcomplete"
                           ;; These test do not honor the isatty detection and
                           ;; fail.
                           " and not test_code_highlight"
                           " and not test_color_yes"))
                  (format #t "test suite not run~%")))))))
    (propagated-inputs (list 
                         python-exceptiongroup
                         python-attrs-bootstrap
                         python-iniconfig
                         python-packaging-bootstrap
                         python-pluggy-1.2
                         python-py
                         python-tomli))))

(define-public python-pluggy-1.2
  (package/inherit python-pluggy
   (version "1.2.0")
   (source
    (origin
     (method url-fetch)
     (uri (pypi-uri "pluggy" version))
     (sha256
      (base32
       "1cy4ljivmvwd5w4jihpyiyhfpvl5xqkb46rhakhga5cvax5hqbyi"))))))

(define-public python-pytest-xdist-3.3.1
  (package
    (inherit python-pytest-xdist)
    (version "3.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pytest-xdist" version))
       (sha256
        (base32
         "14wciv3zmza4if7ijy6528l9j1vpgamii9b01ajwqyqvxch0bvnm"))))
    (build-system pyproject-build-system)))

(define-public python-mypy-1
  (package
    (name "python-mypy")
    (version "1.5.1")
    (source (origin
	      (method url-fetch)
	      (uri (string-append
		     "https://github.com/python/mypy/archive/refs/tags/v" version ".tar.gz"))
	      (sha256
		(base32
		  "1llh6am3x241if3z6l1bpc6b2jh34jqsd9wf944r361x652l9292"))))
    (build-system pyproject-build-system)
    (native-inputs
     (list (no-tests-package python-attrs-23 '("python-mypy"))
           python-lxml
           python-psutil
           python-pytest-7.4.0
           python-pytest-forked
           python-pytest-xdist-3.3.1
           python-virtualenv))
    (propagated-inputs
     (list python-mypy-extensions python-tomli python-typing-extensions))
    (home-page "https://www.mypy-lang.org/")
    (synopsis "Static type checker for Python")
    (description "Mypy is an optional static type checker for Python that aims
to combine the benefits of dynamic typing and static typing.  Mypy combines
the expressive power and convenience of Python with a powerful type system and
compile-time type checking.  Mypy type checks standard Python programs; run
them using any Python VM with basically no runtime overhead.")
    ;; Most of the code is under MIT license; Some files are under Python Software
    ;; Foundation License version 2: stdlib-samples/*, mypyc/lib-rt/pythonsupport.h and
    ;; mypyc/lib-rt/getargs.c
    (license (list license:expat license:psfl))))

(define (eq-pname? p2 p1)
  (if (list? p1)
    (equal? p2 (car p1))
    (equal? p1 (car p2))))


(define (no-tests-package package to-remove)
  (package/inherit package
    (native-inputs (map cadr (lset-xor eq-pname? to-remove (package-native-inputs package))))
    (arguments
      (append '(#:tests? #f) (package-arguments package)))))
      ;; `(#:tests? #f))))


(define-public python-attrs-23
  (package
    (name "python-attrs")
    (version "23.1.0")
    (source (origin
	      (method url-fetch)
	      (uri (string-append
		     "https://github.com/python-attrs/attrs/archive/refs/tags/" version ".tar.gz"))
	      (sha256
		(base32
		  "1lr90rvdb9lgg247rrjw5d4j98k710ri2g36blh9gmgdj6ihpwcp"))))
    (build-system pyproject-build-system)
    (arguments
      `(#:tests? #f
        #:phases (modify-phases %standard-phases
                    (replace 'check
                     (lambda* (#:key tests? #:allow-other-keys)
                      (when tests?
                        (invoke "pytest")))))))
    (native-inputs (list
                     python-hatchling
                     python-cloudpickle
                     python-hypothesis
                     python-pympler
                     python-pytest-7.4.0
                     (no-tests-package python-mypy-1 '("python-attrs"))
                     python-pytest-mypy-plugins
                     python-pytest-xdist-3.3.1
                     python-hatch-vcs
                     python-hatch-fancy-pypi-readme))
    (synopsis "attrs")
    (description "attrs")
    (home-page "https://attrs.io/")
    (license license:gpl3+)))

    

(define-public z3-4.12
  (package
    (name "z3")
    (version "4.12.2")
    (home-page "https://github.com/Z3Prover/z3")
    (source (origin
              (method git-fetch)
              (uri (git-reference (url home-page)
                                  (commit (string-append "z3-" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "10157dyifnpkkx3rbnzgq8jgyvy4vf5p3qircj3d0bmz84l2jf0d"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:imported-modules `((guix build python-build-system)
                           ,@%cmake-build-system-modules)
      #:modules '((guix build cmake-build-system)
                  (guix build utils)
                  ((guix build python-build-system) #:select (site-packages)))
      #:configure-flags
      #~(list "-DZ3_BUILD_PYTHON_BINDINGS=ON"
              "-DZ3_LINK_TIME_OPTIMIZATION=ON"
              (string-append
               "-DCMAKE_INSTALL_PYTHON_PKG_DIR="
               #$output "/lib/python"
               #$(version-major+minor (package-version python-wrapper))
               "/site-packages"))
      #:phases
      #~(modify-phases %standard-phases
          (replace 'check
            (lambda* (#:key parallel-build? tests? #:allow-other-keys)
              (when tests?
                (invoke "make" "test-z3"
                        (format #f "-j~a"
                                (if parallel-build?
                                    (parallel-job-count)
                                    1)))
                (invoke "./test-z3" "/a"))))
          (add-after 'install 'compile-python-modules
            (lambda _
              (setenv "PYTHONHASHSEED" "0")

              (invoke "python" "-m" "compileall"
                      "--invalidation-mode=unchecked-hash"
                      #$output)))
          ;; This step is missing in the CMake build system, do it here.
          (add-after 'compile-python-modules 'fix-z3-library-path
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((dest (string-append (site-packages inputs outputs)
                                          "/z3/lib/libz3.so"))
                     (z3-lib (string-append #$output "/lib/libz3.so")))
                (mkdir-p (dirname dest))
                (symlink z3-lib dest))))
          (add-after 'build 'add-python-dist-info
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((dest (string-append (site-packages inputs outputs))))
                (mkdir-p dest)
                (mkdir-p "dist_info/z3")
                (with-directory-excursion "dist_info"
                    (invoke "python" "../../source/src/api/python/setup.py" "dist_info" "--output-dir" dest))))))))
    (native-inputs
     (list
       which
       python-wrapper
       python-setuptools
       python-wheel))
    (synopsis "Theorem prover")
    (description "Z3 is a theorem prover and @dfn{satisfiability modulo
theories} (SMT) solver.  It provides a C/C++ API, as well as Python bindings.")
    (license license:expat)))


(define-public python-fast-html
  (package
    (name "python-fast-html")
    (version "1.0.3")
    (source (origin
       (method git-fetch)
       (uri (git-reference (url "https://github.com/pcarbonn/fast_html.git") (commit "1e76083992c9f4b1c99466deb6c94db17f929377")))
       (sha256
        (base32
         "0w01m5s9cb9iiz4mwpgn0vkpdrxz12bbqh8r5max4lk627qrirak"))))
    (build-system pyproject-build-system)
    (arguments
      `(#:phases (modify-phases %standard-phases
                    (replace 'check
                       (lambda* (#:key tests? #:allow-other-keys)
                          (when tests?
                            (invoke "python" "test.py")))))))
    (native-inputs (list
                     python-poetry-core))
    (synopsis "fast-html")
    (description "fast-html")
    (home-page "https://github.com/pcarbonn/fast_html")
    (license license:lgpl3+)))

(define-public python-pretty-errors
  (package
    (name "python-pretty-errors")
    (version "1.2.25")
    (source (origin
              (method git-fetch)
              (uri (git-reference (url "https://github.com/onelivesleft/PrettyErrors.git") (commit "f61574e7fec2b7118fee5a59de61a8a734459ca1")))
              (sha256
                (base32
                 "1m4vkdp2fypq61i2h509gxxhwvk6jf3i49d15ip2v9ggvm4gdsy9"))))
    (build-system python-build-system)
    (arguments
      `(#:tests? #f))
    (propagated-inputs (list
                         python-colorama))
    (synopsis "fast-html")
    (description "fast-html")
    (home-page "https://github.com/pcarbonn/fast_html")
    (license license:lgpl3+)))
              

(define-public python-pyyaml-6.0.1
  (package/inherit python-pyyaml
    (version "6.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "PyYAML" version))
       (sha256
        (base32
         "0hsa7g6ddynifrwdgadqcx80khhblfy94slzpbr7birn2w5ldpxz"))))))

(define-public python-flask-1
  (package/inherit python-flask
    (version "1.1.2")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "Flask" version))
              (sha256
               (base32
                "0q3h295izcil7lswkzfnyg3k5gq4hpmqmpl6i7s5m1n9szi1myjf"))))
    (propagated-inputs (list
                         python-werkzeug
                         python-jinja2-2
                         python-itsdangerous
                         python-click-7))
    (arguments
      `(#:tests? #f))))


(define-public python-jinja2-2
  (package/inherit python-jinja2
    (version "2.11.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "Jinja2" version))
       (sha256
        (base32
         "1iiklf3wns67y5lfcacxma5vxfpb7h2a67xbghs01s0avqrq9md6"))))
    (propagated-inputs (list python-markupsafe-2.0.1))
    (arguments
      `(#:tests? #f))))

(define-public python-markupsafe-2.0.1
  (package/inherit python-markupsafe
    (version "2.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "MarkupSafe" version))
       (sha256
        (base32
         "02k2ynmqvvd0z0gakkf8s4idyb606r7zgga41jrkhqmigy06fk2r"))))))

(define-public python-flask-restful-flask2
  (package/inherit python-flask-restful
    (version "0.3.10")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "Flask-RESTful" version))
        (sha256
         (base32
          "0dzckjjz3aw8nmisr5g9mnv02s2nqlhblykr9ydqzpr703pz4jpy"))))
    (propagated-inputs 
      (list python-aniso8601 python-flask-1 python-pytz))))


(define-public python-idp-engine
  (package
    (name "python-idp-engine")
    (version "0.10.11")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://gitlab.com/krr/IDP-Z3/-/archive/" version "/IDP-Z3-" version ".tar.gz"))
              (sha256
                (base32
                 "0ms25v9r58kqj6na1j5a6dc9bwj5dn9mwdgzlw0pppjmy6c7js2w"))))
    (build-system pyproject-build-system)
    (arguments
      `(
        ;; Tests pass when invoked manually TODO
        #:tests? #f
        #:phases (modify-phases %standard-phases
                    (replace 'check
                       (lambda* (#:key tests? #:allow-other-keys)
                          (when tests?
                            (invoke "python" "test.py")))))))
    (native-inputs (list
                     python-poetry-core
                     python-pretty-errors
                     python-click-7
                     python-textx-2
                     z3-4.12
                     python-dateutil
                     python-flask-1
                     python-flask-cors
                     python-flask-restful-flask2
                     python-fast-html
                     python-attrs-23
                     python-pyyaml-6.0.1))
    (propagated-inputs (list
                     python-click-7
                     python-textx-2
                     z3-4.12
                     python-dateutil
                     python-flask-1
                     python-flask-cors
                     python-flask-restful-flask2
                     python-fast-html
                     python-attrs-23
                     python-pyyaml-6.0.1))
    (synopsis "fast-html")
    (description "fast-html")
    (home-page "https://github.com/pcarbonn/fast_html")
    (license license:lgpl3+)))
