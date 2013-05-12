(defun turn-on-hl-line-mode ()
  (hl-line-mode t))

(add-hook 'emacs-lisp-mode-hook 'turn-on-hl-line-mode)
;; Seltsam: Wird stattdessen `global-hl-line-mode' benutzt, gibt es kein Problem
;; (global-hl-line-mode)

(setq config-dir (file-name-directory load-file-name))
(load (concat config-dir "fringe-helper.el"))

(view-echo-area-messages)
(erase-buffer)
(find-file (concat config-dir "reproduce-overlay-bug.el"))
(eval-buffer)
(view-echo-area-messages)
