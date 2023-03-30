
;; remove autointend from rst mode
(defun my-rst-mode-hook ()
  "My personal rst mode hook."
  (local-set-key (kbd "RET") '(lambda () (interactive) (newline 1))))

(add-hook 'rst-mode-hook 'my-rst-mode-hook)

(use-package markdown-mode
  :ensure t
  :bind(:map markdown-mode-map (("M-i a" . 'org-insert-align-block)
                                ("M-i * a" . 'org-insert-align-star-block)))

  )

(use-package texfrag)
(add-hook 'markdown-mode-hook #'texfrag-mode)
(setq texfrag-scale 1)

(defcustom custom-texfrag-header
  "
\\usepackage{amsmath,amsfonts}
\\usepackage[utf8]{inputenc}
\\newcommand{\\R}{\\mathbb{R}}
\\newcommand{\\N}{\\mathbb{N}}
\\renewcommand{\\C}{\\mathbb{C}}
\\newcommand{\\norm}[1]{\\left\\lVert #1 \\right\\lVert}
\\newcommand{\\scalp}[1]{\\left\\langle #1 \\right\\rangle}
\\renewcommand{\\div}[1]{\\text{div}\\left( #1 \\right)}
\\newcommand{\\curl}[1]{\\text{curl}\\left( #1 \\right)}
\\newcommand{\\Hcurl}{H^\\text{curl}}
\\newcommand{\\Hdiv}{H^\\text{div}}
\\newcommand{\\f}[1] {\\mathbf{#1}}
\\newcommand{\\dt}[1]{\\frac{\\partial #1}{\\partial t}}
\\newcommand{\\dn}[1]{\\frac{\\partial #1}{\\partial n}}
\\newcommand{\\dtau}[1]{\\frac{\\partial #1}{\\partial \\tau}}
\\newcommand{\\dx}{\\hspace{0.5mm} dx}
\\newcommand{\\ds}{\\hspace{0.5mm} ds}
\\newcommand{\\mat}[1]{\\left(\\begin{matrix} #1 \\end{matrix} \\right)}
"
  "LaTeX header inserted by the function `texfrag-header-function' into the LaTeX buffer."
  :group 'texfrag
  :type 'string)
(provide 'rst-settings)
