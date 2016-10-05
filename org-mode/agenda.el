(setq org-agenda-files
      (delq nil
            (mapcar (lambda (x) (and (file-exists-p x) x))
                    '("~/personal/organizer.org"
                      "~/personal/sewing.org"
                      "~/personal/people.org"
                      "~/Dropbox/wsmef/trip.txt"
                      "~/personal/business.org"
                      "~/personal/calendar.org"
                      "~/Dropbox/wsmef/puppy.txt"
                      "~/Dropbox/tasker/summary.txt"
                      "~/Dropbox/public/sharing/index.org"
                      "~/dropbox/public/sharing/learning.org"
                      "~/code/emacs-notes/tasks.org"
                      "~/sachac.github.io/evil-plans/index.org"
                      "~/personal/cooking.org"
                      "~/personal/routines.org"))))t
(add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))

(setq org-agenda-span 2)
(setq org-agenda-tags-column -100) ; take advantage of the screen width
(setq org-agenda-sticky nil)
(setq org-agenda-inhibit-startup t)
(setq org-agenda-use-tag-inheritance t)
(setq org-agenda-show-log t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)
(setq org-agenda-time-grid
      '((daily today require-timed)
       "----------------"
       (800 1000 1200 1400 1600 1800)))
(setq org-columns-default-format "%14SCHEDULED %Effort{:} %1PRIORITY %TODO %50ITEM %TAGS")

