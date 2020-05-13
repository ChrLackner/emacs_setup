
(use-package org
  :ensure t)
(global-set-key (kbd "C-c l") 'org-store-link)
(setq org-startup-with-inline-images t)
(setq org-support-shift-select t)

(setq org-image-actual-width nil)

(fset 'org_insert_python_block
   [?# ?+ ?B ?E ?G ?I ?N ?_ ?S ?R ?C ?  ?p ?y ?t ?h ?o ?n return return ?# ?+ ?E ?N ?D ?_ ?S ?R ?C ?\C-p])

(fset 'org_insert_align_star_block
   [?\\ ?b ?e ?g ?i ?n ?\{ ?a ?l ?i ?g ?n ?* ?\} return return ?\\ ?e ?n ?d ?\{ ?a ?l ?i ?g ?n ?* ?\} up])

(fset 'org_insert_align_block
   [?\\ ?b ?e ?g ?i ?n ?\{ ?a ?l ?i ?g ?n ?\} return return ?\\ ?e ?n ?d ?\{ ?a ?l ?i ?g ?n ?\} up])

(define-key org-mode-map (kbd "M-i p") 'org_insert_python_block)
(define-key org-mode-map (kbd "M-i a") 'org_insert_align_block)
(define-key org-mode-map (kbd "M-i * a") 'org_insert_align_star_block)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))
(setq org-babel-python-command "python3")

;; Scale latex images
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.7))
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

(advice-add 'org-create-formula-image :around #'org-renumber-environment)


;; trello ====================

(use-package org-trello
  :ensure t)

(custom-set-variables '(org-trello-files '("~/org/trello/ngs.org" "")))

(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (setq filename
        (concat
         (make-temp-name
          (concat (buffer-file-name)
                  "_"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (call-process "import" nil nil nil filename)
  (insert (concat "[[" filename "]]"))
  (org-display-inline-images))

(provide 'org-mode-settings)
