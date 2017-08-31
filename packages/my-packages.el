(setq load-prefer-newer t)

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      ;; Package archives, the usual suspects
      '(("GNU ELPA"     . "http://elpa.gnu.org/packages/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("MELPA"        . "https://melpa.org/packages/"))
      ;; Prefer MELPA Stable over GNU over MELPA.  IOW prefer MELPA's stable
      ;; packages over everything and only fall back to GNU or MELPA if
      ;; necessary.
      package-archive-priorities

      '(("MELPA Stable" . 10)
        ("GNU ELPA"     . 5)
        ("MELPA"        . 0)))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(require 'subr-x)
(require 'time-date)

(setq use-package-verbose t)
(setq use-package-always-ensure t)
(use-package auto-compile
  :config (auto-compile-on-load-mode))


(use-package smex
  :bind (("M-x" . smex)
	 ("M-X" . smex-major-mode-commands)))

(use-package emacs-async
   :config ((autoload 'dired-async-mode "dired-async.el" nil t)
	   (dired-async-mode 1)))

(use-package helm
   :config
	 (require 'helm-config))

(use-package flycheck
   :ensure t
   :init (global-flycheck-mode))

(use-package magit
  :bind ("C-x g" magit-status)
  :config ((with-eval-after-load 'info
  	  (info-initialize)
  	  (add-to-list 'Info-directory-list
	       "~/.emacs.d/site-lisp/magit/Documentation/")))

(use-package ztree)

(use-pakcage projectile
   :config (projectile-global-mode)

(use-package markdown-mode
  :mode "\\.md\\" )

(use-package web-mode
  :mode "\\.html\\" "\\.php\\" )

(use-package solarized-theme
   :config (load-theme))
