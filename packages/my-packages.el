(use-package smex
  :bind (("M-x" . smex)
	 ("M-X" . smex-major-mode-commands)))

(use-package helm
   :config
	 (require 'helm-config))

(use-package flycheck
   :ensure t
   :init (global-flycheck-mode))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package ztree)

(use-package projectile
   :config (projectile-global-mode))

(use-package markdown-mode
  :mode ("\\.md\\" ))

(use-package web-mode
  :mode ("\\.html\\" "\\.php\\" ))

(use-package pandoc-mode)