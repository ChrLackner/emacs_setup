;; ;; sanityinc tomorrow theme  -*- lexical-binding: t; -*-
;; (use-package color-theme-sanityinc-tomorrow
;;   :config
;;   (load-theme 'sanityinc-tomorrow-night t)
;;   (set-face-attribute 'default nil
;;                       ;;:family "Source Code Pro"
;;                       :family "Roboto Light"
;;                       :height 140
;;                       :weight 'normal
;;                       :width 'normal)
;;   ;; set highlight color
;;   (set-face-attribute 'region nil :background "#444444" :foreground "#cccccc"))

(let ((default-directory  "~/.emacs.d/settings/resources"))
  (normal-top-level-add-subdirs-to-load-path))

;; Nano emacs
;; -----------------
(require 'nano-theme-dark)
(nano-theme-set-dark)
;; (require 'nano-theme-light)
;; (nano-theme-set-light)
;; (Require 'nano-layout)
(require 'nano-faces)
(nano-faces)

(require 'nano-theme)
(nano-theme)

(require 'nano-modeline)

;; End Nano emacs -----------


;; delay fontification to speed things up...
;; (setq jit-lock-defer-time 0.1)
(setq jit-lock-defer-time 0)

(setq font-lock-support-mode 'jit-lock-mode)
(setq jit-lock-stealth-time 16
      jit-lock-defer-contextually t
      ;;jit-lock-stealth-nice 0.5)
      jit-lock-stealth-nice 0)
(setq font-lock-maximum-decoration 5)
(setq-default font-lock-multiline t)

(if (not (eq system-type 'windows-nt))
    (set-frame-parameter nil 'undecorated t))

; don't show the startup screen
(setq inhibit-startup-screen t)
; don't blink the cursor
(blink-cursor-mode 0)

(provide 'theme-settings)
