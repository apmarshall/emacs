;;; package --- Summary

;;; Commentary:

;;; Code:

(package-initialize)

(add-to-list 'load-path "~/.dotfiles/emacs")
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp")
(setq package-enable-at-startup nil)

(setq user-full-name "Alexander P. Floyd Marshall"
      user-mail-address "apmarshall@soren.tech")
      
(load "~/.dotfiles/emacs/emacs.secrets" t)
(load "~/.dotfiles/emacs/general/custom-settings.el" t)
(load "~/.dotfiles/emacs/packages/my-packages.el" t)

(server-start)
