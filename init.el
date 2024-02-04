;;; .emacs
;;; Commentary
;;; Code:

(when (version<  emacs-version "26.3")
  (error "Config not tested on v%s. Please use v26.3 or higher." emacs-version))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(unless (bound-and-true-p package--initialized)
  (setq package-enable-at-startup nil) ;; Prevent double-loading packages
  (package-initialize))

(defvar pkg-refreshed nil)

(defun pm/use (package)
  (when (not pkg-refreshed)
    (setq pkg-refreshed t)
    (package-refresh-contents))
  (when (not (package-installed-p package))
   (package-install package)))

;;;
;;; Defaults
;;;
(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(blink-cursor-mode 0)
(column-number-mode)
(global-display-line-numbers-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode t)
(fringe-mode '(10 . 0))
(global-hl-line-mode)
(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore
      scroll-conservatively 100
      display-time-day-and-date t
      package-enable-at-startup nil)

(setq-default indicate-empty-lines t
			  indent-tabs-mode nil
              tab-width 4)

(load-theme 'base16-default-dark t)

;;;
;;; OS Specific
;;;
(defvar cfg-loc "")

(when (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :font "Terminus-13")
  (setq cfg-loc "C:/Users/ja/AppData/Roaming/.emacs.d/init.el")
  (setq default-directory "C:/Workspace/"))

(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq cfg-loc "~/.emacs")
  (set-face-attribute 'default nil :font "Monaco-14"))

(when (eq system-type 'gnu/linux)
  (setq cfg-loc "~/.emacs")
  (set-face-attribute 'default nil :font "Terminus-12"))

;;; TODO: Add terminal specific settings

;;;
;;; Window and Layout Handling
;;;
(global-set-key (kbd "C-x 2") (lambda () (interactive) (split-window-below) (other-window 1)))
(global-set-key (kbd "C-x 3") (lambda () (interactive) (split-window-horizontally) (other-window 1)))
(global-set-key (kbd "C-c b") 'switch-to-prev-buffer)
(global-set-key (kbd "C-c f") 'switch-to-next-buffer)
(global-set-key (kbd "M-o") (lambda () (interactive) (other-window 1)))
(global-set-key (kbd "M-O") (lambda () (interactive) (other-window -1)))

(defun save-layout-delete-other-windows ()
  "Save the current layout and focus on current window."
  (interactive)
  (window-configuration-to-register ?-)
  (delete-other-windows))

(defun goto-saved-layout ()
  (interactive)
  "Go to saved window layout"
  (jump-to-register ?-))

(global-set-key (kbd "C-x 1") 'save-layout-delete-other-windows)
(global-set-key (kbd "C-c w") 'goto-saved-layout)                

;;;
;;; Editing
;;;                
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region)
(pm/use 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(pm/use 'move-text)
(move-text-default-bindings)

(pm/use 'expand-region)
(global-set-key (kbd "M-;") 'er/expand-region)
                
;;;
;;; Programming Modes
;;;
(setq python-indent-offset 4)
(pm/use 'yaml-mode)
(pm/use 'json-mode)
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 'js-tabwidth)))

(setq c-set-style "k&r")
(setq c-basic-offset 4)

;;;
;;; Compilation
;;;
(global-set-key (kbd "C-c r") (lambda () (interactive) (recompile)))
(global-set-key (kbd "C-c `") 'next-error)

;;;
;;; Misc
;;;
(defun cfg ()
    "Open the `.emacs` or `init.el`."
  (interactive)
  (find-file cfg-loc))

(global-unset-key (kbd "C-x `"))
(global-unset-key (kbd "C-z"))

;;;
;;; UI
;;;
(pm/use 'icomplete-vertical)
(fido-mode t)
(icomplete-vertical-mode t)
;;(pm/use 'amx)
;;(setq amx-show-key-bindings nil)
;;(amx-mode)

(pm/use 'which-key)
(which-key-mode)

;;(pm/use 'vertico)
;;(vertico-mode)

(global-set-key (kbd "M-i") 'imenu)
(setq imenu-auto-rescan t)
