;; General
(require 'package)
(package-initialize)

(add-to-list 'package-archives
             '("melpa" . "http://stable.melpa.org/packages/") t)

(setq backup-directory-alist
  `((".*" . ,temporary-file-directory)))

(setq auto-save-file-name-transforms
  `((".*" ,temporary-file-directory t)))

(setq inhibit-splash-screen t)

(menu-bar-mode -1)
(tool-bar-mode -1)


(global-set-key "\C-xt" '(lambda ()
			   (interactive)
			   (term (getenv "SHELL"))))

(setenv "PATH" (concat (getenv "PATH") ":/home/cornish/.nvm/versions/node/v8.4.0/bin"))

;;(defun move-line-up ()
;;  (interactive)
;;  (transpose-lines 1)
;;  (forward-line -2))
;;
;;(defun move-line-down ()
;;  (interactive)
;;  (forward-line 1)
;;  (transpose-lines 1)
;;  (forward-line -1))
;;
;;(global-set-key [M-up] 'move-line-up)
;;(global-set-key [M-down] 'move-line-down)

;; Dired
(add-hook 'emacs-startup-hook
       (lambda ()
	 (load "dired-x")
	 ;; Set dired-x global variables here.  For example:
	 ;; (setq dired-guess-shell-gnutar "gtar")
	 ;; (setq dired-x-hands-off-my-keys nil)
	 ))
(add-hook 'dired-mode-hook
       (lambda ()
	 ;; Set dired-x buffer-local variables here.  For example:
	 ;; (dired-omit-mode 1)
	 ))

;; Org
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\M-+" 'org-capture)

(setq org-log-into-drawer 1)
(setq org-agenda-files (quote ("~/org/dev"
			       "~/org/agenda")))
(setq org-todo-keywords
       '((sequence "TODO(t)" "|" "DONE(d!)" "CANCELED(c@)")))

(add-hook 'org-capture-mode-hook 'auto-fill-mode)
(add-hook 'org-mode-hook 'auto-fill-mode)

(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/org/refile.org")
	       "* TODO %?\n %i\n")
	      ("j" "journal" entry (file+datetree "~/org/journal.org")
	       "* Entered on %U\n %i\n%?\n"))))

;; Refile
(require 'hydra)
(defun my-refile (file headline &optional arg)
  (let ((pos (save-excursion
               (find-file file)
               (org-find-exact-headline-in-buffer headline))))
    (org-refile arg nil (list headline file nil pos)))
  (switch-to-buffer (current-buffer)))

(defhydra hydra-refile (global-map "\C-cr")
  "Refile"
  ("c" (my-refile "~/org/agenda/class.org" "") "Refile to Class")
  ("a" (my-refile "~/org/agenda/aquisition.org" "") "Refile to Acquisition")
  ("f" (my-refile "~/org/agenda/finance.org" "") "Refile to Finance")
  ("d" (my-refile "~/org/done.org" "") "Refile to Done")
  ("n" next-line "Skip")
  ("s" org-save-all-org-buffers "Save Org Buffers")
  ("q" nil "cancel"))

;; Helm
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Pug
(add-to-list 'auto-mode-alist
	     '("\\.pug\\'" . (lambda ()
			       (jade-mode))))
(defun pug-compile ()
  (interactive)
  (when (eq major-mode `jade-mode)
    (shell-command-to-string (format "pug -P %s" buffer-file-name))))

(add-hook 'after-save-hook 'pug-compile)

;; Multiple Cursors
(global-set-key (kbd "C-c C-l") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; LaTeX
(require 'ox-latex)
(add-to-list 'org-latex-classes
	'("beamer"
	  "\\documentclass\[presentation\]\{beamer\}"
	  ("\\section\{%s\}" . "\\section*\{%s\}")
	  ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
	  ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))
