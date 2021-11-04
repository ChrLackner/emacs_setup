;; ;; sanityinc tomorrow theme
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


;; Nano emacs
;; -----------------
(let ((default-directory  "~/.emacs.d/settings/resources"))
  (normal-top-level-add-subdirs-to-load-path))
(require 'nano-theme-dark)
;; (require 'nano-layout)
(require 'nano-faces)
(nano-faces)

(require 'nano-theme)
(nano-theme)

(require 'nano-modeline)

;; End Nano emacs -----------


;; delay fontification to speed things up...
(setq jit-lock-defer-time 0)

(set-frame-parameter nil 'undecorated t)
; don't show the startup screen
(setq inhibit-startup-screen t)
; don't show the tool bar
(require 'tool-bar)
(tool-bar-mode 0)
; don't show the menu bar
(menu-bar-mode 0)
; disable scroll bar
(toggle-scroll-bar 0)
; don't blink the cursor
(blink-cursor-mode 0)

(provide 'theme-settings)
