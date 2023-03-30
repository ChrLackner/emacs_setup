
(use-package gpt-turbo
  :ensure t)
(setq gptai-model "gpt-4")
(setq gptai-username "Christopher Lackner")
(setq gptai-api-key (shell-command-to-string "/bin/bash -i -c 'echo -n $OPENAI_API_KEY'"))

(global-set-key (kbd "C-c o") 'gtpai-turbo-query)

(provide 'gpt-settings)
