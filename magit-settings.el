
(use-package magit
  :defer t
  :bind (("C-x g" . 'magit-status)
         ("C-c b" . 'magit-blame))
  :config
  (set-face-background 'magit-diff-whitespace-warning "sandy brown"))

(provide 'magit-settings)
