

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
    (insert (concat "cd " directory " && nice ngsolve " filename))
    (shx-send-input)
    )
  )

(defun run-netgen ()
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
    (insert (concat "cd " directory " && nice python " filename))
    (shx-send-input)
    )
  )



(use-package python
  :bind (:map python-mode-map
              ("C-c n" . 'run-ngsolve)
              ("C-c y" . 'my-run-python)
              ("C-c m" . 'run-netgen)
              ("C-c p" . 'my-run-mpi)))



(defvar netgen-geo-keywords
  '("solid" "tlo" "boundaryconditionname"))

(define-derived-mode netgen-geo-mode python-mode "Geo File"
    "Netgen geo file mode"
    ;; you again used quote when you had '((mydsl-hilite))
    ;; I just updated the variable to have the proper nesting (as noted above)
    ;; and use the value directly here
    ;; (setq font-lock-defaults mydsl-font-lock-defaults)

    ;; when there's an override, use it
    ;; otherwise it gets the default value
    ;; (when mydsl-tab-width
    ;;   (setq tab-width mydsl-tab-width))

    ;; for comments
    ;; overriding these vars gets you what (I think) you want
    ;; they're made buffer local when you set them
    (setq comment-start "#")
    (setq comment-end "")


    (font-lock-add-keywords nil '(("\\<\\(solid\\|tlo\\|boundaryconditionname\\|algebraic3d\\)\\>" . 'font-lock-type-face)))
    ;; (font-lock-add-keywords nil '(("\\<\\(orthobrick\\|plane\\|cylinder\\|polyhedron\\|torus\\)\\>" . 'font-lock-function-name-face)))

    ;; (font-lock-add-keywords nil '((rx (or "solid" "tlo")) . 'font-lock-keyword-face))

    ;; (modify-syntax-entry ?# "< b" mydsl-mode-syntax-table)
    ;; (modify-syntax-entry ?\n "> b" mydsl-mode-syntax-table)

    ;; Note that there's no need to manually call `mydsl-mode-hook'; `define-derived-mode'
    ;; will define `mydsl-mode' to call it properly right before it exits
    )

(add-to-list 'auto-mode-alist '("\\.geo\\'" . netgen-geo-mode))

(setq python-shell-interpreter "python3")

;; (defun open-ngsolve-file (filename)
;;   "Open file in NGSolve repo"
;;   (interactive (list (completing-read "File name: " (mapcar 'file-name-nondirectory (directory-files-recursively "~/git/source/ngsolve" ".*\.hpp")))))
;;   (find-file (car (cl-remove-if (lambda (k) (string-match-p ".*\.#.*" k)) (directory-files-recursively "~/git/source/ngsolve" (concat ".*" filename))))))

;; (global-set-key (kbd "C-x C-l") 'open-ngsolve-file)

(provide 'ngsolve-settings)
