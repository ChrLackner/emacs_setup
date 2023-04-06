
(if (eq system-type 'windows-nt)
    (progn
      (setq exec-path (add-to-list 'exec-path "C:/Program Files/Git/bin"))
      (setenv "PATH" (concat "C:/Program Files/Git/bin" path-separator (getenv "PATH")))))

(use-package magit
  :ensure t
  :bind (("C-x g" . 'magit-status)
         ("C-c b" . 'magit-blame))
  :config
  (set-face-background 'magit-diff-whitespace-warning "sandy brown"))

(use-package magit-lfs
  :ensure t)

(provide 'magit-settings)
