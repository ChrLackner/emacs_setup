

(defun run-ngsolve ()
  (interactive)
  (let* ((filename (file-name-nondirectory buffer-file-name))
         (directory  (file-name-directory buffer-file-name)))
    (other-window 1)
    (if (get-buffer "*shx*")
        (switch-to-buffer "*shx*")
      (shx))
    (goto-char (point-max))
    (move-beginning-of-line nil)
    (if (eq (point) (point-max))
        nil
      (kill-line))
    (insert (concat "cd " directory " && nice prime-run ngsolve --noConsole " filename))
    (shx-send-input)
    )
  )

(defun run-netgen ()
  (interactive)
  (let* ((filename (file-name-nondirectory buffer-file-name))
         (directory  (file-name-directory buffer-file-name)))
    (other-window 1)
    (if (eq system-type 'windows-nt)
        (if (get-buffer "*PowerShell*")
            (switch-to-buffer "*PowerShell*")
          (powershell))
      (if (get-buffer "*shx*")
          (switch-to-buffer "*shx*")
        (shx)))
    (goto-char (point-max))
    (move-beginning-of-line nil)
    (if (eq (point) (point-max))
        nil
      (kill-line))
    (insert (concat "cd " directory " && nice netgen " filename))
    (shx-send-input)
    )
  )

(defun my-run-mpi()
  (interactive)
  (let* ((filename (file-name-nondirectory buffer-file-name))
         (directory  (file-name-directory buffer-file-name)))
    (other-window 1)
    (if (get-buffer "*shx*")
        (switch-to-buffer "*shx*")
      (shx))
    (goto-char (point-max))
    (move-beginning-of-line nil)
    (if (eq (point) (point-max))
        nil
      (kill-line))
    (insert (concat "cd " directory " && mpirun -np 6 python " filename))
    (shx-send-input)
    )
  )

(defun my-run-python ()
  (interactive)
  (let* ((filename (file-name-nondirectory buffer-file-name))
         (directory  (file-name-directory buffer-file-name)))
    (other-window 1)
    (if (get-buffer "*shx*")
        (switch-to-buffer "*shx*")
      (shx))
    (goto-char (point-max))
    (move-beginning-of-line nil)
    (if (eq (point) (point-max))
        nil
      (kill-line))
    (insert (concat "cd " directory " && python " filename))
    (shx-send-input)
    )
  )



(use-package python
  :bind (:map python-mode-map
              ("C-c n" . 'run-ngsolve)
              ("C-c y" . 'my-run-python)
              ("C-c m" . 'run-netgen)
              ("C-c p" . 'my-run-mpi)))

(define-derived-mode netgen-geo-mode prog-mode "Geo File"
    "Netgen geo file mode"
    (setq comment-start "#")
    (setq comment-end "")

    (let ((map (make-sparse-keymap)))
      (define-key map [C-c m] 'run-netgen)
      map)
    (font-lock-add-keywords nil '(("\\<\\(solid\\|tlo\\|boundaryconditionname\\|algebraic3d\\)\\>" . 'font-lock-builtin-face)))
    (font-lock-add-keywords nil '(("\\<\\( orthobrick\\| plane\\| cylinder\\| polyhedron\\| torus\\)\\>" . 'font-lock-function-name-face)))
    )


(add-to-list 'auto-mode-alist '("\\.geo\\'" . netgen-geo-mode))

(setq python-shell-interpreter "python3")

;; (defun open-ngsolve-file (filename)
;;   "Open file in NGSolve repo"
;;   (interactive (list (completing-read "File name: " (mapcar 'file-name-nondirectory (directory-files-recursively "~/git/source/ngsolve" ".*\.hpp")))))
;;   (find-file (car (cl-remove-if (lambda (k) (string-match-p ".*\.#.*" k)) (directory-files-recursively "~/git/source/ngsolve" (concat ".*" filename))))))

;; (global-set-key (kbd "C-x C-l") 'open-ngsolve-file)

(provide 'ngsolve-settings)
