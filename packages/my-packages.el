(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;  (package-refresh-contents)
)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)
(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

(use-package smex
  :bind (("M-x" . smex)
	 ("M-X" . smex-major-mode-commands)))

(use-package emacs-async
   :config
	 (autoload 'dired-async-mode "dired-async.el" nil t)
	 (dired-async-mode 1))

(use-package helm
   :config
	 (require 'helm-config))

(use-package flycheck
   :ensure t
   :init (global-flycheck-mode))

(use-package magit
  :bind ("C-x g" magit-status)
  :config
	(with-eval-after-load 'info
  	  (info-initialize)
  	  (add-to-list 'Info-directory-list
	       "~/.emacs.d/site-lisp/magit/Documentation/")))

(use-package ztree)

(use-pakcage projectile
   :config
	 projectile-global-mode)

(use-package markdown-mode
  :mode "\\.md\\" )

(use-package web-mode
  :mode "\\.html\\" "\\.php\\" )

(use-package solarized-theme
   :config
	 (load-theme))

