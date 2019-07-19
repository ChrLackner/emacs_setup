
(use-package org
  :ensure t)
(global-set-key (kbd "C-c l") 'org-store-link)
(setq org-startup-with-inline-images t)
(setq org-support-shift-select t)

(fset 'org_insert_python_block
   [?# ?+ ?B ?E ?G ?I ?N ?_ ?S ?R ?C ?  ?p ?y ?t ?h ?o ?n return return ?# ?+ ?E ?N ?D ?_ ?S ?R ?C ?\C-p])

(fset 'org_insert_align_block
   [?\\ ?b ?e ?g ?i ?n ?\{ ?a ?l ?i ?g ?n ?* ?\} return return ?\\ ?e ?n ?d ?\{ ?a ?l ?i ?g ?n ?* ?\} up])

(define-key org-mode-map (kbd "M-i p") 'org_insert_python_block)
(define-key org-mode-map (kbd "M-i a") 'org_insert_align_block)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))
(setq org-babel-python-command "python3")

(provide 'org-mode-settings)
