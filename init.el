;;; package --- Summary

;;; Commentary:

;;; Code:


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.dotfiles/emacs")
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp")

(setq user-full-name "Alexander P. Floyd Marshall"
      user-mail-address "apmarshall@soren.tech")
      
(load "~/.emacs.d/emacs.secrets" t)
(load "~/.emacs.d/general/custom-settings.el" t)
(load "~/.emacs.d/packages/my-packages.el" t)

(server-start)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (pandoc-mode ztree web-mode use-package solarized-theme smex projectile markdown-mode magit helm flycheck auto-compile))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
