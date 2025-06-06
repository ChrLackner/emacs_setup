

;; something in org-latex-preview still needs this deprectated package...
(require 'cl)

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
  (add-to-list 'org-latex-classes
               '("scrarticle" "\\documentclass{scrarticle}"
                 ("\\section{%s}" . "\\section{%s}")
                 ("\\subsection{%s}" . "\\subsection{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection{%s}")
                 ("\\paragraph{%s}" . "\\paragraph{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph{%s}")
                 ))
  (add-to-list 'org-latex-classes
  ;; beamer class, for presentations
  '("beamer"
     "\\documentclass[11pt]{beamer}\n
      \\mode<{{{beamermode}}}>\n
      \\usetheme{{{{beamertheme}}}}\n
      \\usecolortheme{{{{beamercolortheme}}}}\n
      \\beamertemplateballitem\n
      \\setbeameroption{show notes}
      \\usepackage[utf8]{inputenc}\n
      \\usepackage[T1]{fontenc}\n
      \\usepackage{hyperref}\n
      \\usepackage{color}
      \\usepackage{listings}
      \\lstset{numbers=none,language=[ISO]C++,tabsize=4,
  frame=single,
  basicstyle=\\small,
  showspaces=false,showstringspaces=false,
  showtabs=false,
  keywordstyle=\\color{blue}\\bfseries,
  commentstyle=\\color{red},
  }\n
      \\usepackage{verbatim}\n
      \\institute{{{{beamerinstitute}}}}\n
       \\subject{{{{beamersubject}}}}\n"

     ("\\section{%s}" . "\\section*{%s}")

     ("\\begin{frame}[fragile]\\frametitle{%s}"
       "\\end{frame}"
       "\\begin{frame}[fragile]\\frametitle{%s}"
       "\\end{frame}")))
  )




(use-package org-ref
  :ensure t
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

    (setq results (loop for (begin .  env) in 
                        (org-element-map (org-element-parse-buffer) 'latex-environment
                          (lambda (env)
                            (cons
                             (org-element-property :begin env)
                             (org-element-property :value env))))
                        collect
                        (cond
                         ((and (string-match "\\\\begin{equation}" env)
                               (not (string-match "\\\\tag{" env)))
                          (incf counter)
                          (cons begin counter))
                         ((string-match "\\\\begin{align}" env)
                          (prog2
                              (incf counter)
                              (cons begin counter)                          
                            (with-temp-buffer
                              (insert env)
                              (goto-char (point-min))
                              ;; \\ is used for a new line. Each one leads to a number
                              (incf counter (count-matches "\\\\$"))
                              ;; unless there are nonumbers.
                              (goto-char (point-min))
                              (decf counter (count-matches "\\nonumber")))))
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

(provide 'org-mode-settings)
