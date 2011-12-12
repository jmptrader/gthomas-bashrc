;(add-to-list 'package-archives
;            '("elpa" . "http://tromey.com/elpa/"))
;(add-to-list 'package-archives
;             '("marmalade" . "http://marmalade-repo.org/packages/"))
;; eVil
(add-to-list 'load-path "~/.emacs.d/external/evil")
(require 'evil)
(evil-mode 1)
;; solarized
(add-to-list 'load-path "~/.emacs.d/external/solarized")
;(add-to-list 'custom-theme-load-path "~/.emacs.d/external/solarized")
;require 'solarized-dark-theme)
(require 'solarized-light-theme)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-use-system-font t)
 '(visible-bell t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;'(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "Inconsolata")))))
