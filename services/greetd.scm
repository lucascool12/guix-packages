(define-module (services greetd)
	       #:use-module ((guix licenses) #:prefix license:)
	       #:use-module (guix packages)
	       #:use-module (guix download)
	       #:use-module (guix utils)
	       #:use-module (gnu services)
	       #:use-module (guix gexp)
	       #:use-module (guix monads)
           #:use-module (guix records)
           #:use-module (gnu packages wm)
           #:use-module (gnu system keyboard)
	       #:use-module (packages gtkgreet)
           #:export (
                     greetd-gtkgreet-greeter
                     greetd-gtkgreet-tty-xdg-session-command
                     greetd-gtkgreet-tty-session-command
                     sway-keyboard-layout
                     ))


;; (define gtkgreet-environments
;;   (plain-file "gtkgreet-environments"
;;               "sway\n"))

(define gtkgreet-sway-config
  (mixed-text-file
    "gtkgreet-sway-config"
    "# `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.\n"
    "exec \"" gtkgreet "/bin/gtkgreet -l; " sway "/bin/swaymsg exit\"\n"
    "bindsym Mod4+shift+e exec " sway "/bin/swaynag \\\n"
    "	-t warning \\\n"
    "	-m 'What do you want to do?' \\\n"
    "	-b 'Poweroff' 'systemctl poweroff' \\\n"
    "	-b 'Reboot' 'systemctl reboot'\n"
    "include " sway "/etc/sway/config.d/*\n"))

(define (add-comma-if-next-exists ls)
  (if (not (null? (cdr ls)))
    (append
      (list
        (car ls)
        ",")
      (add-comma-if-next-exists (cdr ls)))
    ls))

(define (replace-false ls replace)
  (if (null? ls)
    ls
    (append
      (list
        (if (eqv? (car ls) #f)
          replace
          (car ls)))
        (replace-false (cdr ls) replace))))

(define* (sway-keyboard-layout kbls #:optional (input "*"))
  (string-append
    "input " input " {\n"
    "    xkb_layout \"" (apply string-append (add-comma-if-next-exists (map keyboard-layout-name kbls))) "\"\n"
    (let ((variants (apply string-append (replace-false (add-comma-if-next-exists (map keyboard-layout-variant kbls)) ""))))
      (if (> (string-length variants) 0)
        (string-append
          "    xkb_variant \"" variants "\"\n")
        ""))
    (let ((models (apply string-append (replace-false (add-comma-if-next-exists (map keyboard-layout-model kbls)) ""))))
      (if (> (string-length models) 0)
        (string-append
          "    xkb_model \"" models "\"\n")
        ""))
    (let ((options (string-join
                     (replace-false (apply append (map keyboard-layout-options kbls)) "") ",")))
          (if (> (string-length options) 0)
            (string-append
              "    xkb_options \"" options "\"\n")
            ""))
    "}\n"))

(define-record-type* <greetd-gtkgreet-greeter>
  greetd-gtkgreet-greeter make-greetd-gtkgreet-greeter
  greetd-gtkgreet-greeter?
  (greet-command greetd-container-command (default (file-append sway "/bin/sway")))
  (greet-command-args greetd-container-args (default `("-c" ,gtkgreet-sway-config)))
  (extra-env greetd-gtkgreet-extra-env (default '()))
  (xdg-env? greetd-gtkgreet-xdg-env? (default #t)))

(define* (greetd-gtkgreet-tty-session-command name command #:optional (command-args '()) (extra-env '()))
    (program-file
     name
     #~(begin
         (use-modules (ice-9 match))
         (for-each (match-lambda ((var . val) (setenv var val)))
                   (quote (#$@extra-env)))
         (apply execl #$command #$command (list #$@command-args)))))

(define* (greetd-gtkgreet-tty-xdg-session-command name command #:optional (command-args '()) (extra-env '()))
    (program-file
     name
     #~(begin
         (use-modules (ice-9 match))
         (let*
             ((username (getenv "USER"))
              (useruid (passwd:uid (getpwuid username)))
              (useruid (number->string useruid)))
           (setenv "XDG_SESSION_TYPE" "tty")
           (setenv "XDG_RUNTIME_DIR" (string-append "/run/user/" useruid)))
         (for-each (match-lambda ((var . val) (setenv var val)))
                   (quote (#$@extra-env)))
         (apply execl #$command #$command (list #$@command-args)))))

(define-gexp-compiler (greetd-gtkgreet-greeter-compiler
                       (session <greetd-gtkgreet-greeter>)
                       system target)
  (let ((container (greetd-container-command session))
        (args (greetd-container-args session)))
    (lower-object
     (program-file "agreety-command"
       #~(apply execl #$container #$container (list #$@args))))))
