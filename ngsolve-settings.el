;; -*- lexical-binding: t; -*-


(defun my-run-in-shell (cmd)
  "Run CMD on the current file in the *shx* buffer of the other window."
  (let* ((filename (file-name-nondirectory buffer-file-name))
         (directory  (file-name-directory buffer-file-name)))
    (other-window 1)
    (if (get-buffer "*shx*")
        (switch-to-buffer "*shx*")
      (shx))
    (goto-char (point-max))
    (move-beginning-of-line nil)
    (unless (eq (point) (point-max))
      (kill-line))
    (insert (concat "cd " directory " && " cmd " " filename))
    (shx-send-input)))

(defun run-ngsolve () (interactive) (my-run-in-shell "nice ngsolve"))
(defun run-netgen () (interactive) (my-run-in-shell "nice netgen"))
(defun my-run-mpi () (interactive) (my-run-in-shell "mpirun -np 6 python"))
(defun my-run-python () (interactive) (my-run-in-shell "python"))

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
    (font-lock-add-keywords nil '(("\\<\\(solid\\|tlo\\|boundaryconditionname\\|algebraic3d\\)\\>" . 'font-lock-builtin-face)))
    (font-lock-add-keywords nil '(("\\<\\( orthobrick\\| plane\\| cylinder\\| polyhedron\\| torus\\)\\>" . 'font-lock-function-name-face)))
    )


(define-key netgen-geo-mode-map (kbd "C-c m") 'run-netgen)

(add-to-list 'auto-mode-alist '("\\.geo\\'" . netgen-geo-mode))

(setq python-shell-interpreter "python3")

;; (defun open-ngsolve-file (filename)
;;   "Open file in NGSolve repo"
;;   (interactive (list (completing-read "File name: " (mapcar 'file-name-nondirectory (directory-files-recursively "~/git/source/ngsolve" ".*\.hpp")))))
;;   (find-file (car (cl-remove-if (lambda (k) (string-match-p ".*\.#.*" k)) (directory-files-recursively "~/git/source/ngsolve" (concat ".*" filename))))))

;; (global-set-key (kbd "C-x C-l") 'open-ngsolve-file)

(provide 'ngsolve-settings)
