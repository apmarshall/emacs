;;; package --- Summary

;;; Commentary:

;;; Code:

(add-to-list 'load-path "~/.dotfiles/emacs")
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp")

(setq user-full-name "Alexander P. Floyd Marshall"
      user-mail-address "apmarshall@soren.tech")
      
(load "~/.dotfiles/emacs/emacs.secrets" t)
(load "~/.dotfiles/emacs/general/custom-settings.el" t)
(load "~/.dotfiles/emacs/packages/my-packages.el" t)

(server-start)
