
;; (defun turn-on-outline-minor-mode ()
;;   (outline-minor-mode 1))

;; (add-hook 'LaTeX-mode-hook 'turn-on-outline-minor-mode)
;; (add-hook 'latex-mode-hook 'turn-on-outline-minor-mode)
;; (setq outline-minor-mode-prefix "\C-c \C-u")


;; set latex size in org mode
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))


(provide 'latex-settings)
