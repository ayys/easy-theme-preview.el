;;; easy-theme-preview.el --- Easily preview themes  -*- lexical-binding: t; -*-

;; Package: easy-theme-preview
;; Version: 1.0
;; Author: Ayush Jha <ayys@duck.com>
;; URL: https://git.sr.ht/~ayys/theme-preview-mode.el
;; Keywords: theme, faces, convenience, utility, tabulated-list
;; Requires: tabulated-list, package
;; License: GPL-3.0-or-later
;; Coding: utf-8
;;; Code:

(require 'tabulated-list)
(require 'package)

(defgroup easy-theme-preview nil
  "Easily preview themes."
  :group 'themes)

(defcustom easy-theme-preview-indicator "●"
  "String used to indicate the currently active theme."
  :type 'string
  :group 'easy-theme-preview)

(defvar-local easy-theme-preview--filter-type nil
  "Current filter state. Can be nil (all), 'light, or 'dark.")

(declare-function easy-theme-preview--quick-help "easy-theme-preview" ())
(declare-function easy-theme-preview--select "easy-theme-preview" ())
(declare-function easy-theme-preview--describe "easy-theme-preview" ())
(declare-function easy-theme-preview--cycle-filter "easy-theme-preview" ())


(defvar easy-theme-preview-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map tabulated-list-mode-map)
    (define-key map (kbd "RET") #'(lambda () (interactive) (easy-theme-preview-command 'select)))
    (define-key map (kbd "d")   #'(lambda () (interactive) (easy-theme-preview-command 'describe)))
    (define-key map (kbd "f")   #'(lambda () (interactive) (easy-theme-preview-command 'filter)))
    (define-key map (kbd "h")   #'(lambda () (interactive) (easy-theme-preview-command 'help)))
    (define-key map (kbd "?")   #'(lambda () (interactive) (easy-theme-preview-command 'help)))
    (define-key map (kbd "g")   #'(lambda () (interactive) (easy-theme-preview-command 'refresh)))
    (define-key map (kbd "q")   #'quit-window)
    map)
  "Keymap for `easy-theme-preview-mode'.")

(define-derived-mode easy-theme-preview-mode tabulated-list-mode "Theme Preview"
  "Major mode for browsing and previewing Emacs themes."
  (setq tabulated-list-format [(" " 3 t)
                               ("Theme Name" 30 t)
                               ("Description" 60 t)])
  (setq tabulated-list-padding 2)
  (setq tabulated-list-sort-key '("Theme Name" . nil))
  (tabulated-list-init-header)
  (setq revert-buffer-function #'easy-theme-preview--revert)
  (easy-theme-preview--refresh))

(defun easy-theme-preview--get-desc (theme)
  "Get the first line of the documentation for THEME."
  (let ((doc (get theme 'theme-documentation)))
    (if doc (car (split-string doc "\n")) "")))

(defun easy-theme-preview--guess-variant (theme)
  "Guess if THEME is 'light or 'dark based on name and description."
  (let* ((desc (easy-theme-preview--get-desc theme))
         (text (concat (symbol-name theme) " " (downcase desc))))
    (cond
     ((string-match-p "light\\|day\\|dawn\\|sun\\|white" text) 'light)
     ((string-match-p "dark\\|night\\|black\\|deep\\|space" text) 'dark)
     (t nil))))

(defun easy-theme-preview--revert (&rest _ignored)
  "Revert buffer, preserving filter state."
  (easy-theme-preview--refresh))

(defun easy-theme-preview--select ()
  "Logic for selecting/applying the theme."
  (let ((theme (tabulated-list-get-id)))
    (when theme
      (if (custom-theme-enabled-p theme)
          (disable-theme theme)
        (mapc #'disable-theme custom-enabled-themes)
        (load-theme theme t)))
    (easy-theme-preview--refresh)))

(defun easy-theme-preview--describe ()
  "Logic for describing the theme."
  (let ((theme (tabulated-list-get-id)))
    (when theme
      (if (or (package-installed-p theme)
              (package-built-in-p theme))
          (describe-package theme)
        (describe-theme theme)))))

(defun easy-theme-preview--cycle-filter ()
  "Logic for cycling the filter."
  (setq easy-theme-preview--filter-type
        (cond
         ((null easy-theme-preview--filter-type) 'dark)
         ((eq easy-theme-preview--filter-type 'dark) 'light)
         (t nil)))
  (easy-theme-preview--refresh)
  (message "Filter: %s" (or easy-theme-preview--filter-type "All")))

(defun easy-theme-preview--quick-help ()
  "Logic for showing quick help."
  (message
   (mapconcat
    (lambda (entry)
      (format "[%s] %s"
              (propertize (car entry) 'face 'help-key-binding)
              (cdr entry)))
    '(("RET" . "select")
      ("d"   . "describe")
      ("f"   . "filter")
      ("g"   . "refresh")
      ("q"   . "quit"))
    "   ")))

(defun easy-theme-preview--refresh ()
  "Refresh the list of available themes."
  (let ((themes (custom-available-themes))
        (entries nil))
    
    (setq mode-name
          (format "Theme Preview [%s]"
                  (if easy-theme-preview--filter-type
                      (capitalize (symbol-name easy-theme-preview--filter-type))
                    "All")))
    (force-mode-line-update)

    (dolist (theme themes)
      (let ((guessed-variant (easy-theme-preview--guess-variant theme)))
        (when (or (null easy-theme-preview--filter-type)
                  (eq guessed-variant easy-theme-preview--filter-type)
                  (custom-theme-enabled-p theme))
          
          (let* ((active (custom-theme-enabled-p theme))
                 (status (if active
                             (propertize easy-theme-preview-indicator 'face 'success)
                           ""))
                 (name (symbol-name theme))
                 (desc (propertize (easy-theme-preview--get-desc theme)
                                   'face 'font-lock-comment-face)))
            (push (list theme (vector status name desc)) entries)))))
    
    (setq tabulated-list-entries (nreverse entries))
    (tabulated-list-print t)))

(defun easy-theme-preview-command (action)
  "Main command dispatcher for easy-theme-preview-mode.
ACTION is a symbol: 'select, 'describe, 'filter, 'help, or 'refresh."
  (interactive "aAction: ") ; Makes it interactive, though argument is usually passed by the keymap lambda
  (pcase action
    ('select (easy-theme-preview--select))
    ('describe (easy-theme-preview--describe))
    ('filter (easy-theme-preview--cycle-filter))
    ('help (easy-theme-preview--quick-help))
    ('refresh (easy-theme-preview--refresh))
    (_ (message "Unknown action: %s" action))))

;;;###autoload
(defun easy-theme-preview ()
  "Open a buffer listing all available themes for preview."
  (interactive)
  (let ((buffer (get-buffer-create "*easy-theme-preview*")))
    (with-current-buffer buffer
      (easy-theme-preview-mode)
      (easy-theme-preview--refresh))
    (switch-to-buffer buffer)
    (easy-theme-preview--quick-help)))

(provide 'easy-theme-preview)
