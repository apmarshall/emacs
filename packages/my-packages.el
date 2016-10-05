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

(require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

(with-eval-after-load 'info
  (info-initialize)
  (add-to-list 'Info-directory-list
	       "~/.emacs.d/site-lisp/magit/Documentation/"))

(require 'ztree)

(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\.md$" . markdown-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\.html$" "\.php$" . web-mode))

(require 'projectile)
(projectile-global-mode)
