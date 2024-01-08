
(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (add-to-list 'evil-emacs-state-modes 'special-mode)
  (add-to-list 'evil-emacs-state-modes 'dired-mode)
  (add-to-list 'evil-emacs-state-modes 'compilation-mode)
  (add-to-list 'evil-emacs-state-modes 'edebug-mode)
  ;; remove all keybindings from insert-state keymap
  (setcdr evil-insert-state-map nil)
  :custom
  (evil-disable-insert-state-bindings t)
  (evil-shift-width 2)
  :bind (("C-j" . evil-normal-state))
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
