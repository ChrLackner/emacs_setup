;; -*- lexical-binding: t; -*-


(setq calendar-week-start-day 1)

(use-package org
  :bind (("C-c l" . 'org-store-link)
         ("C-c c" . 'org-capture)
         ("C-c a" . 'org-agenda)
         :map org-mode-map
         (("M-i p" . 'org-insert-python-block)
          ("M-i a" . 'org-insert-align-block)
          ("M-i * a" . 'org-insert-align-star-block)))

  :hook (org-mode . visual-line-mode)

  :init
  (fset 'org-insert-python-block
        [?# ?+ ?B ?E ?G ?I ?N ?_ ?S ?R ?C ?  ?p ?y ?t ?h ?o ?n return return ?# ?+ ?E ?N ?D ?_ ?S ?R ?C ?\C-p])
  (fset 'org-insert-align-star-block
        [?\\ ?b ?e ?g ?i ?n ?\{ ?a ?l ?i ?g ?n ?* ?\} return return ?\\ ?e ?n ?d ?\{ ?a ?l ?i ?g ?n ?* ?\} up])
  (fset 'org-insert-align-block
        [?\\ ?b ?e ?g ?i ?n ?\{ ?a ?l ?i ?g ?n ?\} return return ?\\ ?e ?n ?d ?\{ ?a ?l ?i ?g ?n ?\} up])
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)))
  (advice-add 'org-create-formula-image :around #'org-renumber-environment)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2))
  :custom
  (org-startup-with-inline-images t)
  (org-support-shift-select t)
  (org-image-actual-width nil)
  (org-babel-python-command "python3")
  (org-startup-indented t) ; Enable `org-indent-mode' by default
  ;; Scale latex images
  (org-latex-pdf-process (list "latexmk -xelatex -f %f"))
  (org-directory "~/org")
  (org-default-notes-file (concat org-directory "/notes.org"))
  )

(use-package ox-latex
  :defer t
  :config
  (require 'cl-lib)
  (setq org-latex-default-packages-alist
        (cl-remove-if
         (lambda (pkg)
           (let ((name (nth 1 pkg)))
             (and name (string= name "capt-of"))))
         org-latex-default-packages-alist))
  (add-to-list 'org-latex-classes
               '("scrarticle" "\\documentclass{scrarticle}"
                 ("\\section{%s}" . "\\section{%s}")
                 ("\\subsection{%s}" . "\\subsection{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection{%s}")
                 ("\\paragraph{%s}" . "\\paragraph{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph{%s}")
                 ))
  (require 'ox-beamer)
  ;; Clean, modern beamer class for presentations.  Replaces the old custom
  ;; entry that injected {{{beamermode}}} placeholders + inputenc/fontenc, which
  ;; broke xelatex font setup and the CERBSim beamer theme.  [DEFAULT-PACKAGES]
  ;; is xelatex-aware (omits inputenc/fontenc); \section is numbered so the
  ;; CERBSim section dividers (\AtBeginSection) fire.
  (add-to-list 'org-latex-classes
               '("beamer" "\\documentclass[presentation]{beamer}
[DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  )




(use-package org-ref
  :ensure t
  :after org
  :custom
  (org-cite-global-bibliography '("~/stuff/MyLibrary.bib"))
  (bibtex-completion-library-path '("~/cloud/cerbsim_nextcloud/zotero"))
  (bibtex-completion-bibliography '("~/stuff/MyLibrary.bib"))
  )


;; continuous line numbering for align blocks
(defun org-renumber-environment (orig-func &rest args)
  (let ((results '()) 
        (counter -1)
        (numberp))

    (setq results (cl-loop for (begin .  env) in 
                        (org-element-map (org-element-parse-buffer) 'latex-environment
                          (lambda (env)
                            (cons
                             (org-element-property :begin env)
                             (org-element-property :value env))))
                        collect
                        (cond
                         ((and (string-match "\\\\begin{equation}" env)
                               (not (string-match "\\\\tag{" env)))
                          (cl-incf counter)
                          (cons begin counter))
                         ((string-match "\\\\begin{align}" env)
                          (prog2
                              (cl-incf counter)
                              (cons begin counter)                          
                            (with-temp-buffer
                              (insert env)
                              (goto-char (point-min))
                              ;; \\ is used for a new line. Each one leads to a number
                              (cl-incf counter (count-matches "\\\\$"))
                              ;; unless there are nonumbers.
                              (goto-char (point-min))
                              (cl-decf counter (count-matches "\\nonumber")))))
                         (t
                          (cons begin nil)))))

    (when (setq numberp (cdr (assoc (point) results)))
      (setf (car args)
            (concat
             (format "\\setcounter{equation}{%s}\n" numberp)
             (car args)))))
  
  (apply orig-func args))


(defun my-org-screenshot (name)
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive "sFile name: ")
  (make-directory "org_images" :parents)
  (let ((filename (concat
                  (make-temp-name
                   (concat "./org_images/"
                           name)) ".png")))
    (message (concat "stored in " filename))
    (call-process "import" nil nil nil filename)
    (insert "# #+CAPTION: Caption\n")
    (insert "#+ATTR_ORG: :width 400px\n")
    (insert "#+ATTR_LATEX: :width 14cm :placement [H]\n")
    (insert (concat "[[" filename "]]"))
    (org-display-inline-images)))

(defun my-markdown-screenshot (name)
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive "sFile name: ")
  (make-directory "md_images" :parents)
  (let ((filename (concat
                  (make-temp-name
                   (concat "./md_images/"
                           name)) ".png")))
    (message (concat "stored in " filename))
    (call-process "import" nil nil nil filename)
    (insert (concat "![](" filename ")"))
    (markdown-toggle-inline-images)))

;; org jira integration
;; (use-package org-jira
;;   :custom
;;   (jiralib-url "https://cerbsim.atlassian.net")
;;   (org-jira-default-jql "sprint = W36-37 and (status = TODO or status = 'In Progress') ORDER BY status DESC")
;;   ;; (setq request-log-level 'debug)
;;   ;; (setq request-message-level 'debug)
;;   )

(use-package table
  :ensure t)

;; ---------------------------------------------------------------------------
;; Fix: a line that begins with "|" inside \[ ... \] display math (e.g. a |x|
;; norm at column 0) is mis-parsed by org's element parser as a table row.
;; The table splits the paragraph, so the \[ ... \] fragment never finds its
;; closing \], and raw \[ \] leak into the LaTeX (\mathbf not in math mode,
;; spurious tabulars, etc).  Promoting stand-alone \[ ... \] blocks to a
;; \begin{equation*} environment makes org treat them as one verbatim element,
;; immune to the misparse.  Runs in the temporary export buffer only, so source
;; .org files are never touched; #+begin_.../#+end_... blocks are skipped.
(defun org-wrap-display-math-on-export (&optional backend)
  "Rewrite stand-alone \\[ ... \\] display math as an equation* environment.
See comment above for why.  Only acts for LaTeX-derived export backends."
  (when (or (null backend) (org-export-derived-backend-p backend 'latex))
    (goto-char (point-min))
    (let ((case-fold-search t) (in-block nil))
      (while (not (eobp))
        (cond
         ((looking-at "[ \t]*#\\+begin_") (setq in-block t))
         ((looking-at "[ \t]*#\\+end_")   (setq in-block nil))
         ((and (not in-block) (looking-at "[ \t]*\\\\\\[[ \t]*$"))
          (let ((open-bol (line-beginning-position))
                (open-eol (line-end-position))
                (close-bol nil) (close-eol nil) (abort nil))
            (save-excursion
              (forward-line 1)
              (while (and (not close-bol) (not abort) (not (eobp)))
                (cond
                 ((looking-at "[ \t]*#\\+begin_") (setq abort t))
                 ((looking-at "[ \t]*\\\\\\][ \t]*$")
                  (setq close-bol (line-beginning-position)
                        close-eol (line-end-position))))
                (forward-line 1)))
            (when close-bol
              ;; edit the closing line first so the earlier positions stay valid
              (delete-region close-bol close-eol)
              (save-excursion (goto-char close-bol) (insert "\\end{equation*}"))
              (delete-region open-bol open-eol)
              (save-excursion (goto-char open-bol) (insert "\\begin{equation*}"))))))
        (forward-line 1)))))

(add-hook 'org-export-before-parsing-functions #'org-wrap-display-math-on-export)

(provide 'org-mode-settings)
