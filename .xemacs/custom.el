
(global-unset-key "\e\e")
(global-set-key "\eg"'goto-line)
(define-key ctl-x-map "c" 'compile)
(global-set-key "\C-c\C-f" 'font-lock-mode)
(global-set-key "\M-/" 'dabbrev-expand)
(global-set-key "\C-x\C-g" 'global-auto-revert-mode)
(global-set-key "\C-c\C-C" 'comment-region)
(global-set-key "\C-cd" 'zeal-at-point)
(global-set-key (kbd "<backtab>") 'hippie-expand)

;
; fix stty stuff.  Shame that I know elisp better than stty commands.
;
(global-set-key "\C-h" 'delete-backward-char)
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

(setq-default indent-tabs-mode nil)

; But, for people who insist on using tabs:
(setq tab-width 4)

(defun my-c++-mode-hook ()
  ;; my customizations for the c++-mode
  (font-lock-mode 1)
  (setq-default indent-tabs-mode nil)
  (setq c-basic-offset 4)
  (c-set-offset 'inline-open 4)
  (c-set-offset 'topmost-intro-cont 4)
) 

(defun my-python-mode-hook ()
  ;; my customizations for the python-mode
  (font-lock-mode 1)
  (setq py-indent-offset 4)
) 

(defun my-makefile-mode-hook ()
  ;; my customizations for the makefile-mode
  (font-lock-mode 1)
  (global-set-key "\C-c\C-f" 'font-lock-mode)
) 

(defun my-html-mode-hook ()
  ;; my customizations for the html-mode
  (font-lock-mode 1)
  (global-set-key "\C-c\C-f" 'font-lock-mode)
) 

; java mode setting
(defun my-java-mode-hook ()
  ;; my customizations for the java-mode
  (setq c-basic-offset 2)
  (c-set-offset 'topmost-intro-cont 2)
  (c-set-offset 'inline-open 0)
  ;; Java programmers all use eclipse, so they all get used to not doing
  ;; anything about tabs
  (setq-default tab-width 4)
)

; This doesn't seem to work. Except mayte the tab-width
(add-hook 'go-mode-hook
  (setq-default tab-width 4)
  (lambda ()
    (setq-default)
    (setq tab-width 4)
    (setq standard-indent 4)
    (setq indent-tabs-mode nil)))

(defun my-go-mode-hook ()
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
)
(add-hook 'go-mode-hook 'my-go-mode-hook)


(setq c-echo-syntactic-information-p 1)	;set to non-nil
; ajava mode setting
(defun my-ajava-mode-hook ()
  ;; my customizations for the java-mode
  (setq c-basic-offset 2)
  (c-set-offset 'statement-cont 0)
)


; (require 'gud)

(setq line-number-mode t)
(setq truncate-partial-width-windows nil)
(setq column-number-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (treemacs-magit treemacs-projectile treemacs yasnippet-classic-snippets zeal-at-point go-dlv go-guru lsp-ui go-mode yasnippet-snippets company-lsp lsp-mode use-package gnu-elpa-keyring-update))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq auto-mode-alist
        (append
                (list 
                        (cons "go.mod" 'go-mod)
                        )
                auto-mode-alist))


(require 'use-package)

(use-package lsp-mode
  :commands (lsp lsp-deferred))

(add-hook 'go-mode-hook #'lsp-deferred)

;; optional - provides fancier overlays
(use-package lsp-ui
  :commands lsp-ui-mode)

;; if you use company-mode for completion (otherwise, complete-at-point works out of the box):
(use-package company-lsp
  :commands company-lsp)
