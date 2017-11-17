;; Packages
(require 'package)
(require 'cl)
(package-initialize)

(add-to-list 'package-archives
             '("melpa" . "http://stable.melpa.org/packages/") t)


(defvar prelude-packages
  '(magit hydra helm jade-mode multiple-cursors exec-path-from-shell neotree toxi-theme evil company yaml-mode auctex flycheck markdown-mode))

(defun prelude-packages-installed-p ()
  (loop for p in prelude-packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

(unless (prelude-packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs Prelude is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p prelude-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(provide 'prelude-packages)

;; Setting PATH correctly
(exec-path-from-shell-initialize)

;; UI
(global-flycheck-mode)
(add-hook 'after-init-hook 'global-company-mode)
(setq inhibit-splash-screen t)

(menu-bar-mode -1)
(tool-bar-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (toxi)))
 '(custom-safe-themes
   (quote
    ("d71af91a5c31ad4f8b751a3d5aa4104e705890bb5845faf78ae81c8309f38ed3" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(evil-mode 1)
(electric-pair-mode 1)

(global-set-key "\C-ce" 'electric-pair-mode)
(global-set-key "\C-cy" 'yaml-mode)

;; General
(setq backup-directory-alist
  `((".*" . ,temporary-file-directory)))

(setq auto-save-file-name-transforms
  `((".*" ,temporary-file-directory t)))

(global-set-key "\C-xt" '(lambda ()
			   (interactive)
			   (term (getenv "SHELL"))))

;; Flycheck
(setq flycheck-python-pycompile-executable "python3")

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
      (quote (("t" "todo" entry (file "~/org/agenda/refile.org")
	       "* TODO %?\n %i\n")
	      ("b" "blog ideas" entry (file "~/org/blog.org")
	       "* %?\n %i\n")
	      ("j" "journal" entry (file+datetree "~/org/journal.org")
	       "* Entered on %U\n %i\n%?\n")
	      )))

;; Refile
(require 'hydra)
(defun my-refile (file headline &optional arg)
  (let ((pos (save-excursion
               (find-file file)
               (org-find-exact-headline-in-buffer headline))))
    (org-refile arg nil (list headline file nil pos)))
  (switch-to-buffer (current-buffer)))

(defun sync-s3-up ()
    (message "%s" (shell-command-to-string "aws s3 sync ~/org s3://org.s3.johncorni.sh --delete")))

(defun sync-s3-down ()
    (message "%s" (shell-command-to-string "aws s3 sync s3://org.s3.johncorni.sh ~/org --delete")))



(defhydra hydra-s3-sync (nil nil)
  "Syncing"
  ("s" org-save-all-org-buffers "Save All Org Buffers")
  ("u" (sync-s3-up) "Sync Up")
  ("d" (sync-s3-down) "Sync Down")
  ("q" hydra-refile/body "back to refile" :exit t))

(defhydra hydra-refile (global-map "\C-cr")
  "Refile"
  ("a" (my-refile "~/org/agenda/aquisition.org" "") "Acquisition")
  ("c" (my-refile "~/org/agenda/class.org" "") "Class")
  ("f" (my-refile "~/org/agenda/finance.org" "") "Finance")
  ("r" (my-refile "~/org/agenda/rnd.org" "") "R&D")
  ("u" (my-refile "~/org/agenda/upkeep.org" "") "Upkeep")
  ("d" (my-refile "~/org/done.org" "") "Refile to Done")
  ("n" next-line "Skip")
  ("s" hydra-s3-sync/body "S3 Sync" :exit t)
  ("q" nil "cancel" :exit t))

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
(add-to-list 'auto-mode-alist
	     '("\\.m\\'" . (lambda ()
			       (octave-mode))))
(defun pug-compile ()
  (interactive)
  (when (eq major-mode `jade-mode)
    (message "%s" (shell-command-to-string (format "pug -P %s" buffer-file-name)))))

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

(eval-after-load "tex"
  '(add-to-list 'TeX-command-list
		'("PDF LaTeX" "pdflatex %t" TeX-run-TeX)))

(setq TeX-command-default "PDF LaTeX")

;; Neotree
(global-set-key (kbd "<f8>") 'neotree-toggle)
(setq neo-theme 'arrow)

;; Evil
(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)

(define-key evil-normal-state-map "zh" 'split-window-horizontally)
(define-key evil-normal-state-map "zv" 'split-window-vertically)
