;; -*- lexical-binding: t; -*-

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
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
  :ensure t
  :defer t)

; set PATH, because we don't load .bashrc
                                        ; function from https://gist.github.com/jakemcc/3887459
(if (eq system-type 'windows-nt)
    (progn
      (defun set-exec-env-vars()
        (dolist (var (list "PATH" "PYTHONPATH" "MKLROOT" "MKL_THREADING_LAYER" "PYOPENGL_PLATFORM"))
          (setenv var (shell-command-to-string (concat "cmd /c echo %" var "%")))
          ))
      )
  ;; else
  (progn
    (defun set-exec-env-vars()
      (dolist (var (list "PATH" "PYTHONPATH" "LD_LIBRARY_PATH" "MKLROOT" "MKL_THREADING_LAYER" "PYOPENGL_PLATFORM"))
        (setenv var (shell-command-to-string (concat "/bin/bash -i -c 'echo -n $" var "' 2> /dev/null")))
        )
      (setq exec-path (append (parse-colon-path (getenv "PATH")) (list exec-directory))))
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
(global-auto-revert-mode 1)

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

(require 'cl-lib)

(defun cerb--cmake-candidates (&optional root)
  "Return completion candidates for cmake build dirs under ROOT.
Each candidate is (DISPLAY . (DIR . INNERNAME))."
  (let* ((root (expand-file-name (or root "~/git/build")))
         (cmake-files
          (directory-files-recursively
           root
           (rx bos ".cmake_" (+ (not (any "/"))) ".sh" eos)))
         (pairs
          (cl-remove-duplicates
           (cl-loop for f in cmake-files
                    for dir = (file-name-directory f)
                    for inner = (file-name-nondirectory (directory-file-name dir))
                    for expected = (concat ".cmake_" inner ".sh")
                    when (string-equal (file-name-nondirectory f) expected)
                    collect (cons (directory-file-name dir) inner))
           :test (lambda (a b) (and (string= (car a) (car b))
                                    (string= (cdr a) (cdr b)))))))
    ;; DISPLAY = path relative to root
    (mapcar (lambda (p)
              (let* ((dir (car p))
                     (inner (cdr p))
                     (disp (file-relative-name dir root)))
                (cons disp (cons dir inner))))
            (sort pairs (lambda (a b) (string-lessp (car a) (car b)))))))

(defun cerb--read-cmake-target ()
  "Prompt user for a cmake target and return (DIR . INNERNAME)."
  (let* ((cands (cerb--cmake-candidates "~/git/build"))
         (choice (completing-read "Target: " (mapcar #'car cands) nil t)))
    (cdr (assoc choice cands))))

(defun build ()
  (interactive)
  (pcase-let* ((`(,dir . ,inner) (cerb--read-cmake-target)))
    (compile (format "make -j6 -C %s install"
                     (shell-quote-argument dir)))))

(defun reconfigure ()
  (interactive)
  (pcase-let* ((`(,dir . ,inner) (cerb--read-cmake-target))
               (file (format ".cmake_%s.sh" inner)))
    (async-shell-command
     (format "bash -lc 'cd %s && source %s && echo \"sourced %s\"'"
             (shell-quote-argument dir)
             (shell-quote-argument file)
             (shell-quote-argument file)))))

(defun build-configured ()
  "Source the .cmake_<inner>.sh and then run make in the same shell."
  (interactive)
  (pcase-let* ((`(,dir . ,inner) (cerb--read-cmake-target))
               (file (format ".cmake_%s.sh" inner)))
    (compile
     (format "bash -lc 'cd %s && source %s && make -j6 install'"
             (shell-quote-argument dir)
             (shell-quote-argument file)))))

;; Press [pause] key in each window you want to "freeze"
(global-set-key [pause] 'toggle-window-dedicated)

;; rgrep search in header files as well
(eval-after-load "grep" '(setf (cdr (assoc "cc" grep-files-aliases)) (cdr (assoc "cchh" grep-files-aliases))))

(put 'narrow-to-region 'disabled nil)

(use-package move-text
  :ensure t
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

(add-hook 'find-file-hook 'remove-dos-eol)


(use-package vertico
  :ensure t
  :init (vertico-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :ensure t
  :init (marginalia-mode 1))

(use-package savehist
  :init (savehist-mode 1))

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
  :ensure t
  :defer t)

(use-package rustic
  :ensure t
  :defer t)

(provide 'general-settings)
