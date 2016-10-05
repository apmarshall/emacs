(setq org-todo-keywords
 '((sequence
    "TODO(t)"  ; next action
    "TOBLOG(b)"  ; next action
    "STARTED(s)"
    "WAITING(w@/!)"
    "SOMEDAY(.)" "|" "DONE(x!)" "CANCELLED(c@)")
   (sequence "LEARN" "TRY" "TEACH" "|" "COMPLETE(x)")
   (sequence "TOSKETCH" "SKETCHED" "|" "POSTED")
   (sequence "TOBUY" "TOSHRINK" "TOCUT"  "TOSEW" "|" "DONE(x)")
   (sequence "TODELEGATE(-)" "DELEGATED(d)" "|" "COMPLETE(x)")))
   
(setq org-todo-keyword-faces
   '(("TODO" . (:foreground "green" :weight bold))
     ("DONE" . (:foreground "cyan" :weight bold))
     ("WAITING" . (:foreground "red" :weight bold))
     ("SOMEDAY" . (:foreground "gray" :weight bold))))
     
(setq org-log-done 'time)

(setq org-tags-exclude-from-inheritance '("project"))

(add-to-list 'org-speed-commands-user '("N" org-narrow-to-subtree))
(add-to-list 'org-speed-commands-user '("W" widen))

(defun my/org-agenda-for-subtree ()
  (interactive)
  (when (derived-mode-p 'org-agenda-mode) (org-agenda-switch-to))
  (my/org-with-current-task
   (let ((org-agenda-view-columns-initially t))
     (org-agenda nil "t" 'subtree))))
(add-to-list 'org-speed-commands-user '("T" my/org-agenda-for-subtree))

(setq org-tag-alist '(("@work" . ?b)
                      ("@home" . ?h)
                      ("@writing" . ?w)
                      ("@errands" . ?e)
                      ("@drawing" . ?d)
                      ("@coding" . ?c)
                      ("kaizen" . ?k)
                      ("@phone" . ?p)
                      ("@reading" . ?r)
                      ("@computer" . ?l)
                      ("quantified" . ?q)
                      ("fuzzy" . ?0)
                      ("highenergy" . ?1)))
                      
(add-to-list 'org-global-properties
      '("Effort_ALL". "0:05 0:15 0:30 1:00 2:00 3:00 4:00"))
      
(setq org-enforce-todo-dependencies t)
(setq org-track-ordered-property-with-tag t)
(setq org-agenda-dim-blocked-tasks t)
