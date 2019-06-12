;; General config
(require 'package)
(add-to-list 'load-path "~/.emacs.d/themes/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(package-initialize)

(custom-set-variables
  '(menu-bar-mode nil)
  '(scroll-bar-mode nil)
  '(tool-bar-mode nil)
  '(global-auto-revert-mode t)
  )

;; Doom Themes
(require 'doom-themes)

;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(require 'doom-cyber-theme)
(load-theme 'doom-cyber t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)

;; Enable custom neotree theme (all-the-icons must be installed!)
;(doom-themes-neotree-config)
;; or for treemacs users
(defun doom-enlist (faces)
  (if (listp faces) faces (list faces))
  )
(doom-themes-treemacs-config)

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

;;Startup Items
(require 'treemacs)
(treemacs)
