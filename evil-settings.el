
(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (add-to-list 'evil-emacs-state-modes 'special-mode)
  :custom
  (evil-disable-insert-state-bindings t)
  (evil-shift-width 2)
  )

(use-package evil-commentary
  :ensure t
  :config
  (evil-commentary-mode 1))

(use-package key-chord
  :ensure t
  :config
  (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
  (key-chord-mode 1))

(provide 'evil-settings)
