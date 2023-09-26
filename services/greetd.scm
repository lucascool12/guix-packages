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
    "exec \"" gtkgreet "/bin/gtkgreet; " sway "/bin/swaymsg exit\"\n"
    "bindsym Mod4+shift+e exec " sway "/bin/swaynag \\\n"
    "	-t warning \\\n"
    "	-m 'What do you want to do?' \\\n"
    "	-b 'Poweroff' 'systemctl poweroff' \\\n"
    "	-b 'Reboot' 'systemctl reboot'\n"
    "include " sway "/etc/sway/config.d/*\n"))

(define* (sway-keyboard-layout keyboard-layout #:optional (input "*"))
  (string-append
    "input " input " {\n"
    "    xkb_layout \"" (keyboard-layout-name keyboard-layout) "\"\n"
    (if (keyboard-layout-variant keyboard-layout)
      (string-append
        "    xkb_variant \"" (keyboard-layout-variant keyboard-layout) "\"\n")
      "")
    (if (keyboard-layout-model keyboard-layout)
      (string-append
        "    xkb_model \"" (keyboard-layout-model keyboard-layout) "\"\n")
      "")
    (let ((options (string-join
                     (keyboard-layout-options keyboard-layout) ",")))
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
