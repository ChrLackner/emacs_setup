
;; COPILOT
(use-package copilot
  :ensure t
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
            :rev :newest
            :branch "main")
  :hook ((prog-mode . copilot-mode)
         (html-mode . copilot-mode)
         (markdown-mode . copilot-mode)
         (org-mode . copilot-mode))
  :bind
  (:map copilot-completion-map
        ("M-<return>" . copilot-accept-completion)
        ("C-M-<return>" . copilot-accept-completion-by-word)
        ("M-<tab>" . copilot-next-completion)))


(add-to-list 'display-buffer-alist
             '("\\*Warnings\\*"
               (display-buffer-no-window)))
;; COPILOT END

(use-package editorconfig
  :ensure t)

(add-hook 'gud-mode-hook (lambda () (company-mode -1)))
(use-package company :ensure t)
(add-hook 'after-init-hook 'global-company-mode)

;; LSP
;; get environment variable PATH
(if (eq system-type 'windows-nt)
    (setenv "PATH" (concat (getenv "PATH") (file-name-directory (executable-find "node")) ";")))

(use-package lsp-pyright
    :ensure t
    :bind (:map evil-normal-state-map (("M-." . 'xref-find-definitions)))
    :hook ((python-mode . lsp-deferred)
           (c-mode . lsp-deferred)
           (c++-mode . lsp-deferred)
           (lsp-mode . (lambda() (require 'lsp-headerline))))
    :config
    (setq gc-cons-threshold 1000000)
    (setq read-process-output-max (* 1024 1024)) ;; 1mb
    (setq flycheck-display-errors-function 'ignore)
    (set-face-attribute 'lsp-headerline-breadcrumb-symbols-face nil :background nano-color-subtle)
    (set-face-attribute 'lsp-headerline-breadcrumb-separator-face nil :background nano-color-subtle)
    (set-face-attribute 'lsp-headerline-breadcrumb-path-face nil :background nano-color-subtle)
    (set-face-attribute 'lsp-headerline-breadcrumb-project-prefix-face nil :background nano-color-subtle)
    (set-face-attribute 'lsp-headerline-breadcrumb-unknown-project-prefix-face nil :background nano-color-subtle)
    :custom
    (lsp-headerline-breadcrumb-enable nil)
    (lsp-lens-enable nil)
    (lsp-ui-sideline-enable nil)
    (lsp-ui-doc-enable nil)
    (lsp-modeline-code-actions nil)
    (lsp-ui-sideline-enable nil)
    (lsp-enable-on-type-formatting nil)
    (lsp-clients-clangd-args '("-j=4"
                                "--background-index"
                                "--limit-references=0"
                                "--clang-tidy"
                                "-log=error"))
    (lsp-pyright-python-executable-cmd "/usr/bin/python")
    )
;; LS END

(require 'lsp-mode)
(require 'lsp-headerline)
(lsp-defun my-lsp-headerline--symbol-icon ((&DocumentSymbol :kind))
  "Build the SYMBOL icon for headerline breadcrumb."
  (concat (lsp-icons-get-by-symbol-kind kind 'headerline-breadcrumb)
          ""))


(defun my-lsp-headerline--build-symbol-string ()
  "Build the symbol segment for the breadcrumb."
  (if (lsp-feature? "textDocument/documentSymbol")
      (-if-let* ((lsp--document-symbols-request-async t)
                 (symbols (lsp--get-document-symbols))
                 (symbols-hierarchy (lsp--symbols->document-symbols-hierarchy symbols))
                 (enumerated-symbols-hierarchy
                  (-map-indexed (lambda (index elt)
                                  (cons elt (1+ index)))
                                symbols-hierarchy)))
          (mapconcat
           (-lambda (((symbol &as &DocumentSymbol :name)
                      . index))
             (let* ((symbol2-name
                     (propertize name
                                 'font-lock-face
                                 (lsp-headerline--face-for-symbol symbol)))
                    (symbol2-icon (my-lsp-headerline--symbol-icon symbol))
                    (full-symbol-2
                     (concat
                      (if lsp-headerline-breadcrumb-enable-symbol-numbers
                          (concat
                           (propertize (number-to-string index)
                                       'face
                                       'lsp-headerline-breadcrumb-symbols-face)
                           " ")
                        "")
                      (if symbol2-icon
                          (concat symbol2-icon symbol2-name)
                        symbol2-name))))
               (lsp-headerline--symbol-with-action symbol full-symbol-2)))
           enumerated-symbols-hierarchy
           (propertize (concat " " (lsp-headerline--arrow-icon) " ")
                       'face 'lsp-headerline-breadcrumb-separator-face))
        "")
    ""))


;; ------------------ ccls setup --------------------------

;; (use-package projectile
  ;; :ensure t)

;; (global-eldoc-mode -1)

;; (let ((default-directory  "~/.emacs.d/settings/resources"))
;;   (normal-top-level-add-subdirs-to-load-path))

(require 'yasnippet)
(yas-global-mode 1)

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
