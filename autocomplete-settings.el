
;; COPILOT
(use-package quelpa
  :ensure t)
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

(use-package editorconfig
  :ensure t)

(use-package copilot
  :quelpa (copilot.el :fetcher github
                      :repo "zerolfx/copilot.el"
                      :branch "main"
                      :ensure t
                      :files ("dist" "*.el")))
(add-hook 'prog-mode-hook 'copilot-mode)
(add-hook 'html-mode-hook 'copilot-mode)
(add-hook 'markdown-mode-hook 'copilot-mode)
(add-hook 'org-mode-hook 'copilot-mode)
(define-key copilot-completion-map (kbd "M-<return>") 'copilot-accept-completion)
(define-key copilot-completion-map (kbd "M-C-<return>") 'copilot-accept-completion-by-word)
(define-key copilot-completion-map (kbd "M-<tab>") 'copilot-next-completion)
;; COPILOT END

;; TABNINE
(use-package company :ensure t)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'yas-global-mode)
;; (use-package company-tabnine :ensure t)
;; (add-to-list 'company-backends #'company-tabnine)

;; ;; Trigger completion immediately.
;; (setq company-idle-delay 0)

;; ;; Number the candidates (use M-1, M-2 etc to select completions).
;; (setq company-show-numbers t)

;; TABNINE END


;; LSP
;; get environment variable PATH
(if (eq system-type 'windows-nt)
    (setenv "PATH" (concat (getenv "PATH") (file-name-directory (executable-find "node")) ";"))
  (use-package lsp-pyright
    :ensure t
    :bind (:map evil-normal-state-map (("M-." . 'xref-find-definitions)))
    :hook ((python-mode . lsp-deferred)
           (c-mode . lsp-deferred)
           (c++-mode . lsp-deferred))
    :config
    (setq gc-cons-threshold 1000000)
    (setq read-process-output-max (* 1024 1024)) ;; 1mb
    :custom
    (lsp-headerline-breadcrumb-enable nil)
    (lsp-lens-enable nil)
    (lsp-ui-sideline-enable nil)
    (lsp-ui-doc-enable nil)
    (lsp-modeline-code-actions nil)
    (lsp-ui-sideline-enable nil)
    )
  )
;; LS END


;; ------------------ ccls setup --------------------------

;; (use-package projectile
  ;; :ensure t)

;; (global-eldoc-mode -1)

;; (let ((default-directory  "~/.emacs.d/settings/resources"))
;;   (normal-top-level-add-subdirs-to-load-path))

;; (require 'yasnippet)
;; (yas-global-mode 1)

;; (require 'lsp-bridge)
;; (global-lsp-bridge-mode)
;; (setq lsp-bridge-complete-manually t)
;; (global-set-key (kbd "M-.") 'lsp-bridge-find-def-other-window)
;; (global-set-key (kbd "M-,") 'lsp-bridge-find-def-return)

;; ;; (use-package flycheck
;; ;;   :ensure t
;; ;;   :custom
;; ;;   (flycheck-check-syntax-automatically '(mode-enabled save))
;; ;;   )

;; (use-package lsp-mode
;;   :commands lsp
;;   :bind (:map evil-normal-state-map (("M-." . 'xref-find-definitions)))
;;   :config
;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-stdio-connection "pyls")
;;                     :major-modes '(python-mode)
;;                     :server-id 'pyls)
;;    )
;;   (setq lsp-prefer-flymake nil)
;;   (setq lsp-pyls-plugins-pycodestyle-enabled nil)
;;   (setq lsp-pyls-plugins-jedi-hover-enabled nil)
;;   (setq lsp-pyls-plugins-mccabe-enabled nil)
;;   (setq lsp-pyls-plugins-autopep8-enabled nil)
;;   (setq lsp-pyls-plugins-pyflakes-enabled nil)
;;   (setq lsp-lens-enable nil)
;;   (setq lsp-diagnostics-enable nil)
;;   (setq lsp-file-watch-threshold 3000)
;;   (setq gc-cons-threshold 100000000)
;;   (setq read-process-output-max (* 1024 1024)) ;; 1mb
;;   ;; (setq lsp-diagnostics-provider :flycheck)
;;   (setq lsp-modeline-diagnostics-enable nil)
;;   (setq lsp-diagnostics-provider :none)
;;   ;; (setq lsp-ui-sideline-enable nil)
;;   ;; (setq lsp-ui-sideline-show-diagnostics nil)
;;   ;; (setq lsp-ui-doc-enable nil)
;;   ;; (setq company-auto-complete t)
;;   :hook ((python-mode . lsp-deferred))
;;   :custom
;;   (flycheck-check-syntax-automatically '(mode-enabled save))
;;   )

;; (use-package lsp-mode
;;   :commands lsp
;;   :bind (:map evil-normal-state-map (("M-." . 'xref-find-definitions)))
;;   :config
;;   (lsp-register-client
;;    (make-lsp-client :new-connection (lsp-stdio-connection "pyls")
;;                     :major-modes '(python-mode)
;;                     :server-id 'pyls)
;;    )
;;   ;; (setq lsp-prefer-flymake nil)
;;   ;; (setq lsp-prefer-capf t)
;;   ;; (setq lsp-pyls-plugins-pycodestyle-enabled nil)
;;   ;; (setq lsp-pyls-plugins-jedi-hover-enabled nil)
;;   ;; (setq lsp-pyls-plugins-mccabe-enabled nil)
;;   ;; (setq lsp-pyls-plugins-autopep8-enabled nil)
;;   ;; (setq lsp-pyls-plugins-pyflakes-enabled nil)
;;   ;; (setq lsp-lens-enable nil)
;;   ;; (setq lsp-diagnostics-enable nil)
;;   ;; (setq lsp-modeline-diagnostics-enable nil)
;;   ;; (setq lsp-diagnostics-provider :none)
;;   (setq lsp-file-watch-threshold 1000)
;;   (setq gc-cons-threshold 10000000)
;;   (setq read-process-output-max (* 1024 1024)) ;; 1mb
;;   (setq company-idle-delay 0.1)
;;   ;; (setq lsp-diagnostics-provider :flycheck)
;;   ;; (setq lsp-ui-sideline-enable nil)
;;   ;; (setq lsp-ui-sideline-show-diagnostics nil)
;;   ;; (setq lsp-ui-doc-enable nil)
;;   (setq company-auto-complete t)
;;   ;; (setq lsp-print-performance t)
;;   :hook ((python-mode . lsp-deferred))
;;   :custom
;;   
;;   ;; (lsp-ui-doc-show-with-cursor nil)
;;   ;; (lsp-ui-doc-show-with-mouse nil)
;;   ;; (lsp-enable-on-type-formatting nil)
;;   )

;; (use-package lsp-ui
;;   :commands lsp-ui-mode)
  ;; (use-package flymake :ensure t)

;; (use-package ccls
;;   :hook ((c-mode c++-mode objc-mode cuda-mode) .
;;          (lambda () (require 'ccls) (lsp)))
;;   :custom
;;   (ccls-executable "/usr/bin/ccls"))

;; (use-package yas
;;   :defer t
;;   :hook (lsp-mode . yas-minor-mode))

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
