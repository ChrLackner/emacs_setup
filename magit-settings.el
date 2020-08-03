
(use-package magit
  :ensure t)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c b") 'magit-blame)


(set-face-background 'magit-diff-whitespace-warning "sandy brown")

(provide 'magit-settings)
