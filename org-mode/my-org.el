(global-set-key "\C-c l" 'org-store-link)
(global-set-key "\C-c a" 'org-agenda)
(global-set-key "\C-c c" 'org-capture)
(global-set-key "\C-c b" 'org-iswitchb)

(with-eval-after-load 'org
  (bind-key "C-M-w" 'append-next-kill org-mode-map)
  (bind-key "C-TAB" 'org-cycle org-mode-map)
  (bind-key "C-c v" 'org-show-todo-tree org-mode-map)
  (bind-key "C-c C-r" 'org-refile org-mode-map)
  (bind-key "C-c R" 'org-reveal org-mode-map)
  (bind-key "C-c o" 'my/org-follow-entry-link org-mode-map)
  (bind-key "C-c d" 'my/org-move-line-to-destination org-mode-map)
  (bind-key "C-c f" 'my/org-file-blog-index-entries org-mode-map)
  (bind-key "C-c t s"  'my/split-sentence-and-capitalize org-mode-map)
  (bind-key "C-c t -"  'my/split-sentence-delete-word-and-capitalize org-mode-map)
  (bind-key "C-c t d"  'my/delete-word-and-capitalize org-mode-map)
  (bind-key "C-c C-p C-p" 'my/org-publish-maybe org-mode-map)
  (bind-key "C-c C-r" 'my/org-refile-and-jump org-mode-map))

(with-eval-after-load 'org-agenda
  (bind-key "i" 'org-agenda-clock-in org-agenda-mode-map))

(setq org-use-effective-time t)

   (defun my/org-use-speed-commands-for-headings-and-lists ()
     "Activate speed commands on list items too."
     (or (and (looking-at org-outline-regexp) (looking-back "^\**"))
         (save-excursion (and (looking-at (org-item-re)) (looking-back "^[ \t]*")))))
   (setq org-use-speed-commands 'my/org-use-speed-commands-for-headings-and-lists)

(with-eval-after-load 'org
   (add-to-list 'org-speed-commands-user '("x" org-todo "DONE"))
   (add-to-list 'org-speed-commands-user '("y" org-todo-yesterday "DONE"))
   (add-to-list 'org-speed-commands-user '("!" my/org-clock-in-and-track))
   (add-to-list 'org-speed-commands-user '("s" call-interactively 'org-schedule))
   (add-to-list 'org-speed-commands-user '("d" my/org-move-line-to-destination))
   (add-to-list 'org-speed-commands-user '("i" call-interactively 'org-clock-in))
   (add-to-list 'org-speed-commands-user '("P" call-interactively 'org2blog/wp-post-subtree))
   (add-to-list 'org-speed-commands-user '("o" call-interactively 'org-clock-out))
   (add-to-list 'org-speed-commands-user '("$" call-interactively 'org-archive-subtree))
   (bind-key "!" 'my/org-clock-in-and-track org-agenda-mode-map))

(setq org-goto-interface 'outline
      org-goto-max-level 10)
(require 'imenu)
(setq org-startup-folded nil)
(bind-key "C-c j" 'org-clock-goto) ;; jump to current task from anywhere
(bind-key "C-c C-w" 'org-refile)
(setq org-cycle-include-plain-lists 'integrate)

(defun my/org-follow-entry-link ()
  "Follow the defined link for this entry."
  (interactive)
  (if (org-entry-get (point) "LINK")
      (org-open-link-from-string (org-entry-get (point) "LINK"))
    (org-open-at-point)))

(defun my/org-link-projects (location)
  "Add link properties between the current subtree and the one specified by LOCATION."
  (interactive
   (list (let ((org-refile-use-cache nil))
     (org-refile-get-location "Location"))))
  (let ((link1 (org-store-link nil)) link2)
    (save-window-excursion
      (org-refile 4 nil location)
      (setq link2 (org-store-link nil))
      (org-set-property "LINK" link1))
    (org-set-property "LINK" link2)))

(with-eval-after-load 'org
     (bind-key "C-c k" 'org-cut-subtree org-mode-map)
     (setq org-yank-adjusted-subtrees t))

(setq org-directory "~/org")
(setq org-default-notes-file "~/org/inbox.org")

(load "~/.dotfiles/emacs/org-mode/templates.el" t)
(load "~/.dotfiles/emacs/org-mode/notes.el" t)
(load "~/.dotfiles/emacs/org-mode/tasks.el" t)
(load "~/.dotfiles/emacs/org-mode/agenda.el" t)
(load "~/.dotfiles/emacs/org-mode/time-tracking.el" t)
(load "~/.dotfiles/emacs/org-mode/reporting.el" t)
(load "~/.dotfiles/emacs/org-mode/gcal.el" t)
