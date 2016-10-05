(defun my/org-gcal-notify (title mes)
  (message "%s - %s" title mes))
(use-package org-gcal
  :load-path "~/elisp/org-gcal.el"
  :init (fset 'org-gcal-notify 'my/org-gcal-notify))
