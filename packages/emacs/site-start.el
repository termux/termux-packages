;; Enable terminal mouse events:
(xterm-mouse-mode 1)
(global-set-key [mouse-4] 'scroll-down-line)
(global-set-key [mouse-5] 'scroll-up-line)

;; Assume UTF-8 keyboard input for emacsclient:
(add-hook 'server-visit-hook
          '(lambda ()
             (set-keyboard-coding-system 'utf-8-unix)))
