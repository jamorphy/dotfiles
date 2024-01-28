;;; .emacs
;;; Commentary

;;; Code:

(when (version<  emacs-version "26.3")
  (error "Config not tested on v%s. Please use v26.3 or higher." emacs-version))

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(unless (bound-and-true-p package--initialized)
  (setq package-enable-at-startup nil) ;; Prevent double-loading packages
  (package-initialize))

(defvar pkg-refreshed nil)
(defvar cfg-loc "")

(defun pm/use (package)
  (when (not pkg-refreshed)
    (setq pkg-refreshed t)
    (package-refresh-contents))
  (when (not (package-installed-p package))
   (package-install package)))

(setq mac-command-modifier 'meta)

(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(blink-cursor-mode 0)
(column-number-mode)
(global-display-line-numbers-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode t)
(fringe-mode '(10 . 0))
(setq python-indent-offset 4)
(global-hl-line-mode)

(when (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :font "Terminus-13")
  (setq cfg-loc "C:/Users/ja/AppData/Roaming/.emacs.d/init.el")
  (setq default-directory "C:/Workspace/"))

(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :font "Monaco-14"))

(global-set-key (kbd "C-c r") (lambda () (interactive) (recompile)))
(global-unset-key (kbd "C-x `"))
(global-set-key (kbd "C-c `") 'next-error)
(global-set-key (kbd "C-x 2") (lambda () (interactive) (split-window-below) (other-window 1)))
(global-set-key (kbd "C-x 3") (lambda () (interactive) (split-window-horizontally) (other-window 1)))
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c b") 'switch-to-prev-buffer)
(global-set-key (kbd "C-c f") 'switch-to-next-buffer)
(global-unset-key (kbd "C-z"))

(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore
      scroll-conservatively 100
      display-time-day-and-date t
      package-enable-at-startup nil)

(setq-default indicate-empty-lines t
			  indent-tabs-mode nil
              tab-width 4)

(setq c-set-style "k&r")
(setq c-basic-offset 4)

(load-theme 'base16-default-dark t)

(pm/use 'amx)
(amx-mode)

(pm/use 'cl-lib) ;; Does not load on Windows by default
(pm/use 'which-key)
(which-key-mode)
(pm/use 'yaml-mode)

(global-set-key (kbd "M-o") (lambda () (interactive) (other-window 1)))
(global-set-key (kbd "M-O") (lambda () (interactive) (other-window -1)))

;; Programming modes
(pm/use 'json-mode)
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 'js-tabwidth)))

(pm/use 'vertico)
(vertico-mode)

(defun cfg ()
    "Open the config file."
  (interactive)
  (find-file cfg-loc))

(defun save-layout-delete-other-windows ()
  "Save the current layout and focus on current window."
  (interactive)
  (window-configuration-to-register ?-)
  (delete-other-windows))

(defun goto-saved-layout ()
  (interactive)
  "Go to saved window layout"
  (jump-to-register ?-))

(global-unset-key (kbd "C-x 1"))
(global-set-key (kbd "C-x 1") 'save-layout-delete-other-windows)
(global-set-key (kbd "C-c w") 'goto-saved-layout)


(pm/use 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)


(pm/use 'move-text)
(move-text-default-bindings)

(global-set-key (kbd "M-i") 'imenu)
(setq imenu-auto-rescan t)

(pm/use 'expand-region)
(global-unset-key (kbd "M-;"))
(global-set-key (kbd "M-;") 'er/expand-region)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("f700bc979515153bef7a52ca46a62c0aa519950cc06d539df4f3d38828944a2c" "f366d4bc6d14dcac2963d45df51956b2409a15b770ec2f6d730e73ce0ca5c8a7" "a24e023c71f74e8c6a79068947d706f68a566b49a774096671a5cbfe1fb90fc6" "039112154ee5166278a7b65790c665fe17fd21c84356b7ad4b90c29ffe0ad606" "623e9fe0532cc3a0bb31929b991a16f72fad7ad9148ba2dc81e395cd70afc744" "5b01334cb330cd69e5f3d6214521c9f9d703d1c31ca0f4f04f36b6cf9f4870c8" "de024183b38fe74c127a4a4fdb79b10c5e86d512547675faa5b0bfadc1805004" "a0fa9c4582d3c50f6afdcbed2ea759d1e2e17caa3bccb62dbccc090be1129582" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "d89e15a34261019eec9072575d8a924185c27d3da64899905f8548cbd9491a36" default))
 '(fill-column 80)
 '(package-selected-packages
   '(linum-relative zenburn-theme base16-theme nordic-night-theme company yaml-mode which-key vertico solarized-theme selectrum-prescient projectile multiple-cursors move-text magit json-mode ido-vertical-mode expand-region dumb-jump amx))
 '(safe-local-variable-values
   '((eval setq org-todo-keyword-faces
           '(("BUY" . org-warning)
             ("HAVE" . "yellow")
             ("DONE" . org-done)))
     (eval setq org-todo-keywords
           '((sequence "BUY" "HAVE" "|" "" "DONE")))
     (eval setq org-todo-keywords
           '((sequence "sup" "NEW" "|" "IN PROGRESS" "DONE")))
     (eval setq org-todo-keyword-faces
           '(("TODO" . org-warning)
             ("NEW" . "yellow")
             ("IN PROGRESS" . "orange")
             ("DONE" . org-done)))
     (eval setq org-todo-keywords
           '((sequence "TODO" "NEW" "|" "IN PROGRESS" "DONE")))
     (org-todo-keyword-faces
      ("BUY" . org-warning)
      ("HAVE" . "orange")
      ("DONE" . org-done))
     (org-todo-keywords
      (sequence "BUY" "HAVE" "DONE")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


