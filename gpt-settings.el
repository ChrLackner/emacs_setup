
(use-package gptai
  :ensure t)
(setq gptai-model "gpt-4")
(setq gptai-username "Christopher Lackner")
(getenv "OPENAI_API_KEY")
(if (eq system-type 'windows-nt)
    (setq gptai-api-key (getenv "OPENAI_API_KEY"))
  (setq gptai-api-key (shell-command-to-string "/bin/bash -i -c 'echo -n $OPENAI_API_KEY'")))

(defun gpt4-request (gptai-prompt)
  "Sends a request to OpenAI API's gpt-4 endpoint and return the response.
Argument GPTAI-PROMPT is the prompt to send to the API."
  (when (null gptai-api-key)
    (error "OpenAI API key is not set"))

  (let* ((url-request-method "POST")
         (url-request-extra-headers
          `(("Content-Type" . "application/json")
            ("Authorization" . ,(format "Bearer %s" gptai-api-key))))
         (url-request-data
          (json-encode `(("model" . "gpt-4")
                         ("messages" . [((role . "user") (content . ,gptai-prompt))])
                         ("temperature" . 0.7))))
         (url "https://api.openai.com/v1/chat/completions")
         (buffer (url-retrieve-synchronously url nil 'silent))
         response)

    (message "Sending request to OpenAI API using model 'gpt-4'")

    (if buffer
      (with-current-buffer buffer
        (goto-char url-http-end-of-headers)
        (condition-case gptai-err
            (progn
              (setq response (json-read))
              (if (assoc 'error response)
                  (error (cdr (assoc 'message (cdr (assoc 'error response)))))
                (let ((first-choice (elt (cdr (assoc 'choices response)) 0))) ; Extract the first choice
                  (cdr (assoc 'content (cdr (assoc 'message first-choice))))))) ; Get the 'content' field of the first choice
          (error (error "Error while parsing OpenAI API response: %s"
                        (error-message-string gptai-err)))))
      (error "Failed to send request to OpenAI API"))))

(defun gpt4-query (gptai-prompt)
  "Sends a request to gpt-4 and insert response at the current point.
Argument GPTAI-PROMPT prompt to be sent."
  (interactive (list (read-string "Enter your prompt: ")))
  (let ((response (gpt4-request gptai-prompt)))
    (insert response)))

(global-set-key (kbd "C-c o") 'gtp4-query)


(provide 'gpt-settings)
