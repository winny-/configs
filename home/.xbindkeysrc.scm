(define (path-join . args) (string-join args "/"))
(define HOME (getenv "HOME"))
;;(define raise-volume "amixer -c 0 sset 'Master',0 2dB+")
;;(define lower-volume "amixer -c 0 sset 'Master',0 2dB-")
;;(define mute "amixer set Master toggle")
(define raise-volume "ponymix increase 3")
(define lower-volume "ponymix decrease 3")
(define mute "ponymix toggle")

;; Quick and easy intel backlight adjustment. Does not call
;; external scripts so it's always fast.

;; Prerequisite: create /etc/udev/rules.d/99-intel_backlight.rules
;;
;; SUBSYSTEM=="backlight", ACTION=="add", RUN+="/bin/chgrp -R video /sys%p", RUN+="/bin/chmod -R g=u /sys%p"
;; SUBSYSTEM=="backlight", ACTION=="change", ENV{TRIGGER}!="none", RUN+="/bin/chgrp -R video /sys%p", RUN+="/bin/chmod -R g=u /sys%p"
;;
;; (And ensure your user is in the video group.)

(define BACKLIGHT-BASE "/sys/class/backlight/intel_backlight")
(when (access? (path-join BACKLIGHT-BASE "brightness") W_OK)
  (let ()
    (define BACKLIGHT-MAX (call-with-input-file (path-join BACKLIGHT-BASE "max_brightness") read))
    (define BACKLIGHT-STEP (quotient BACKLIGHT-MAX 30))
    (define (get-brightness)
      (call-with-input-file (path-join BACKLIGHT-BASE "brightness") read))
    (define (write-brightness brightness)
      (call-with-output-file (path-join BACKLIGHT-BASE "brightness")
        (lambda (op) (display brightness op))))
    (define (increase-brightness)
      (define brightness (get-brightness))
      (write-brightness (if (= 0 brightness)
                            1
                            (min BACKLIGHT-MAX
                                 (+ BACKLIGHT-STEP brightness)))))
    (define (decrease-brightness)
      (define brightness (get-brightness))
      (write-brightness (max (- brightness BACKLIGHT-STEP)
                             (if (> brightness 1) 1 0))))
    (xbindkey-function '(XF86MonBrightnessDown) decrease-brightness)
    (xbindkey-function '(XF86MonBrightnessUp) increase-brightness)))

(xbindkey '(XF86AudioRaiseVolume) raise-volume)
(xbindkey '(XF86AudioLowerVolume) lower-volume)
(xbindkey '(XF86AudioMute) mute)
(define (mpvc . args)
  (string-append "mpvc -S "
                 (path-join HOME ".config/mpv/mpv.socket")
                 " "
                 (string-join args " ")))
(xbindkey '(XF86AudioPlay) (mpvc "toggle"))
(xbindkey '(XF86AudioNext) (mpvc "next"))
(xbindkey '(XF86AudioPrev) (mpvc "prev"))
(xbindkey '(Mod4 F12) raise-volume)
(xbindkey '(Mod4 F11) lower-volume)
(xbindkey '(Mod4 F10) mute)
(xbindkey '(Mod4 F8) (mpvc "toggle"))
(xbindkey '(Mod4 F9) (mpvc "next"))
(xbindkey '(Mod4 F7) (mpvc "prev"))
;(xbindkey '(Mod4 c) "lock")
;(xbindkey '(Mod4 Mod1 Shift c) "nap")
(xbindkey '(Mod4 F1) "toggle-dvorak")
(xbindkey '(Mod4 grave) "raise-or-create-emacs")
(xbindkey '(Mod4 semicolon) "emacsclient -c")
                                        ;(xbindkey '(Mod4 t) "gnome-terminal")
                                        ;(xbindkey '(XF86Sleep) (path-join HOME "bin/nap"))
;; (xbindkey '(Mod4 Shift q) "sh -c 'zenity --question --text \"Log off $USER?\" && pkill dwm'")
(xbindkey '(Mod4 F2) "toggle-redshift")
;(xbindkey '(Mod4 F8) (path-join HOME ".screenlayout/rotate.rkt"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bspwm bindings
(use-modules (ice-9 format))
(define-syntax xbindkey/group
  (syntax-rules ()
    ((_ common-binding common-command (differences differences* ...))
     (begin
       (let* ((different-binding (car differences))
              (binding (append common-binding
                               (if (list? different-binding)
                                   different-binding
                                   (list different-binding))))
              (different-command (cadr differences))
              (command (if (list? different-command)
                           different-command
                           (list different-command))))
         (xbindkey binding
                   (apply format common-command command))
         (xbindkey/group common-binding common-command
                         (differences* ...)))))
    ((_ common-binding common-command ()) #t)))

;; Reload xbindkeys config
(xbindkey '(Mod4 Shift backslash) "pkill -SIGHUP xbindkeys")
;; Spawn terminal
;(xbindkey '(Mod4 Return) "walacritty")
;; Run program
(xbindkey '(Mod4 u) "rofi -show run")
;; Close client
;;(xbindkey '(Mod4 Shift q) "bspc node -c")
;; Kill client
;; (xbindkey '(Mod4 Shift Mod1 q) "bspc node -k")
;; ;; Change layout
;; (xbindkey '(Mod4 m) "bspc desktop -l next") ; monocle and tiled
;; ;; Swap smaller node with largest node
;; (xbindkey '(Mod4 Shift Return) "bspc node -s biggest")
;;                                         ;(xbindkey '(Mod4 Shift Return) "bspc node newest.marked.local -n newest.!automatic.local")

;; ;; Focus direction
;; (xbindkey/group '(Mod4) "bspc node -f ~a"
;;                 ('(f east)  '(b west)
;;                  '(p north) '(n south)))
;; ;; Swap direction
;; (xbindkey/group '(Mod4 Shift) "bspc node -s ~a"
;;                 ('(f east)  '(b west)
;;                  '(p north) '(n south)))
;; ;; Expand edge in direction
;; (xbindkey/group '(Mod4 Mod1) "bspc node -z ~a ~a ~a"
;;                 ('(f (right 20 0))  '(b (left -20 0))
;;                  '(p (top 0 -20))   '(n (bottom 0 20))))
;; ;; Contract edge from direction
;; (xbindkey/group '(Mod4 Shift Mod1) "bspc node -z ~a ~a ~a"
;;                 ('(f (left 20 0)) '(b (right -20 0))
;;                  '(p (bottom 0 -20))  '(n (top 0 20))))
;; ;; Move floating window
;; (xbindkey/group '(Mod4) "bspc node -v ~a ~a"
;;                 ('(Left (-20 0)) '(Right (20 0))
;;                  '(Up (0 -20))   '(Down (0 20))))
;; (xbindkey/group '(Mod4) "bspc node -f ~a"
;;                 ('(comma "@parent")
;;                  '(period "@first")))
;; ;; Switch to desktop
;; (xbindkey/group '(Mod4) "bspc desktop -f ^~a"
;;                 ('("1" 1) '("2" 2) '("3" 3)
;;                  '("4" 4) '("5" 5) '("6" 6)
;;                  '("7" 7) '("8" 8) '("9" 9)
;;                  '("0" 10)))
;; ;; Send to desktop
;; (xbindkey/group '(Mod4 Shift) "bspc node -d ^~a"
;;                 ('("1" 1) '("2" 2) '("3" 3)
;;                  '("4" 4) '("5" 5) '("6" 6)
;;                  '("7" 7) '("8" 8) '("9" 9)
;;                  '("0" 10)))
;; ;; Select monitor
;; (xbindkey/group '(Mod4 Mod1) "bspc monitor -f ^~a"
;;                 ('("1" 1) '("2" 2) '("3" 3)
;;                  '("4" 4) '("5" 5) '("6" 6)
;;                  '("7" 7) '("8" 8) '("9" 9)))
;; ;; Set window state
;; (xbindkey/group '(Mod4) "bspc node -t ~a"
;;                 ('(t tiled) '((Shift t) pseudo_tiled)
;;                  '(s floating)
;;                  '(l fullscreen)))
;; (xbindkey '(Mod4 r) "bspc node -R 90")
;; (xbindkey '(Mod4 a) "bspc node -B")
;; (xbindkey '(Mod4 Shift a) "bspc node -E")
;; ;; Set node flags
;; (xbindkey/group '(Mod4 Control) "bspc node -g ~a"
;;                 ('(m marked) '(w locked)
;;                  '(v sticky) '(z private)))
;; (xbindkey/group '(Mod4) "bspc ~a -f last"
;;                 ('(Tab desktop)
;;                  '(apostrophe node)))
;; ;; preselect in direction
;; (xbindkey/group '(Mod4 Control) "bspc node -p ~a"
;;                 ('(f east)  '(b west)
;;                  '(p north) '(n south)))
;; ;; preselect ratio
;; (xbindkey/group '(Mod4 Control) "bspc node -o 0.~a"
;;                 ('("1" 1) '("2" 2) '("3" 3)
;;                  '("4" 4) '("5" 5) '("6" 6)
;;                  '("7" 7) '("8" 8) '("9" 9)))
;; ;; cancel preselection for focused node
;; (xbindkey '(Mod4 Control space) "bspc node -p cancel")
