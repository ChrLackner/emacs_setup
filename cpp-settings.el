
(use-package cmake-mode)
(use-package cc-mode
  :init
  (fset 'add_block_brackets
        [return ?\{ return return ?\} up tab])
  :bind (:map c-mode-base-map
              ("C-{" . 'add_block_brackets))
  )



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

(use-package cff
  :bind (:map c-mode-base-map
              ("M-o" . 'cff-find-other-file)))

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


(use-package compile
  :bind (:map compilation-mode-map
              ("C-x M-n" . 'my-next-error)
              ("C-x M-p" . 'my-previous-error)))

(custom-set-variables '(c-noise-macro-names '("constexpr")))

(use-package glsl-mode
  :mode (rx (or ".vert" ".frag" ".geom" ".tesc" ".tese" ".inc")))

(provide 'cpp-settings)
