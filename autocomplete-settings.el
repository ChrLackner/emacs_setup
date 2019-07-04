

;; cpp with rtags

;; cpp autocomplete with rtags is too slow...
;; (require 'rtags)

;; ;; ensure that we use only rtags checking
;; ;; https://github.com/Andersbakken/rtags#optional-1
;; (defun setup-flycheck-rtags ()
;;   (interactive)
;;   (flycheck-select-checker 'rtags)
;;   ;; RTags creates more accurate overlays.
;;   (setq-local flycheck-highlighting-mode nil)
;;   (setq-local flycheck-check-syntax-automatically nil))

;; ;; make sure you have company-mode installed
;; (require 'company)
;; (define-key c-mode-base-map (kbd "M-.")
;;   (function rtags-find-symbol-at-point))
;; (define-key c-mode-base-map (kbd "M-,")
;;   (function rtags-find-references-at-point))
;; ;; disable prelude's use of C-c r, as this is the rtags keyboard prefix
;; ;; (define-key prelude-mode-map (kbd "C-c r") nil)
;; ;; install standard rtags keybindings. Do M-. on the symbol below to
;; ;; jump to definition and see the keybindings.
;; (rtags-enable-standard-keybindings)
;; ;; comment this out if you don't have or don't use helm
;; ;; (setq rtags-use-helm t)
;; ;; company completion setup
;; (setq rtags-autostart-diagnostics t)
;; (rtags-diagnostics)
;; (setq rtags-completions-enabled t)
;; (push 'company-rtags company-backends)
;; (global-company-mode)
;; (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
;; ;; use rtags flycheck mode -- clang warnings shown inline
;; (require 'flycheck-rtags)
;; ;; c-mode-common-hook is also called by c++-mode
;; (add-hook 'c-mode-common-hook #'setup-flycheck-rtags)

;; python autocomplete
(require 'python)

(require 'jedi)

(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional
(add-hook 'python-mode-hook 'jedi:setup)

;; (require 'company-jedi)
;; (setq py-python-command "/usr/bin/python3")

;; (setq jedi:server-command (list "python3" jedi:server-script))
;; (setq jedi:environment-root "jedi")
;; (setq jedi:environment-virtualenv
;;       (append python-environment-virtualenv
;;               '("--python" "/usr/bin/python3")))


;; (add-hook 'after-init-hook 'global-company-mode)
;; (defun my/python-mode-hook ()
;;   (add-to-list 'company-backends 'company-jedi))
;; (add-hook 'python-mode-hook 'my/python-mode-hook)


;; (require 'company-quickhelp)
;; (company-quickhelp-mode)

(provide 'autocomplete-settings)
