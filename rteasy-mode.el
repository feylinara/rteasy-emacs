;;; rteasy-mode.el --- major mode for editing Rteasy2 files. -*- coding: utf-8; lexical-binding: t; -*-

;;; Copyright © 2019 Fey Naomi Schrewe

;;; Author Fey Naomi Schrewe <fey@posteo.eu>
;;; Version 0.1.0
;;; Created 01 Jan 2019
;;; Keywords: Languages

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms
;; of the MIT License.

;;; Commentary:

;;; A syntax highlighting major mode for RTeasy2

;;; Code:

(defvar rteasy-keywords
  '("declare" "bus" "register" "memory" "storage" "array" "goto" "read" "write" "if" "then" "else" "fi" "switch" "case" "default"))

(defvar rteasy-highlight
  (let* ((keywords rteasy-keywords)
         (operators '("and" "or" "xor" "nor" "nand" "not"))

         (comment-regex "#.*$")
         (label-regex "\\([A-Z][A-Za-z0-9_]*\\):")
         (declare-regex "declare \\(bus\\|register\\|memory\\|storage\\|array\\) \\([A-Z][A-Za-z0-9_]*\\)")
         (goto-regex "goto \\([A-Z][A-Za-z0-9_]*\\)")
         (keywords-regex (regexp-opt keywords 'words))
         (operator-regex (regexp-opt operators 'words)))
    `((,comment-regex . font-lock-comment-face)
      (,label-regex . (1 font-lock-function-name-face))
      (,declare-regex . (2 font-lock-variable-name-face))
      (,goto-regex . (1 font-lock-function-name-face))
      (,keywords-regex . font-lock-keyword-face)
      (,operator-regex . font-lock-keyword-face))))

(defun rteasy-completion-at-point ()
  "This is the function to be used for the hook `completion-at-point-functions'."
  ;; (interactive)
  (let* (
         (bds (bounds-of-thing-at-point 'symbol))
         (start (car bds))
         (end (cdr bds)))
    (list start end rteasy-keywords . nil )))

;;;###autoload
(define-derived-mode rteasy-mode prog-mode "Rteasy2"
  "A major mode for editing RTeasy2 files."
  (setq font-lock-defaults '((rteasy-highlight)))
  (setq comment-start "#")
  (setq comment-end "")
  (setq comment-start-skip "#.*$")
  (add-hook 'completion-at-point-functions 'rteasy-completion-at-point nil 'local))

(add-to-list 'auto-mode-alist '("\\.rt\\'" . rteasy-mode))

(provide 'rteasy-mode)

;;; rteasy.el ends here
