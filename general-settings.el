
(require 'package)

;; https://emacs.stackexchange.com/questions/61997/how-do-i-fix-incomprehensible-buffer-error-when-running-list-packages
(setq package-enable-at-star (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")tup nil)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))

(require 'use-package)
;; (setq use-package-compute-statistics t)

;; (setq visible-bell 1)

;; Avoid performance issues in files with very long lines.
(global-so-long-mode 1)

;; break on word endings
(global-visual-line-mode t)
(define-key visual-line-mode-map [remap kill-line] nil)
(define-key visual-line-mode-map [remap move-beginning-of-line] nil)
(define-key visual-line-mode-map [remap move-end-of-line] nil)

(use-package svg-tag-mode
  :ensure t)

; set PATH, because we don't load .bashrc
                                        ; function from https://gist.github.com/jakemcc/3887459
(if (eq system-type 'windows-nt)
    (progn
      (defun set-exec-env-vars()
        (dolist (var (list "PATH" "PYTHONPATH" "MKLROOT" "MKL_THREADING_LAYER" "PYOPENGL_PLATFORM"))
          (setenv var (shell-command-to-string (concat "cmd /c echo %" var "%")))
          ))
      (setq python-shell-interpreter "C:/Users/chris/source/repos/cenos/backend/bin/python.exe")
      )
  ;; else
  (progn
    (defun set-exec-env-vars()
      (dolist (var (list "PATH" "PYTHONPATH" "LD_LIBRARY_PATH" "MKLROOT" "MKL_THREADING_LAYER" "PYOPENGL_PLATFORM"))
        (setenv var (shell-command-to-string (concat "/bin/bash -i -c 'echo -n $" var "' 2> /dev/null")))
        ))
    (shell-command-to-string (concat "/bin/bash -i -c 'echo -n $" "PYTHONPATH" "' 2> /dev/null"))
    )
  )

(if window-system (set-exec-env-vars))

; language
(setq current-language-environment "English")

; don't indent with tabs
(setq-default indent-tabs-mode nil)

; ignore case when searching
(setq-default case-fold-search 1)


; auto revert buffers
(auto-revert-mode)

; don't show windows eol as ^M
(setq inhibit-windows-eol t)

; disable backup
(setq backup-inhibited t)

; disable lock files
(setq create-lockfiles nil)

; disable auto save
(setq auto-save-default nil)

; highlight parentheses when the cursor is next to them
(use-package paren
  :ensure t)
(show-paren-mode 1)

;; override the exit key and the minimize key (emacs freezes afterwards)
(global-unset-key (kbd "C-x C-c"))
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

;; I use this to switch between us-de keyboard layouts
(global-unset-key (kbd "M-SPC"))

(defun build (prog)
  (interactive
   (list (completing-read "Source: " (directory-files "~/git/source"))))
  (if (string= prog "netgen") (compile (format "make -j6 -C ~/git/build/ngsolve/netgen install"))
    (if (and (file-exists-p (format "~/git/source/%s/setup.py" prog)) (not (string= prog "ngsolve")))
        (async-shell-command (format "python -m pip install --no-deps --user ~/git/source/%s" prog))
      (compile (format "make -j6 -C ~/git/build/%s install" prog)))))

(defun reconfigure (prog)
  (interactive
   (list (completing-read "Source: " (directory-files "~/git/build"))))
  (async-shell-command (format "reconfigure %s" prog)))

;; Toggle window dedication
(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window
                                 (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer)))

;; Press [pause] key in each window you want to "freeze"
(global-set-key [pause] 'toggle-window-dedicated)

;; rgrep search in header files as well
(eval-after-load "grep" '(setf (cdr (assoc "cc" grep-files-aliases)) (cdr (assoc "cchh" grep-files-aliases))))

(put 'narrow-to-region 'disabled nil)

(use-package move-text
  :bind (("M-p" . move-text-up)
         ("M-n" . move-text-down)))

; window modifications
;; (global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
;; (global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
;; (global-set-key (kbd "S-C-<down>") 'shrink-window)
;; (global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; remove ^M line endings
(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings"
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(add-hook 'find-file-hooks 'remove-dos-eol)


(use-package smex
  :ensure t
  :config (smex-initialize)
  :bind (("M-x" . 'smex)
         ("M-X" . 'smex-major-mode-commands)
         ;; This is your old M-x.
         ("C-c C-c M-x" . 'execute-extended-command)))

;; better shell
(if (eq system-type 'windows-nt)
    (progn
      (use-package powershell
        :ensure t
        )
      (autoload 'powershell "powershell" "Start a powershell process." t)
      )
  ;; else
  (use-package shx
    :ensure t
    :config (shx-global-mode 1)))

(defun my-colorize-compilation-buffer ()
  (when (eq major-mode 'compilation-mode)
    (ansi-color-apply-on-region compilation-filter-start (point-max))))

;; ansi colors in shell
(use-package ansi-color
  :hook ((shell-mode . ansi-color-for-comint-mode-on)
         (compilation-filter . my-colorize-compilation-buffer)))
  
;; improve long line
;; (set bidi-inhibit-bpa t)

;; better pdf tools
(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))

;; set encoding to utf8
(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
(setenv "LC_CTYPE" "en_US.UTF-8")

(use-package yaml-mode
  :ensure t
  :mode "\\.yml\\'"
  :bind (:map yaml-mode-map
              (("\C-m" . 'newline-and-indent))))

;; split window vertically at start
(split-window-right)

(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
     "jq " (current-buffer) t)))

(if (eq system-type 'windows-nt)
    (progn
      (setenv "PATH"
               (concat
                (getenv "PATH") path-separator
                "C:/Users/chris/source/repos/cenos/backend/bin" path-separator))
      (setq exec-path (append exec-path
                              '("C:/MinGW/msys/1.0/bin/"
                                "C:/MinGW/bin/"
                                "c:/MinGW/mingw32/bin"
                                "C:/Users/chris/source/repos/cenos/backend/bin")))
      (setq find-program "\"C:/MinGW/msys/1.0/bin/find.exe\"")
      (setq grep-program "\"C:/MinGW/msys/1.0/bin/grep.exe\"")
))

(use-package journalctl-mode
  :ensure t)


(provide 'general-settings)
