  (defun my/org-contacts-template-email (&optional return-value)
    "Try to return the contact email for a template.
  If not found return RETURN-VALUE or something that would ask the user."
    (or (cadr (if (gnus-alive-p)
                  (gnus-with-article-headers
                    (mail-extract-address-components
                     (or (mail-fetch-field "Reply-To") (mail-fetch-field "From") "")))))
        return-value
        (concat "%^{" org-contacts-email-property "}p")))


  (defvar my/org-basic-task-template "* TODO %^{Task}
:PROPERTIES:
:Effort: %^{effort|1:00|0:05|0:15|0:30|2:00|4:00}
:END:
Captured %<%Y-%m-%d %H:%M>
%?

%i
" "Basic task data")
  (setq org-capture-templates
        `(("t" "Tasks" entry
           (file+headline "~/personal/organizer.org" "Inbox")
           ,my/org-basic-task-template)
          ("T" "Quick task" entry
           (file+headline "~/personal/organizer.org" "Inbox")
           "* TODO %^{Task}\nSCHEDULED: %t\n"
           :immediate-finish t)
          ("i" "Interrupting task" entry
           (file+headline "~/personal/organizer.org" "Inbox")
           "* STARTED %^{Task}"
           :clock-in :clock-resume)
          ("e" "Emacs idea" entry
           (file+headline "~/code/emacs-notes/tasks.org" "Emacs")
           "* TODO %^{Task}"
           :immediate-finish t)
          ("E" "Energy" table-line
           (file+headline "~/personal/organizer.org" "Track energy")
           "| %U | %^{Energy 5-awesome 3-fuzzy 1-zzz} | %^{Note} |"
           :immediate-finish t
           )
          ("b" "Business task" entry
           (file+headline "~/personal/business.org" "Tasks")
           ,my/org-basic-task-template)
          ("p" "People task" entry
           (file+headline "~/personal/people.org" "Tasks")
           ,my/org-basic-task-template)
          ("j" "Journal entry" plain
           (file+datetree "~/personal/journal.org")
           "%K - %a\n%i\n%?\n"
           :unnarrowed t)
          ("J" "Journal entry with date" plain
           (file+datetree+prompt "~/personal/journal.org")
           "%K - %a\n%i\n%?\n"
           :unnarrowed t)
          ("s" "Journal entry with date, scheduled" entry
           (file+datetree+prompt "~/personal/journal.org")
           "* \n%K - %a\n%t\t%i\n%?\n"
           :unnarrowed t)
          ("c" "Protocol Link" entry (file+headline ,org-default-notes-file "Inbox")
           "* [[%:link][%:description]] \n\n#+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n%?\n\nCaptured: %U")
          ("db" "Done - Business" entry
           (file+headline "~/personal/business.org" "Tasks")
           "* DONE %^{Task}\nSCHEDULED: %^t\n%?")
          ("dp" "Done - People" entry
           (file+headline "~/personal/people.org" "Tasks")
           "* DONE %^{Task}\nSCHEDULED: %^t\n%?")
          ("dt" "Done - Task" entry
           (file+headline "~/personal/organizer.org" "Inbox")
           "* DONE %^{Task}\nSCHEDULED: %^t\n%?")
          ("q" "Quick note" item
           (file+headline "~/personal/organizer.org" "Quick notes"))
          ("l" "Ledger entries")
          ("lm" "MBNA" plain
           (file "~/personal/ledger")
           "%(org-read-date) %^{Payee}
    Liabilities:MBNA
    Expenses:%^{Account}  $%^{Amount}
  " :immediate-finish t)
          ("ln" "No Frills" plain
           (file "~/personal/ledger")
           "%(let ((org-read-date-prefer-future nil)) (org-read-date)) * No Frills
    Liabilities:MBNA
    Assets:Wayne:Groceries  $%^{Amount}
  " :immediate-finish t)
          ("lc" "Cash" plain
           (file "~/personal/ledger")
           "%(org-read-date) * %^{Payee}
    Expenses:Cash
    Expenses:%^{Account}  %^{Amount}
  ")
          ("B" "Book" entry
           (file+datetree "~/personal/books.org" "Inbox")
           "* %^{Title}  %^g
  %i
  *Author(s):* %^{Author} \\\\
  *ISBN:* %^{ISBN}

  %?

  *Review on:* %^t \\
  %a
  %U"
           :clock-in :clock-resume)
           ("C" "Contact" entry (file "~/personal/contacts.org")
            "* %(org-contacts-template-name)
  :PROPERTIES:
  :EMAIL: %(my/org-contacts-template-email)
  :END:")
           ("n" "Daily note" table-line (file+olp "~/personal/organizer.org" "Inbox")
            "| %u | %^{Note} |"
            :immediate-finish t)
           ("r" "Notes" entry
            (file+datetree "~/personal/organizer.org")
            "* %?\n\n%i\n%U\n"
            )))
  (bind-key "C-M-r" 'org-capture)
  
  (defun my/org-refile-and-jump ()
  (interactive)
  (if (derived-mode-p 'org-capture-mode)
      (org-capture-refile)
    (call-interactively 'org-refile))
  (org-refile-goto-last-stored))
(eval-after-load 'org-capture
 '(bind-key "C-c C-r" 'my/org-refile-and-jump org-capture-mode-map))
