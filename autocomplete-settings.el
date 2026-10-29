;; -*- lexical-binding: t; -*-

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
        ("M-<tab>" . copilot-next-completion))
  :config
   (setq copilot-max-char most-positive-fixnum)
  )

;; log copilot warnings without popping up *Warnings*
(add-to-list 'warning-suppress-types '(copilot))
;; COPILOT END

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(add-hook 'gud-mode-hook (lambda () (company-mode -1)))
(use-package company :ensure t)
(add-hook 'after-init-hook 'global-company-mode)

;; LSP
;; get environment variable PATH
(if (eq system-type 'windows-nt)
    (setenv "PATH" (concat (getenv "PATH") (file-name-directory (executable-find "node")) ";")))

(use-package lsp-mode
  :ensure t
  :bind (:map evil-normal-state-map (("M-." . 'xref-find-definitions)))
  :hook ((python-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (c++-mode . lsp-deferred))
  :config
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  (setq flycheck-display-errors-function 'ignore)
  ;; breadcrumb in the nano header line, see nano-modeline-compose
  (require 'lsp-breadcrumb-settings)
  :custom
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-lens-enable nil)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-doc-enable nil)
  (lsp-modeline-code-actions nil)
  (lsp-enable-on-type-formatting nil)
  (lsp-clients-clangd-args '("-j=4"
                             "--background-index"
                             "--limit-references=0"
                             "--clang-tidy"
                             "-log=error")))

(use-package lsp-pyright
  :ensure t
  :after lsp-mode
  :custom
  (lsp-pyright-python-executable-cmd "/usr/bin/python"))
;; LSP END

(with-eval-after-load 'flymake
  (defun my/disable-flymake-cc ()
    "Disable Flymake's builtin C/C++ backend (gcc-flymake) when using LSP/clangd."
    (remove-hook 'flymake-diagnostic-functions 'flymake-cc t))

  (add-hook 'c-mode-hook  #'my/disable-flymake-cc)
  (add-hook 'c++-mode-hook #'my/disable-flymake-cc))
(add-hook 'python-mode-hook
          (lambda ()
            ;; Keep LSP/Flymake diagnostics, but drop python-flymake.
            (remove-hook 'flymake-diagnostic-functions #'python-flymake t)))

;; Prune non-existent workspace folders to avoid lsp-mode polling them repeatedly.
(with-eval-after-load 'lsp-mode
  (defun clackner/lsp--prune-missing-workspace-folder (orig-fn dir &rest args)
    (if (file-directory-p dir)
        (apply orig-fn dir args)
      ;; Forget it so it doesn't keep coming back:
      (ignore-errors (lsp-workspace-folders-remove dir))
      (lsp--info "Removed non-existent workspace folder: %s" dir)
      nil))
  (advice-add 'lsp-watch-root-folder :around #'clackner/lsp--prune-missing-workspace-folder)

  ;; No popups while typing: import the vcs root of new projects silently,
  ;; skip files outside of projects. Explicit M-x lsp still asks.
  (defun clackner/lsp--auto-root (orig-fn session)
    (if (eq this-command 'lsp)
        (funcall orig-fn session)
      (let ((root (when-let* ((project (project-current)))
                    (expand-file-name (project-root project)))))
        (if (and root (not (file-equal-p root "~/")))
            (progn (lsp--info "Imported project root %s" root)
                   root)
          (lsp--info "%s is not in a project, M-x lsp to import it" (buffer-name))
          nil))))
  (advice-add 'lsp--find-root-interactively :around #'clackner/lsp--auto-root)

  ;; Big projects: don't watch instead of asking
  (advice-add 'lsp--ask-about-watching-big-repo :override
              (lambda (count dir)
                (lsp--info "Not watching %s (%s directories)" dir count)
                nil)))

(use-package yasnippet
  :ensure t)
(yas-global-mode 1)

(provide 'autocomplete-settings)