(bind-key "Y" 'org-agenda-todo-yesterday org-agenda-mode-map)

(setq org-agenda-start-on-weekday 6)

(defun my/org-agenda-project-agenda ()
  "Return the project headline and up to `my/org-agenda-limit-items' tasks."
  (save-excursion
    (let* ((marker (org-agenda-new-marker))
           (heading
            (org-agenda-format-item "" (org-get-heading) (org-get-category) nil))
           (org-agenda-restrict t)
           (org-agenda-restrict-begin (point))
           (org-agenda-restrict-end (org-end-of-subtree 'invisible))
           ;; Find the TODO items in this subtree
           (list (org-agenda-get-day-entries (buffer-file-name) (calendar-current-date) :todo)))
      (org-add-props heading
          (list 'face 'defaults
                'done-face 'org-agenda-done
                'undone-face 'default
                'mouse-face 'highlight
                'org-not-done-regexp org-not-done-regexp
                'org-todo-regexp org-todo-regexp
                'org-complex-heading-regexp org-complex-heading-regexp
                'help-echo
                (format "mouse-2 or RET jump to org file %s"
                        (abbreviate-file-name
                         (or (buffer-file-name (buffer-base-buffer))
                             (buffer-name (buffer-base-buffer))))))
        'org-marker marker
        'org-hd-marker marker
        'org-category (org-get-category)
        'type "tagsmatch")
      (concat heading "\n"
              (org-agenda-finalize-entries list)))))

(defun my/org-agenda-projects-and-tasks (match)
  "Show TODOs for all `org-agenda-files' headlines matching MATCH."
  (interactive "MString: ")
  (let ((todo-only nil))
    (if org-agenda-overriding-arguments
        (setq todo-only (car org-agenda-overriding-arguments)
              match (nth 1 org-agenda-overriding-arguments)))
    (let* ((org-tags-match-list-sublevels
            org-tags-match-list-sublevels)
           (completion-ignore-case t)
           rtn rtnall files file pos matcher
           buffer)
      (when (and (stringp match) (not (string-match "\\S-" match)))
        (setq match nil))
      (when match
        (setq matcher (org-make-tags-matcher match)
              match (car matcher) matcher (cdr matcher)))
      (catch 'exit
        (if org-agenda-sticky
            (setq org-agenda-buffer-name
                  (if (stringp match)
                      (format "*Org Agenda(%s:%s)*"
                              (or org-keys (or (and todo-only "M") "m")) match)
                    (format "*Org Agenda(%s)*" (or (and todo-only "M") "m")))))
        (org-agenda-prepare (concat "TAGS " match))
        (org-compile-prefix-format 'tags)
        (org-set-sorting-strategy 'tags)
        (setq org-agenda-query-string match)
        (setq org-agenda-redo-command
              (list 'org-tags-view `(quote ,todo-only)
                    (list 'if 'current-prefix-arg nil `(quote ,org-agenda-query-string))))
        (setq files (org-agenda-files nil 'ifmode)
              rtnall nil)
        (while (setq file (pop files))
          (catch 'nextfile
            (org-check-agenda-file file)
            (setq buffer (if (file-exists-p file)
                             (org-get-agenda-file-buffer file)
                           (error "No such file %s" file)))
            (if (not buffer)
                ;; If file does not exist, error message to agenda
                (setq rtn (list
                           (format "ORG-AGENDA-ERROR: No such org-file %s" file))
                      rtnall (append rtnall rtn))
              (with-current-buffer buffer
                (unless (derived-mode-p 'org-mode)
                  (error "Agenda file %s is not in `org-mode'" file))
                (save-excursion
                  (save-restriction
                    (if org-agenda-restrict
                        (narrow-to-region org-agenda-restrict-begin
                                          org-agenda-restrict-end)
                      (widen))
                    (setq rtn (org-scan-tags 'my/org-agenda-project-agenda matcher todo-only))
                    (setq rtnall (append rtnall rtn))))))))
        (if org-agenda-overriding-header
            (insert (org-add-props (copy-sequence org-agenda-overriding-header)
                        nil 'face 'org-agenda-structure) "\n")
          (insert "Headlines with TAGS match: ")
          (add-text-properties (point-min) (1- (point))
                               (list 'face 'org-agenda-structure
                                     'short-heading
                                     (concat "Match: " match)))
          (setq pos (point))
          (insert match "\n")
          (add-text-properties pos (1- (point)) (list 'face 'org-warning))
          (setq pos (point))
          (unless org-agenda-multi
            (insert "Press `C-u r' to search again with new search string\n"))
          (add-text-properties pos (1- (point)) (list 'face 'org-agenda-structure)))
        (org-agenda-mark-header-line (point-min))
        (when rtnall
          (insert (mapconcat 'identity rtnall "\n") ""))
        (goto-char (point-min))
        (or org-agenda-multi (org-agenda-fit-window-to-buffer))
        (add-text-properties (point-min) (point-max)
                             `(org-agenda-type tags
                                               org-last-args (,todo-only ,match)
                                               org-redo-cmd ,org-agenda-redo-command
                                               org-series-cmd ,org-cmd))
        (org-agenda-finalize)
        (setq buffer-read-only t)))))
        
  (defvar my/org-agenda-contexts
    '((tags-todo "+@phone")
      (tags-todo "+@work")
      (tags-todo "+@drawing")
      (tags-todo "+@coding")
      (tags-todo "+@writing")
      (tags-todo "+@computer")
      (tags-todo "+@home")
      (tags-todo "+@errands"))
    "Usual list of contexts.")
  (defun my/org-agenda-skip-scheduled ()
    (org-agenda-skip-entry-if 'scheduled 'deadline 'regexp "\n]+>"))
  (setq org-agenda-custom-commands
        `(("t" tags-todo "-cooking"
           ((org-agenda-sorting-strategy '(todo-state-up priority-down effort-up))))
          ("T" tags-todo "TODO=\"TODO\"-goal-routine-cooking-SCHEDULED={.+}" nil "~/Dropbox/agenda/nonroutine.html")
          ("f" tags-todo "fuzzy-TODO=\"DONE\"-TODO=\"CANCELLED\"")
          ("F" tags-todo "highenergy-TODO=\"DONE\"-TODO=\"CANCELLED\"")
          ("b" todo ""
           ((org-agenda-files '("~/personal/business.org"))))
          ("B" todo ""
           ((org-agenda-files '("~/Dropbox/books"))))
          ("o" todo ""
           ((org-agenda-files '("~/personal/organizer.org"))))
          ("c" todo ""
           ((org-agenda-prefix-format "")
            (org-agenda-cmp-user-defined 'my/org-sort-agenda-items-todo)
            (org-agenda-view-columns-initially t)
            ))
          ;; Weekly review
          ("w" "Weekly review" agenda ""
           ((org-agenda-span 7)
            (org-agenda-log-mode 1)) "~/Dropbox/agenda/this-week.html")
          ("W" "Weekly review sans routines" agenda ""
           ((org-agenda-span 7)
            (org-agenda-log-mode 1)
            (org-agenda-tag-filter-preset '("-routine"))) "~/Dropbox/agenda/this-week-nonroutine.html")
          ("2" "Bi-weekly review" agenda "" ((org-agenda-span 14) (org-agenda-log-mode 1)))
          ("gb" "Business" todo ""
           ((org-agenda-files '("~/personal/business.org"))
            (org-agenda-view-columns-initially t)))
          ("gc" "Coding" tags-todo "@coding"
           ((org-agenda-view-columns-initially t)))
          ("gw" "Writing" tags-todo "@writing"
           ((org-agenda-view-columns-initially t)))
          ("gp" "Phone" tags-todo "@phone"
           ((org-agenda-view-columns-initially t)))
          ("gd" "Drawing" tags-todo "@drawing"
           ((org-agenda-view-columns-initially t)))
          ("gh" "Home" tags-todo "@home"
           ((org-agenda-view-columns-initially t)))
          ("gk" "Kaizen" tags-todo "kaizen"
           ((org-agenda-view-columns-initially t))
           ("~/Dropbox/agenda/errands.html"))
          ("ge" "Errands" tags-todo "@errands"
           ((org-agenda-view-columns-initially t))
           ("~/Dropbox/agenda/errands.html"))
          ("0" "Top 3 by context"
           ,my/org-agenda-contexts
           ((org-agenda-sorting-strategy '(priority-up effort-down))
            (my/org-agenda-limit-items 3)))
          (")" "All by context"
           ,my/org-agenda-contexts
           ((org-agenda-sorting-strategy '(priority-down effort-down))
            (my/org-agenda-limit-items nil)))
          ("9" "Unscheduled top 3 by context"
           ,my/org-agenda-contexts
           ((org-agenda-skip-function 'my/org-agenda-skip-scheduled)
            (org-agenda-sorting-strategy '(priority-down effort-down))
            (my/org-agenda-limit-items 3)))
          ("(" "All unscheduled by context"
           ,my/org-agenda-contexts
           ((org-agenda-skip-function 'my/org-agenda-skip-scheduled)
            (org-agenda-sorting-strategy '(priority-down effort-down))
            ))
          ("d" "Timeline for today" ((agenda "" ))
           ((org-agenda-ndays 1)
            (org-agenda-show-log t)
            (org-agenda-log-mode-items '(clock closed))
            (org-agenda-clockreport-mode t)
            (org-agenda-entry-types '())))
          ("." "Waiting for" todo "WAITING")
          ("u" "Unscheduled tasks" tags-todo "-someday-TODO=\"SOMEDAY\"-TODO=\"DELEGATED\"-TODO=\"WAITING\"-project"
           ((org-agenda-skip-function 'my/org-agenda-skip-scheduled)
            (org-agenda-view-columns-initially t)
            (org-tags-exclude-from-inheritance '("project"))
            (org-agenda-overriding-header "Unscheduled TODO entries: ")
            (org-columns-default-format "%50ITEM %TODO %3PRIORITY %Effort{:} %TAGS")
            (org-agenda-sorting-strategy '(todo-state-up priority-down effort-up tag-up category-keep))))
          ("U" "Unscheduled tasks outside projects" tags-todo "-project"
           ((org-agenda-skip-function 'my/org-agenda-skip-scheduled)
            (org-tags-exclude-from-inheritance nil)
            (org-agenda-view-columns-initially t)
            (org-agenda-overriding-header "Unscheduled TODO entries outside projects: ")
            (org-agenda-sorting-strategy '(todo-state-up priority-down tag-up category-keep effort-down))))
          ("P" "By priority"
           ((tags-todo "+PRIORITY=\"A\"")
            (tags-todo "+PRIORITY=\"B\"")
            (tags-todo "+PRIORITY=\"\"")
            (tags-todo "+PRIORITY=\"C\""))
           ((org-agenda-prefix-format "%-10c %-10T %e ")
            (org-agenda-sorting-strategy '(priority-down tag-up category-keep effort-down))))
          ("pp" tags "+project-someday-TODO=\"DONE\"-TODO=\"SOMEDAY\"-inactive"
           ((org-tags-exclude-from-inheritance '("project"))
            (org-agenda-sorting-strategy '(priority-down tag-up category-keep effort-down))))
          ("p." tags "+project-TODO=\"DONE\""
           ((org-tags-exclude-from-inheritance '("project"))
            (org-agenda-sorting-strategy '(priority-down tag-up category-keep effort-down))))
          ("S" tags-todo "TODO=\"STARTED\"")
          ("C" "Cooking"
           ((tags "vegetables")
            (tags "chicken")
            (tags "beef")
            (tags "pork")
            (tags "other"))
           ((org-agenda-files '("~/personal/cooking.org"))
            (org-agenda-view-columns-initially t)
            (org-agenda-sorting-strategy '(scheduled-up time-down todo-state-up)))
           )
          ("2" "List projects with tasks" my/org-agenda-projects-and-tasks
           "+PROJECT"
             ((my/org-agenda-limit-items 3)))))
(bind-key "<apps> a" 'org-agenda)

(defun my/org-agenda-done (&optional arg)
  "Mark current TODO as done.
This changes the line at point, all other lines in the agenda referring to
the same tree node, and the headline of the tree node in the Org-mode file."
  (interactive "P")
  (org-agenda-todo "DONE"))
;; Override the key definition for org-exit
(define-key org-agenda-mode-map "x" 'my/org-agenda-done)

  (defun my/org-agenda-mark-done-and-add-followup ()
    "Mark the current TODO as done and add another task after it.
Creates it at the same level as the previous task, so it's better to use
this with to-do items than with projects or headings."
    (interactive)
    (org-agenda-todo "DONE")
    (org-agenda-switch-to)
    (org-capture 0 "t"))
;; Override the key definition
(define-key org-agenda-mode-map "X" 'my/org-agenda-mark-done-and-add-followup)

(defun my/org-agenda-new ()
  "Create a new note or task at the current agenda item.
Creates it at the same level as the previous task, so it's better to use
this with to-do items than with projects or headings."
  (interactive)
  (org-agenda-switch-to)
  (org-capture 0))
;; New key assignment
(define-key org-agenda-mode-map "N" 'my/org-agenda-new)

(setq org-agenda-sorting-strategy
      '((agenda time-up priority-down tag-up category-keep effort-up)
        ;; (todo user-defined-up todo-state-up priority-down effort-up)
        (todo todo-state-up priority-down effort-up) 
        (tags user-defined-up)
        (search category-keep)))
(setq org-agenda-cmp-user-defined 'my/org-sort-agenda-items-user-defined)
(require 'cl)
(defun my/org-get-context (txt)
  "Find the context."
  (car (member-if
        (lambda (item) (string-match "@" item))
        (get-text-property 1 'tags txt))))

(defun my/org-compare-dates (a b)
  "Return 1 if A should go after B, -1 if B should go after A, or 0 if a = b."
  (cond
   ((and (= a 0) (= b 0)) nil)
   ((= a 0) 1)
   ((= b 0) -1)
   ((> a b) 1)
   ((< a b) -1)
   (t nil)))

(defun my/org-complete-cmp (a b)
  (let* ((state-a (or (get-text-property 1 'todo-state a) ""))
         (state-b (or (get-text-property 1 'todo-state b) "")))
    (or
     (if (member state-a org-done-keywords-for-agenda) 1)
     (if (member state-b org-done-keywords-for-agenda) -1))))

(defun my/org-date-cmp (a b)
  (let* ((sched-a (or (get-text-property 1 'org-scheduled a) 0))
         (sched-b (or (get-text-property 1 'org-scheduled b) 0))
         (deadline-a (or (get-text-property 1 'org-deadline a) 0))
         (deadline-b (or (get-text-property 1 'org-deadline b) 0)))
    (or
     (my/org-compare-dates
      (my/org-min-date sched-a deadline-a)
      (my/org-min-date sched-b deadline-b)))))

(defun my/org-min-date (a b)
  "Return the smaller of A or B, except for 0."
  (funcall (if (and (> a 0) (> b 0)) 'min 'max) a b))

(defun my/org-sort-agenda-items-user-defined (a b)
  ;; compare by deadline, then scheduled date; done tasks are listed at the very bottom
  (or
   (my/org-complete-cmp a b)
   (my/org-date-cmp a b)))

(defun my/org-context-cmp (a b)
  "Compare CONTEXT-A and CONTEXT-B."
  (let ((context-a (my/org-get-context a))
        (context-b (my/org-get-context b)))
    (cond
     ((null context-a) +1)
     ((null context-b) -1)
     ((string< context-a context-b) -1)
     ((string< context-b context-a) +1)
     (t nil))))

(defun my/org-sort-agenda-items-todo (a b)
  (or
   (org-cmp-time a b)
   (my/org-complete-cmp a b)
   (my/org-context-cmp a b)
   (my/org-date-cmp a b)
   (org-cmp-todo-state a b)
   (org-cmp-priority a b)
   (org-cmp-effort a b)))

(defun my/org-agenda-list-unscheduled (&rest ignore)
  "Create agenda view for tasks that are unscheduled and not done."
  (let* ((org-agenda-todo-ignore-with-date t)
   (org-agenda-overriding-header "List of unscheduled tasks: "))
    (org-agenda-get-todos)))
(setq org-stuck-projects
      '("+PROJECT-MAYBE-DONE"
        ("TODO")
        nil
        "\\<IGNORE\\>"))

(defun my/org-show-active-projects ()
  "Show my current projects."
  (interactive)
  (org-tags-view nil "project-inactive-someday"))
  
(defvar my/org-agenda-limit-items nil "Number of items to show in agenda to-do views; nil if unlimited.")
(eval-after-load 'org
'(defadvice org-agenda-finalize-entries (around sacha activate)
  (if my/org-agenda-limit-items
      (progn
        (setq list (mapcar 'org-agenda-highlight-todo list))
        (setq ad-return-value
              (subseq list 0 my/org-agenda-limit-items))
        (when org-agenda-before-sorting-filter-function
          (setq list (delq nil (mapcar org-agenda-before-sorting-filter-function list))))
        (setq ad-return-value
              (mapconcat 'identity
                         (delq nil
                               (subseq
                                (sort list 'org-entries-lessp)
                                0
                                my/org-agenda-limit-items))
                         "\n")))
    ad-do-it)))
