

(setq python-shell-prompt-regexp "python\\|chatbot3?\\>")

(defun start-chatbot (arguments)
  "Starts a chatbot session with the given arguments."
  ;; (message (concat "Run python as: " (format "chatbot %s" arguments)))
  (run-python
    (format "chatbot %s" arguments) t t))

(defun replace-tics-in-string (string)
  "Replaces tics in a string with double tics."
  (replace-regexp-in-string "\"" "\\\\\"" string))

(defun get-formatted-buffer-region ()
  "Returns the current buffer region formatted as a string."
  (let ((start (region-beginning))
        (end (region-end)))
    (replace-tics-in-string (buffer-substring-no-properties start end))))

(defun chatbot-create-docstring ()
  "Starts a chatbot session with the current buffer as the context to create a docstring from"
  (interactive)
  (let ((docstring (get-formatted-buffer-region)))
    (start-chatbot (concat "--model gpt-3.5-turbo --message \"Create documentation for :\n```\n" docstring "\n```\n\""))))

(defun start-assistant-on-region (message)
  "Starts a chatbot session with the current region as the context and ask what to do with it"
  (interactive "sEnter your message: ")
  (let ((reg (get-formatted-buffer-region)))
    (start-chatbot (concat "--mode assistant --message \""
                           (concat (replace-tics-in-string message) "\n" reg) "\""))))

(defun ask-assistant-on-region (message)
  "Starts a chatbot session with the current region as the context and ask what to do with it"
  (interactive "sEnter your message: ")
  (let ((reg (get-formatted-buffer-region)))
    (start-chatbot (concat "--mode assistant --message \""
                           (concat (replace-tics-in-string message) "\n" reg) "\""))))

(defun ask-assistant (message)
  "Starts a chatbot session with the current region as the context and ask what to do with it"
  (interactive "sEnter your message: ")
  (start-chatbot (concat "--mode assistant --message \""
                           (concat (replace-tics-in-string message)) "\"")))

(defun ask-coder (message)
  "Starts a coder bot session and ask what to do with it"
  (interactive "sEnter your message: ")
  (start-chatbot (concat "--model gpt-3.5-turbo --message \""
                           (concat (replace-tics-in-string message)) "\"")))

(defun ask-coder-on-region (message)
  "Starts a coder bot session and ask what to do with it with the current region as the context"
  (interactive "sEnter your message: ")
  (let ((reg (get-formatted-buffer-region)))
    (start-chatbot (concat "--model gpt-3.5-turbo  --message \""
                           (concat (replace-tics-in-string message) "\n" reg) "\""))))

(defun ask-coder-4 (message)
  "Starts a coder bot session and ask what to do with it"
  (interactive "sEnter your message: ")
  (start-chatbot (concat "--message \""
                           (concat (replace-tics-in-string message)) "\"")))

(defun ask-coder-4-on-region (message)
  "Starts a coder bot session and ask what to do with it with the current region as the context"
  (interactive "sEnter your message: ")
  (let ((reg (get-formatted-buffer-region)))
    (start-chatbot (concat "--message \""
                           (concat (replace-tics-in-string message) "\n" reg) "\""))))

(global-set-key (kbd "C-c C-o a") 'ask-coder)
(global-set-key (kbd "C-c C-o r") 'ask-coder-on-region)


(defun ask-simpl-chatbot (message)
  "Starts a simpl chatbot session with as message"
  (interactive "sEnter your message: ")
  (start-chatbot (concat "--mode assistant --memory --memory_file simpl --message \""
                           (concat (replace-tics-in-string message)) "\"")))

(defun ask-simpl-chatbot-region (message)
  "Starts a simpl chatbot session with as message"
  (interactive "sEnter your message: ")
  (let ((reg (get-formatted-buffer-region)))
    (start-chatbot (concat "--mode assistant --memory --memory_file simpl --message \""
                           (concat (replace-tics-in-string message) "\n" reg) "\""))))

(defun train-simpl-chatbot (message)
  "Starts a simpl chatbot session with as message"
  (interactive "sEnter your message: ")
  (start-chatbot (concat "--mode assistant --memory --train --memory_file simpl --message \""
                           (concat (replace-tics-in-string message)) "\"")))

(defun train-simpl-chatbot-region (message)
  "Starts a simpl chatbot session with as message"
  (interactive "sEnter your message: ")
  (let ((reg (get-formatted-buffer-region)))
    (start-chatbot (concat "--mode assistant --memory --train --memory_file simpl --message \""
                           (concat (replace-tics-in-string message) "\n" reg) "\""))))


(provide 'gpt-settings)
