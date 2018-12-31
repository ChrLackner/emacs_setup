
(require 'cc-mode)

(require 'dired)
(define-key dired-mode-map (kbd "C-c c") (lambda () (interactive) (compile "make -j")))
(define-key dired-mode-map (kbd "C-c i") (lambda () (interactive) (compile "make -j install")))

(require 'compile)
(define-key compilation-mode-map (kbd "C-c c") (lambda () (interactive) (compile "make -j")))
(define-key compilation-mode-map (kbd "C-c i") (lambda () (interactive) (compile "make -j install")))


(fset 'add_block_brackets
   [return ?\{ return return ?\} up tab])

(define-key c-mode-base-map (kbd "C-{") 'add_block_brackets)

(defun build (prog)
  (interactive
   (list (completing-read "Source: " (directory-files "~/gitlab/source"))))
  (if (file-exists-p (format "~/gitlab/source/%s/setup.py" prog))
      (async-shell-command (format "python3 -m pip install --user ~/gitlab/source/%s" prog))
    (compile (format "make -j -C ~/gitlab/build/%s install" prog))))

(provide 'cpp-settings)
