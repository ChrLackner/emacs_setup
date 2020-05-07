
(use-package cmake-mode
  :ensure t)

(require 'cc-mode)

;; (require 'dired)
;; (define-key dired-mode-map (kbd "C-c c") (lambda () (interactive) (compile "make -j")))
;; (define-key dired-mode-map (kbd "C-c i") (lambda () (interactive) (compile "make -j install")))

;; (require 'compile)
;; (define-key compilation-mode-map (kbd "C-c c") (lambda () (interactive) (compile "make -j")))
;; (define-key compilation-mode-map (kbd "C-c i") (lambda () (interactive) (compile "make -j install")))


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

(ignore-errors
  (require 'ansi-color)
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))


;; ;; format using clang-format
;; (require 'clang-format)
;; (setq clang-format-style-option "llvm")

;; (define-key c-mode-base-map (kbd "C-M-\\")
;;   (function clang-format-region))
;; (define-key c-mode-base-map (kbd "C-i")
;;   (function clang-format))

;; (with-eval-after-load 'cc-mode
;;   (fset 'c-indent-region 'clang-format-region))

(require 'cff)
(define-key c-mode-base-map (kbd "M-o")
  (function cff-find-other-file))

(provide 'cpp-settings)
