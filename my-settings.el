;; -*- lexical-binding: t; -*-

(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
(setq package-native-compile t)

(require 'theme-settings)

(require 'general-settings)

(require 'evil-settings)

(require 'org-mode-settings)

(require 'magit-settings)

(require 'autocomplete-settings)

(require 'cpp-settings)

(require 'ngsolve-settings)

(require 'rst-settings)

(require 'gdb-settings)

(require 'js-settings)


(require 'wgsl-mode)

(provide 'my-settings)
