

;; cpp with rtags
(use-package rtags
  :ensure t)
(use-package flycheck
  :ensure t)
(use-package flycheck-rtags
  :ensure t)
;; ensure that we use only rtags checking
;; https://github.com/Andersbakken/rtags#optional-1
(defun setup-flycheck-rtags ()
  (interactive)
  (flycheck-select-checker 'rtags)
  ;; RTags creates more accurate overlays.
  (setq-local flycheck-highlighting-mode nil)
  (setq-local flycheck-check-syntax-automatically nil))

(use-package company
  :ensure t)
(use-package company-rtags
  :ensure t)
(define-key c-mode-base-map (kbd "M-.")
  (function rtags-find-symbol-at-point))
(define-key c-mode-base-map (kbd "M-,")
  (function rtags-location-stack-back))
(rtags-enable-standard-keybindings)
(setq rtags-autostart-diagnostics t)
(rtags-diagnostics)
(setq rtags-completions-enabled t)
(push 'company-rtags company-backends)
;; (global-company-mode)
(define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
(add-hook 'c-mode-common-hook #'setup-flycheck-rtags)

(use-package jedi
  :ensure t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional

(provide 'autocomplete-settings)
