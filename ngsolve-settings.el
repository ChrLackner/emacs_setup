

(defun run-ngsolve ()
  (interactive)
  (let* ((filename buffer-file-name))
    (other-window 1)
    (if (get-buffer "*shx*")
        (switch-to-buffer "*shx*")
      (shx))
    (insert (concat "ngsolve " filename))
    (shx-send-input)
    )
  )

(defun run-netgen ()
  (interactive)
  (let* ((filename buffer-file-name))
    (other-window 1)
    (if (get-buffer "*shx*")
        (switch-to-buffer "*shx*")
      (shx))
    (insert (concat "netgen " filename))
    (shx-send-input)
    )
  )

(defun my-run-python ()
  (interactive)
  (let* ((filename buffer-file-name))
    (other-window 1)
    (if (get-buffer "*shx*")
        (switch-to-buffer "*shx*")
      (shx))
    (insert (concat "python " filename))
    (shx-send-input)
    )
  )


(use-package python
  :ensure t)
(define-key python-mode-map (kbd "C-c n") 'run-ngsolve)
(define-key python-mode-map (kbd "C-c y") 'my-run-python)
(define-key python-mode-map (kbd "C-c m") 'run-netgen)


(provide 'ngsolve-settings)
