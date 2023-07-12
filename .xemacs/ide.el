;;
;; Making emacs my IDE
;;

(require 'lsp-mode)

;; Another spelling tool. git@gitlab.com:ideasman42/emacs-spell-fu.git
;; cloned, then symlinked into my .xemacs directory
(load "~/.xemacs/spell-fu.el" t t)
(use-package spell-fu) ;; not yet in Melpa.

(global-spell-fu-mode)

(setq-default fill-column 80)

;; C++/LLVM section
(add-hook 'c++-mode-hook #'lsp)

;; Not necessarily c++, but integration with lsp/ccls
(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)

(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

(defun my-c++-mode-hook ()
  ;; my customizations for the c++-mode
  (setq-default indent-tabs-mode nil)
  (setq c-basic-offset 4)  
  (c-set-offset 'inline-open 4)
  (c-set-offset 'topmost-intro-cont 4)
  )

(add-hook 'c++-mode-hook 'my-c++-mode-hook)
          
(require 'clang-format)
(require 'dap-lldb)
(require 'dap-cpptools)
(require 'ccls)
(global-set-key [C-M-tab] 'clang-format-region)
  
  
  
;; end C++/LLVM section

(require 'go-dlv)                                                                      
(add-hook 'go-mode-hook #'lsp)

(add-hook 'go-mode-hook #'lsp-deferred) 

(setq exec-path (append '("~/.gvm/gos/go1.20.3/bin"
                          "~/.gvm/pkgsets/go1.20.3/global/bin")
                        exec-path))
(setenv "PATH" "/home/wyan/envs/mode/bin:/home/wyan/.gvm/pkgsets/go1.20.3/global/bin:/home/wyan/.gvm/gos/go1.20.3/bin:/home/wyan/.gvm/pkgsets/go1.20.3/global/overlay/bin:/home/wyan/.gvm/bin:/home/wyan/.gvm/bin:/usr/local/bin:/bin:/usr/sbin:/usr/bin:/usr/X11/bin:/sbin")
;;(setenv "GOPATH" "/home/wyan/.asdf/installs/golang/1.20.3/go")
;;(setq exec-path (append '("~/.asdf/installs/golang/1.20.3/packages/bin")
;;                        exec-path))
;;(setenv "PATH" "/home/wyan/envs/mode/bin:~/.asdf/installs/golang/1.20.3/packages/bin:/usr/local/bin:/bin:/usr/sbin:/usr/bin:/usr/X11/bin:/sbin")
;;(setq exec-path (append '("~/.asdf/shims")
;;                          exec-path))
;;(setenv "PATH" "/home/wyan/.asdf/shims:/usr/local/bin:/bin:/usr/sbin:/usr/bin:/usr/X11/bin:/sbin")

(setenv "GOPRIVATE" "github.com/moderepo/*")

(defun my-go-mode-hook ()
  (setq-default)
  (setq tab-width 4)
  (setq standard-indent 4)
  (setq indent-tabs-mode t)
  (setq lsp-file-watch-threshold nil)
  ;; from:
  ;; http://tleyden.github.io/blog/2014/05/22/configure-emacs-as-a-go-editor-from-scratch/
  ;; Call Gofmt before saving
  ;;(add-hook 'before-save-hook 'gofmt-before-save)
  ;; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           ;; build is fast, but doesn't work with plugins, because there's a main package. So
           ;; just test, vet, and lint
           "gvm use go1.20.3 && go test -v --race ./... && go vet && revive"))
           ;;"go test -v --race ./... && go vet && revive"))
  ;; Godef jump key binding
)
(add-hook 'go-mode-hook 'my-go-mode-hook)
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()                      
  (add-hook 'before-save-hook 'lsp-format-buffer t t)   
  (add-hook 'before-save-hook 'lsp-organize-imports t t))
;;  (add-hook 'go-mode-hook 'lsp-go-install-save-hooks))

;; End Golang section

;; typescript (via tide.el)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; end typescript


;; Not quite IDE? Anyway, plantUML

;; (with-eval-after-load 'flycheck
;;   (require 'flycheck-plantuml)
;;   (flycheck-plantuml-setup))
