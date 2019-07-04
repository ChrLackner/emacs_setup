;; define a function to load the current file into netgen in an
;; async process and open the buffer in a new window
(defun shelllike-filter (proc string)
  (let* ((buffer (process-buffer proc))
         (window (get-buffer-window buffer)))
    (with-current-buffer buffer
      (if (not (mark)) (push-mark))
      (exchange-point-and-mark) ;Use the mark to represent the cursor location
      (dolist (char (append string nil))
    (cond ((char-equal char ?\r)
           (move-beginning-of-line 1))
          ((char-equal char ?\n)
           (move-end-of-line 1) (newline))
          (t
           (if (/= (point) (point-max)) ;Overwrite character
           (delete-char 1))
           (insert char))))
      (exchange-point-and-mark))
    (if window
      (with-selected-window window
        (goto-char (point-max))))))

(defun run-ngsolve ()
  (interactive)
  (start-file-process-shell-command "ngsolve" "*ngsolve*"
                                    (format "optirun python3 -m ngsgui %s -no -dc"
                                            (shell-quote-argument (buffer-file-name))))
  (switch-to-buffer-other-window "*ngsolve*")
  )

(defun run-netgen ()
  (interactive)
  (progn
    (setq proc
          (start-file-process-shell-command "netgen" "*netgen*"
                                            (format "netgen %s"
                                                    (shell-quote-argument (buffer-file-name))))
          )
    (set-process-filter proc 'shelllike-filter))
  (switch-to-buffer-other-window "*netgen*")
  (buffer-disable-undo)
  (shell-mode)
  )

(defun my-run-python ()
  (interactive)
  (progn
    (setq proc
          (start-file-process-shell-command "python" "python"
                                            (format "python3 %s"
                                                    (shell-quote-argument (buffer-file-name))))
          )
    (set-process-filter proc 'shelllike-filter))
  (switch-to-buffer-other-window "python")
  (buffer-disable-undo)
  (shell-mode)
  )
(require 'python)
(define-key python-mode-map (kbd "C-c n") 'run-ngsolve)
(define-key python-mode-map (kbd "C-c y") 'my-run-python)
(define-key python-mode-map (kbd "C-c m") 'run-netgen)


(provide 'ngsolve-settings)
