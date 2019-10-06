
;; remove autointend from rst mode
(defun my-rst-mode-hook ()
  "My personal rst mode hook."
  (local-set-key (kbd "RET") '(lambda () (interactive) (newline 1))))

(add-hook 'rst-mode-hook 'my-rst-mode-hook)

(use-package markdown-mode
  :ensure t)

(provide 'rst-settings)
