
(use-package cmake-mode
  :ensure t)

(require 'cc-mode)

(fset 'add_block_brackets
   [return ?\{ return return ?\} up tab])

(define-key c-mode-base-map (kbd "C-{") 'add_block_brackets)

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

(require 'ansi-color)
(defun my-colorize-compilation-buffer ()
  (when (eq major-mode 'compilation-mode)
    (ansi-color-apply-on-region compilation-filter-start (point-max))))
(add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer)


(require 'cff)
(define-key c-mode-base-map (kbd "M-o")
  (function cff-find-other-file))

(defun my-next-error ()
  "Jump to next error - not warning"
  (interactive)
  (compilation-set-skip-threshold 2)
  (compilation-next-error 1)
  (compilation-set-skip-threshold 1))

(defun my-previous-error ()
  "Jump to next error - not warning"
  (interactive)
  (compilation-set-skip-threshold 2)
  (compilation-next-error -1)
  (compilation-set-skip-threshold 1))


(define-key compilation-mode-map (kbd "C-x M-n") 'my-next-error)
(define-key compilation-mode-map (kbd "C-x M-p") 'my-previous-error)

(custom-set-variables '(c-noise-macro-names '("constexpr")))

(provide 'cpp-settings)
