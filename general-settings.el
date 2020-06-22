
(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(require 'use-package)

;; Avoid performance issues in files with very long lines.
(global-so-long-mode 1)

; set PATH, because we don't load .bashrc
; function from https://gist.github.com/jakemcc/3887459
(defun set-exec-env-vars()
  (dolist (var (list "PATH" "PYTHONPATH" "LD_LIBRARY_PATH" "MKLROOT" "MKL_THREADING_LAYER" "PYOPENGL_PLATFORM"))
    (setenv var (shell-command-to-string (concat "/bin/bash -i -c 'echo -n $" var "' 2> /dev/null")))
      ))

(if window-system (set-exec-env-vars))
(shell-command-to-string (concat "/bin/bash -i -c 'echo -n $" "PYTHONPATH" "' 2> /dev/null"))
; language
(setq current-language-environment "English")
; don't show the startup screen
(setq inhibit-startup-screen t)

; don't show the menu bar
(menu-bar-mode 0)
; don't show the tool bar
(require 'tool-bar)
(tool-bar-mode 0)

; don't indent with tabs
(setq-default indent-tabs-mode nil)

; ignore case when searching
(setq-default case-fold-search 1)

; don't blink the cursor
(blink-cursor-mode 0)

; auto revert buffers
(auto-revert-mode)

; disable backup
(setq backup-inhibited t)
; disable auto save
(setq auto-save-default nil)

; highlight parentheses when the cursor is next to them
(use-package paren
  :ensure t)
(show-paren-mode 1)

;; override the exit key and the minimize key (emacs freezes afterwards)
(global-unset-key (kbd "C-x C-c"))
(global-unset-key (kbd "C-z"))

(defun build (prog)
  (interactive
   (list (completing-read "Source: " (directory-files "~/git/source"))))
  (if (string= prog "netgen") (compile (format "make -j -C ~/git/build/ngsolve/netgen install"))
    (if (file-exists-p (format "~/git/source/%s/setup.py" prog))
        (async-shell-command (format "python3 -m pip install --no-deps --user ~/git/source/%s" prog))
      (compile (format "make -j -C ~/git/build/%s install" prog)))))

(defun reconfigure (prog)
  (interactive
   (list (completing-read "Source: " (directory-files "~/git/build"))))
  (async-shell-command (format "reconfigure %s" prog)))

;; window deciation
;; press [pause]
(defadvice pop-to-buffer (before cancel-other-window first)
  (ad-set-arg 1 nil))

;;(ad-activate 'pop-to-buffer)

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
  :ensure t)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

;; (require 'symon)
;; (symon-mode)

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

;; set highlight color
(set-face-attribute 'region nil :background "#666" :foreground "#ffffff")

(use-package color-theme-sanityinc-tomorrow
  :ensure t)

;; M-x color-theme-sanityinc-tomorrow-day
;; M-x color-theme-sanityinc-tomorrow-night
;; M-x color-theme-sanityinc-tomorrow-blue
;; M-x color-theme-sanityinc-tomorrow-bright
;; M-x color-theme-sanityinc-tomorrow-eightiesf

(set-face-attribute 'default nil
                    :family "Source Code Pro"
                    :height 140
                    :weight 'normal
                    :width 'normal)

(use-package smex
  :ensure t)
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; better shell
(use-package shx
  :ensure t)


;; ansi colors in shell
(require 'ansi-color)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; improve long line
;; (set bidi-inhibit-bpa t)

(defun open-ngsolve-file (filename)
  "Open file in NGSolve repo"
  (interactive (list (completing-read "File name: " (mapcar 'file-name-nondirectory (directory-files-recursively "~/git/source/ngsolve" ".*\.hpp")))))
  (find-file (car (cl-remove-if (lambda (k) (string-match-p ".*\.#.*" k)) (directory-files-recursively "~/git/source/ngsolve" (concat ".*" filename))))))

(global-set-key (kbd "C-x C-l") 'open-ngsolve-file)

;; better pdf tools
(require 'pdf-tools)
(pdf-loader-install)


;; set encoding to utf8
(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
(setenv "LC_CTYPE" "en_US.UTF-8")

(provide 'general-settings)
