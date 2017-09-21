;;; package --- Summary

;;; Commentary:

;;; Code:

(add-to-list 'load-path "~/.dotfiles/emacs")
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp")

(setq user-full-name "Alexander P. Floyd Marshall"
      user-mail-address "apmarshall@soren.tech")
      
(load "~/.emacs.d/emacs.secrets" t)
(load "~/.emacs.d/general/custom-settings.el" t)
(load "~/.emacs.d/packages/my-packages.el" t)

(server-start)
