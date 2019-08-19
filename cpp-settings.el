
(require 'cc-mode)

(require 'dired)
(define-key dired-mode-map (kbd "C-c c") (lambda () (interactive) (compile "make -j")))
(define-key dired-mode-map (kbd "C-c i") (lambda () (interactive) (compile "make -j install")))

(require 'compile)
(define-key compilation-mode-map (kbd "C-c c") (lambda () (interactive) (compile "make -j")))
(define-key compilation-mode-map (kbd "C-c i") (lambda () (interactive) (compile "make -j install")))


(fset 'add_block_brackets
   [return ?\{ return return ?\} up tab])

(define-key c-mode-base-map (kbd "C-{") 'add_block_brackets)

(defun build (prog)
  (interactive
   (list (completing-read "Source: " (directory-files "~/gitlab/source"))))
  (if (file-exists-p (format "~/gitlab/source/%s/setup.py" prog))
      (async-shell-command (format "python3 -m pip install --no-deps --user ~/gitlab/source/%s" prog))
    (compile (format "make -j 6 -C ~/gitlab/build/%s install" prog))))

(defun demangle-at-point ()
  (interactive)
   (message (shell-command-to-string (concat "c++filt _" (thing-at-point 'word))))
   )


(defun insert-header-guard (guardstr)
  "Insert a header guard named GUARDSTR in a c++ file."
  (interactive "sHeader guard: ")
  (progn
    (insert "#ifndef " guardstr "\n")
    (insert "#define " guardstr "\n\n")
    (save-excursion
      (insert "\n\n")
      (insert "#endif // " guardstr))))

(defun insert-namespace (name)
  "Insert a namespace"
  (interactive "sNamespace name: ")
  (progn
    (insert "namespace " name "\n{\n  ")
    (save-excursion
      (insert "\n} // namespace " name))))

(provide 'cpp-settings)
