
(require 'python)


(provide 'python-settings)

(setq python-shell-interpreter "ipython")
      ;; python-shell-interpreter-args "--gui=wx --matplotlib=wx --colors=Linux"
      ;; python-shell-prompt-regexp "In \\[[0-9]+\\]: "
      ;; python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
      ;; python-shell-completion-setup-code "from IPython.core.completerlib import module_completion"
      ;; python-shell-completion-module-string-code "';'.join(module_completion('''%s'''))\n"
      ;; python-shell-completion-string-code "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

(setq ein:use-auto-complete 1)

(require 'ein)

; shortcut function to load notebooklist
(defun load-ein ()
  (ein:notebooklist-load)
  (interactive)
(ein:notebooklist-open))

(require 'pydoc-info)

;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "pycheckers" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pyflakes-init)))
;; (add-hook 'python-mode-hook
;; 	  (lambda ()
;; 	    (unless (eq buffer-file-name nil) (flymake-mode 1))))

; Set PYTHONPATH, because we don't load .bashrc
(defun set-python-path-from-shell-PYTHONPATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PYTHONPATH'")))
    (setenv "PYTHONPATH" path-from-shell)))

(if window-system (set-python-path-from-shell-PYTHONPATH))

(setq auto-mode-alist
      (append
       (list '("\\.pyx" . python-mode)
             '("SConstruct" . python-mode))
auto-mode-alist))

; keybindings
(eval-after-load 'python
  '(define-key python-mode-map (kbd "C-c !") 'python-shell-switch-to-shell))
(eval-after-load 'python
  '(define-key python-mode-map (kbd "C-c |") 'python-shell-send-region))

;;emacs pytest
(require 'python-pytest)
(define-key dired-mode-map (kbd "C-c t") 'python-pytest-popup)
(define-key python-mode-map (kbd "C-c t") 'python-pytest-popup)

(defun python-pytest--project-root ()
  "Find the project root directory."
  (concat (projectile-project-root) "test/")
  )
  

(provide 'python-settings)
