;;;
;;;
;;; These are overrides to normal stuff. (Coding stuff has been moved to ide.el
;;;

;;; Coding-ish. But, not specific to any languages
;; This is specific to Pixar
;;(load "~/.xemacs/smarto.el" t t)
;; This doesn't seem to work anymore
;;(load "~/.xemacs/sourcepair.el" t t)


;;(define-key global-map "\C-xz" 'sourcepair-load)

(global-unset-key "\e\e")
(global-set-key "\eg"'goto-line)
(define-key ctl-x-map "c" 'compile)
(global-set-key "\C-c\C-f" 'font-lock-mode)
(global-set-key "\M-/" 'dabbrev-expand)
(global-set-key "\C-x\C-g" 'global-auto-revert-mode)
(global-set-key "\C-c\C-l" 'global-display-fill-column-indicator-mode)
(global-set-key "\C-c\C-C" 'comment-region)
(global-set-key "\C-cd" 'zeal-at-point)
(global-set-key (kbd "<backtab>") 'hippie-expand)

;
; fix stty stuff in some situations. Since I'm overriding help, use M-? as
; a backup
;(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\M-?" 'help-command)

;;======================================================================
;; We need this for a bunch of stuff, but, initially, for the MELP repository.
;; But, I think we need to put all package stuff like this in this area
;; MELPA repository, to pull stuff off the internets
(when (>= emacs-major-version 24)
  (require 'package)
  ;; for important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/"))
)

;; This sets the frame's title bar to the path of the active buffer.
(setq frame-title-format
  '(:eval
    (if buffer-file-name
        (replace-regexp-in-string
         "\\\\" "/"
         (replace-regexp-in-string
          (regexp-quote (getenv "HOME")) "~"
          (convert-standard-filename buffer-file-name)))
      (buffer-name))))

(defun other-window-backward ()
  "Select the previous window."
  (interactive)
  (other-window -1))
(define-key ctl-x-map "y" 'other-window-backward)

; I suppose this could also be done with a novice hook...
(defun my-kill-emacs ()
	"ASK before killing emacs."
	(interactive)
	(if (yes-or-no-p "Really kill emacs? ") (save-buffers-kill-emacs)))
(global-set-key "\C-x\C-c" 'my-kill-emacs)


                                        ;(require 'gud)
;(require 'dap-lldb)
;(require 'dap-cpptools)

; Hooks for C++
(setq-default indent-tabs-mode nil)

; But, for people who insist on using tabs:
(setq tab-width 4)

; Recent file mode
(setq recentf-mode 1)

;;
;; Probably should be in ide.el but ... added by custom.
;; 
(exec-path-from-shell-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (string-inflection ccls spell-fu company-go pdf-tools json-mode flymake-shellcheck use-package treemacs-projectile grip-mode arduino-mode dockerfile-mode cmake-font-lock docker docker-compose-mode tide dap-mode lsp-treemacs hydra exec-path-from-shell lsp-ui lsp-ivy go-projectile go-dlv clang-format)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Keep packages up to date
(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))
