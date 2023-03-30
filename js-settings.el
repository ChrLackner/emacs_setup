
(use-package js-mode
  :mode "\\.js\\'"
  :config (setq js-indent-level 2)
  )

(use-package lsp-mode
  :custom
    (lsp-vetur-format-default-formatter-css "none")
  (lsp-vetur-format-default-formatter-html "none")
  (lsp-vetur-format-default-formatter-js "none")
  (lsp-vetur-validation-template nil))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :config
  (add-hook 'typescript-mode-hook #'lsp))

(use-package vue-mode
  :mode "\\.vue\\'"
  :config
  (add-hook 'vue-mode-hook #'lsp))

(provide 'js-settings)
