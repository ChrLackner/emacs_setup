

;; ------------------ ccls setup --------------------------

(use-package projectile
  :ensure t)

;; (use-package flycheck
;;   :ensure t
;;   :custom
;;   (flycheck-check-syntax-automatically '(mode-enabled save))
;;   )

(use-package lsp-mode
  :commands lsp
  :bind (:map evil-normal-state-map (("M-." . 'xref-find-definitions)))
  :config
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "pyls")
                    :major-modes '(python-mode)
                    :server-id 'pyls)
   )
  (setq lsp-prefer-flymake nil)
  (setq lsp-pyls-plugins-pycodestyle-enabled nil)
  (setq lsp-pyls-plugins-jedi-hover-enabled nil)
  (setq lsp-pyls-plugins-mccabe-enabled nil)
  (setq lsp-pyls-plugins-autopep8-enabled nil)
  (setq lsp-pyls-plugins-pyflakes-enabled nil)
  (setq lsp-file-watch-threshold 3000)
  ;; (setq lsp-diagnostics-provider :flycheck)
  (setq lsp-diagnostics-provider :none)
  :hook ((python-mode . lsp))
  :custom
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-on-type-formatting nil))
;; (use-package lsp-ui
;;   :commands lsp-ui-mode)
;; (use-package company-lsp
;;   :commands company-lsp)
;; (use-package flymake :ensure t)

(use-package ccls
  :defer t
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp)))
  :custom
  (ccls-executable "/usr/bin/ccls"))

(use-package company-lsp
  :defer t
  :commands company-lsp
  :config (push 'company-lsp company-backends)
  ) ;; add company-lsp as a backend

(use-package yas
  :defer t
  :hook (lsp-mode . yas-minor-mode))

;; ----------------- end ccls setup ----------------------------

;; ------------------------ rtags setup --------------------------
;; ;; cpp with rtags
;; (use-package rtags
;;   :ensure t)


;; ;; patch rtags-find-symbol-at-point to exclude git/install/netgen dir
;; ;; so that results are only found in other target (which is netgen source dir)
;; (defun rtags-find-symbol-at-point (&optional prefix)
;;   "Find the natural target for the symbol under the cursor and moves to that location.
;; For references this means to jump to the definition/declaration of the referenced symbol (it jumps to the definition if it is indexed).
;; For definitions it jumps to the declaration (if there is only one) For declarations it jumps to the definition.
;; If called with prefix, open first match in other window"
;;   (interactive "P")
;;   (let ((otherwindow (and prefix (listp prefix)))
;;         (pathfilter (if (and (numberp prefix) (rtags-buffer-file-name))
;;                       (and (numberp prefix) (rtags-buffer-file-name))
;;                       "^((?!git/install/netgen).)*$")))
;;         ;; (pathfilter (and (numberp prefix) (rtags-buffer-file-name))))
;;     (when (or (not (rtags-called-interactively-p)) (rtags-sandbox-id-matches))
;;       (rtags-location-stack-push)
;;       (let ((arg (rtags-current-location))
;;             (tagname (or (rtags-current-symbol) (rtags-current-token)))
;;             (fn (rtags-buffer-file-name)))
;;         (rtags-reparse-file-if-needed)
;;         (let ((results (with-temp-buffer
;;                          (rtags-call-rc :path fn :path-filter pathfilter "-Z -f" arg (if rtags-multiple-targets "--all-targets"))
;;                          (when (and (= (rtags-buffer-lines) 0)
;;                                     rtags-follow-symbol-try-harder
;;                                     (> (length tagname) 0))
;;                            (rtags-call-rc :path-filter pathfilter :path fn "-F" tagname "--definition-only" "-M" "1" "--dependency-filter" fn)
;;                            (when (= (rtags-buffer-lines) 0)
;;                              (rtags-call-rc :path fn :path-filter pathfilter "-F" tagname "-M" "1" "--dependency-filter" fn)))
;;                          (cons (buffer-string) (rtags-buffer-lines))))
;;               (buffer (get-buffer rtags-buffer-name)))
;;           (when (and buffer
;;                      (eq (buffer-local-value 'rtags-results-buffer-type buffer) 'find-symbol-at-point))
;;             (rtags-delete-rtags-windows)
;;             (kill-buffer buffer))
;;           (cond ((= (cdr results) 0) nil)
;;                 ((= (cdr results) 1)
;;                  (with-temp-buffer
;;                    (insert (car results))
;;                    (goto-char (point-min))
;;                    (rtags-handle-results-buffer tagname nil nil fn otherwindow 'find-symbol-at-point t)))
;;                 (t
;;                  (rtags-delete-rtags-windows)
;;                  (with-current-buffer (rtags-get-buffer)
;;                    (insert (car results))
;;                    (goto-char (point-min))
;;                    (rtags-handle-results-buffer tagname nil nil fn otherwindow 'find-symbol-at-point)))))))))


;; (use-package flycheck-rtags
;;   :ensure t)
;; ;; ensure that we use only rtags checking
;; ;; https://github.com/Andersbakken/rtags#optional-1
;; (defun setup-flycheck-rtags ()
;;   (interactive)
;;   (flycheck-select-checker 'rtags)
;;   ;; RTags creates more accurate overlays.
;;   (setq-local flycheck-highlighting-mode nil)
;;   (setq-local flycheck-check-syntax-automatically nil))

;; (use-package company-rtags
;;   :ensure t)
;; (define-key c-mode-base-map (kbd "M-.")
;;   (function rtags-find-symbol-at-point))
;; (define-key c-mode-base-map (kbd "M-,")
;;   (function rtags-location-stack-back))
;; (define-key c-mode-base-map (kbd "M-?")
;;   (function rtags-display-summary))
;; (rtags-enable-standard-keybindings)
;; (setq rtags-autostart-diagnostics t)
;; ;; (rtags-diagnostics)
;; (setq rtags-completions-enabled t)
;; (push 'company-rtags company-backends)
;; ;; (global-company-mode)
;; (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
;; (add-hook 'c-mode-common-hook #'setup-flycheck-rtags)

;; (define-key c-mode-base-map (kbd "C-x C-n")
;;   (function rtags-next-match))
;; (define-key c-mode-base-map (kbd "C-x C-p")
;;   (function rtags-previous-match))

;; (rtags-start-process-unless-running)

;; ------------------------ end rtags setup ------------------------

;; (use-package jedi
;;   :hook (python-mode . jedi:setup)
;;   :config
;;   (setq jedi:setup-keys t)
;;   (setq jedi:complete-on-dot t))
;; ;; (setq completion-cycle-threshold 3)

(provide 'autocomplete-settings)
