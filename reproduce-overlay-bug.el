;

;; 1. Defuns
(progn
  (require 'fringe-helper)

  (defun add-single-marker (pos)
    (fringe-helper-insert-region
     pos pos
     (fringe-lib-load fringe-lib-zig-zag)
     'left-fringe 'font-lock-warning-face))

  (defun report-all-overlays ()
    (mapconcat (lambda (ov)
                 (format "%S [%d %d]"
                         (overlay-properties ov)
                         (overlay-start ov)
                         (overlay-end ov)))
               (overlays-in (point-min) (point-max)) "\n"))

  ;; -----> Achtung, überschreibt Originaldefinition <---------
  (defun fringe-helper-modification-func (ov after-p beg end &optional len)
    (message "Called with overlay: %S, after-p: %S" ov after-p))

  (defvar debug-overlay)

  (defun delete-debug-overlay ()
    ;; Kurios: Der Bug verschwindet, wenn vorher remove-overlays aufgerufen wird.
    ;; (remove-overlays)
    (fringe-helper-remove debug-overlay)
    (princ (report-all-overlays))))

;; 2. Bug
(progn
  (add-hook 'before-revert-hook 'delete-debug-overlay nil t) ; local Hook
  (setq debug-overlay (add-single-marker 1))
  (save-excursion
    ;; Setze Leerzeichen vors Semikolon am Dateianfang
    (goto-char (point-min))
    (insert " "))
  (revert-buffer t t) ; noconfirm
  ;; Jetzt *Messages*-Buffer prüfen:
  ;; fringe-helper-modification-func wurde mit einem gelöschten Overlay als Parameter
  ;; aufgerufen.
  )
