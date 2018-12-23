
(setq user-mail-address "christopher.lackner@gmx.at"
      user-full-name "Christopher Lackner")

;;
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

(require 'mu4e)
(setq mail-user-agent 'mu4e-user-agent)

(setq mu4e-user-mail-address-list '("christopher.lackner@gmx.at" "christopher.lackner@tuwien.ac.at"))

(setq mu4e-get-mail-command "offlineimap")

(setq mu4e-contexts
      `(,(make-mu4e-context
          :name "gmx"
          :match-func (lambda (msg)
                        (when msg
                          (mu4e-message-contact-field-matches msg
                                                              :to "christopher.lackner@gmx.at")))
          :vars '((user-mail-address ."christopher.lackner@gmx.at")
                  (user-full-name ."Christopher Lackner")
                  (mu4e-maildir ."~/mail/gmx")
                  (mu4e-sent-folder ."/Sent")
                  (mu4e-drafts-folder ."/Drafts")
                  (mu4e-trash-folder ."/Trash")
                  (mu4e-refile-folder ."/Archives")
                  )),
        (make-mu4e-context
         :name "tu"
         :match-func (lambda (msg)
                       (when msg
                         (mu4e-message-contact-field-matches msg
                                                             :to "christopher.lackner@tuwien.ac.at")))
         :vars '((user-mail-address ."christopher.lackner@tuwien.ac.at")
                 (user-full-name ."Christopher Lackner")
                 (mu4e-maildir ."~/mail/tu")
                 (mu4e-sent-folder ."/Sent")
                 (mu4e-drafts-folder ."/Drafts")
                 (mu4e-trash-folder ."/Trash")
                 (mu4e-refile-folder ."/Archives")
                 ))
        ))

(setq message-kill-buffer-on-exit t)

(defvar my-mu4e-account-alist
  '(("gmx"
     (smtpmail-smtp-user "christopher.lackner@gmx.at")
     (smtpmail-smtp-server "mail.gmx.net")
     (smtpmail-smtp-service 587)
     ),
    ("tu"
     (smtpmail-smtp-user "clackner")
     (smtpmail-smtp-mail-address "christopher.lackner@tuwien.ac.at")
     (smtpmail-smtp-server "mail.intern.tuwien.ac.at"))
    ))

(defun my-mu4e-set-account ()
  "Set the account for composing a message.
   This function is taken from:
     https://www.djcbsoftware.nl/code/mu/mu4e/Multiple-accounts.html"
  (let* ((account
    (if mu4e-compose-parent-message
        (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
    (string-match "/\\(.*?\\)/" maildir)
    (match-string 1 maildir))
      (completing-read (format "Compose with account: (%s) "
             (mapconcat #'(lambda (var) (car var))
            my-mu4e-account-alist "/"))
           (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
           nil t nil nil (caar my-mu4e-account-alist))))
   (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
  (mapc #'(lambda (var)
      (set (car var) (cadr var)))
        account-vars)
      (error "No email account found"))))
(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

(require 'mu4e-alert)

(mu4e-alert-enable-mode-line-display)

(defun gjstein-refresh-mu4e-alert-mode-line ()
  (interactive)
  (mu4e~proc-kill)
  (mu4e-alert-enable-mode-line-display)
  )
(run-with-timer 0 60 'gjstein-refresh-mu4e-alert-mode-line)

(setq mu4e-context-policy 'pick-first)
(setq mu4e-confirm-quit nil)

(global-set-key (kbd "C-c C-e") 'mu4e)

(provide 'email-settings)
