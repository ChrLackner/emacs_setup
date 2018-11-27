
;; ===================================================================
;; Add color to the current GUD line (obrigado google)
;; ===================================================================

(defvar gud-overlay
  (let* ((ov (make-overlay (point-min) (point-min))))
    (overlay-put ov 'face 'secondary-selection)
    ov)
  "Overlay variable for GUD highlighting.")

(defadvice gud-display-line (after my-gud-highlight act)
           "Highlight current line."
           (let* ((ov gud-overlay)
                  (bf (gud-find-file true-file)))
             (with-current-buffer (move-overlay ov (line-beginning-position) (line-end-position)))))

(defun gud-kill-buffer ()
  (if (eq major-mode 'gud-mode)
    (delete-overlay gud-overlay)))

(add-hook 'kill-buffer-hook 'gud-kill-buffer)


;; =================================
;; GDB configuration
;; =================================

(require 'gud)
(require 'gdb-mi)
(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer t)

;; ====================================
;; GUI layout
;; ====================================

(defun gdb-setup-windows ()
  "Define layout for gdb-many-windows"
  (gdb-display-locals-buffer)
  (delete-other-windows)
  (gdb-display-stack-buffer)
  (delete-other-windows)
  (gdb-display-breakpoints-buffer)
  (delete-other-windows)
  ;; Don't dedicate.
  (switch-to-buffer gud-comint-buffer)
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

(provide 'gdb-settings)
