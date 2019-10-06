
;; ===================================================================
;; Add color to the current GUD line (obrigado google)
;; ===================================================================

;; (defvar gud-overlay
;;   (let* ((ov (make-overlay (point-min) (point-min))))
;;     (overlay-put ov 'face 'secondary-selection)
;;     ov)
;;   "Overlay variable for GUD highlighting.")

;; (defadvice gud-display-line (after my-gud-highlight act)
;;            "Highlight current line."
;;            (let* ((ov gud-overlay)
;;                   (bf (gud-find-file true-file)))
;;              (with-current-buffer (move-overlay ov (line-beginning-position) (line-end-position)))))

;; (defun gud-kill-buffer ()
;;   (if (eq major-mode 'gud-mode)
;;     (delete-overlay gud-overlay)))

;; (add-hook 'kill-buffer-hook 'gud-kill-buffer)


;; =================================
;; GDB configuration
;; =================================

(use-package gud
  :ensure t)
(use-package gdb-mi
  :ensure t)
(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer t)

;; ====================================
;; GUI layout
;; ====================================

(defun gdb-setup-windows ()
  "Define layout for gdb-many-windows"
  (gdb-get-buffer-create 'gdb-locals-buffer)
  (gdb-get-buffer-create 'gdb-stack-buffer)
  (gdb-get-buffer-create 'gdb-breakpoints-buffer)
  (set-window-dedicated-p (selected-window) nil)
  (switch-to-buffer gud-comint-buffer)
  (delete-other-windows)
  (let ((win0 (selected-window))
        (win1 (split-window nil ( / ( * (window-height) 3) 4)))
        (win2 (split-window nil ( / (window-height) 3)))
        (win3 (split-window-right)))
    (gdb-set-window-buffer (gdb-locals-buffer-name) nil win3)
    (select-window win2)
    (if gud-last-last-frame
        (set-window-buffer
         win2
         (gud-find-file (car gud-last-last-frame))))
    (setq gdb-source-window (selected-window))
    (let ((win4 (split-window-right)))
      (gdb-set-window-buffer
       (gdb-get-buffer-create 'gdb-inferior-io) nil win4))
    (select-window win1)
    (gdb-set-window-buffer (gdb-stack-buffer-name))
    (let ((win5 (split-window-right)))
      (gdb-set-window-buffer (if gdb-show-threads-by-default
                                 (gdb-threads-buffer-name)
                               (gdb-breakpoints-buffer-name))
                             nil win5))
    (select-window win0)))


;; =======================================
;; Restore window layout after closing gdb
;; =======================================

;; Select a register number which is unlikely to get used elsewere
(defconst before-gdb-windows-config-register 313465989
   "Internal used")

(defvar before-gdb-windows-config nil)

(defun set-before-gdb-windows-config (gdb)
  (setq before-gdb-windows-config (window-configuration-to-register before-gdb-windows-config-register)))

(defun restore-before-gdb-windows-config ()
  (jump-to-register before-gdb-windows-config-register))

(advice-add 'gdb :before #'set-before-gdb-windows-config)
(advice-add 'gdb-reset :after #'restore-before-gdb-windows-config)


(provide 'gdb-settings)
