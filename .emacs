;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File name: ` ~/.xemacs/init.el '
;;; ---------------------
;;;
;;; Copyright (c) 2002 SuSE Gmbh Nuernberg, Germany. 
;;;
;;; Author: Werner Fink, <feedback@suse.de> 2002
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Load custom file
;; ----------------
;; Some stuff in here, some stuff in custom.el. But, stuff here is usually less
;; involved.

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Only sets it for the current frame
;; (set-frame-font "Menlo-10")
;; This sets the default font for all frames
(add-to-list 'default-frame-alist
             '(font . "Menlo-10"))

(add-to-list 'load-path "~/.xemacs/")
(setq custom-file "~/.xemacs/custom.el")
;; I would think this would have been done already...
(load "~/.xemacs/custom.el" t t)

; (setq load-path (append load-path '("/usr/share/xemacs/xemacs-packages/lisp/xemacs-base")))
(load "~/.xemacs/ide.el" t t)

;; Try not to open frames.
(setq display-buffer-reuse-frames t)

(require 'uniquify)

