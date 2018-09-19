
(require 'company)

(require 'python)
;; (require 'company-jedi)
;; (setq py-python-command "/usr/bin/python3")

;; (setq jedi:environment-root "jedi")
;; ;; (setq jedi:environment-virtualenv
;; ;;       (append python-environment-virtualenv
;; ;;               '("--python" "/usr/bin/python3")))


;; (add-hook 'after-init-hook 'global-company-mode)
;; (defun my/python-mode-hook ()
;;   (add-to-list 'company-backends 'company-jedi))
;; (add-hook 'python-mode-hook 'my/python-mode-hook)

;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:complete-on-dot t)

(provide 'autocomplete-settings)
