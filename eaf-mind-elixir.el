;;; eaf-mind-elixir.el --- Mind map application base on Mind Elixir

;; Filename: eaf-mind-elixir.el
;; Description: Mind Elixir
;; Author: Andy Stewart <lazycat.manatee@gmail.com>
;; Maintainer: Andy Stewart <lazycat.manatee@gmail.com>
;; Copyright (C) 2021, Andy Stewart, all rights reserved.
;; Created: 2021-08-01 10:30:42
;; Version: 0.1
;; Last-Updated: 2021-08-01 10:30:42
;;           By: Andy Stewart
;; URL: http://www.emacswiki.org/emacs/download/eaf-mind-elixir.el
;; Keywords:
;; Compatibility: GNU Emacs 28.0.50
;;
;; Features that might be required by this library:
;;
;;
;;

;;; This file is NOT part of GNU Emacs

;;; License
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Mind Elixir
;;

;;; Installation:
;;
;; Put eaf-mind-elixir.el to your load-path.
;; The load-path is usually ~/elisp/.
;; It's set in your ~/.emacs like this:
;; (add-to-list 'load-path (expand-file-name "~/elisp"))
;;
;; And the following to your ~/.emacs startup file.
;;
;; (require 'eaf-mind-elixir)
;;
;; No need more.

;;; Customize:
;;
;;
;;
;; All of the above can customize by:
;;      M-x customize-group RET eaf-mind-elixir RET
;;

;;; Change log:
;;
;; 2021/08/01
;;      * First released.
;;

;;; Acknowledgements:
;;
;;
;;

;;; TODO
;;
;;
;;

;;; Require


;;; Code:

(defcustom eaf-mind-elixir-extension-list
  '("eme")
  "The extension list of Mind Elixir application."
  :type 'cons)

;;;###autoload
(defun eaf-open-mind-elixir (file)
  "Open EAF Mind Elixir.
If called interactively, prompt for a .eme file to open or create."
  (interactive "F[EAF/mind-elixir] Select Mindmap file: ")
  (eaf-open file "mind-elixir"))

(defcustom eaf-mind-elixir-keybinding
  '(("<f12>" . "open_devtools")
    ("M-r"   . "js_edit_current_topic")
    ("M-f"   . "focus_root_node")
    ("1"     . "save_file")
    ("C--"   . "js_zoom_out")
    ("C-="   . "js_zoom_in")
    ("C-0"   . "js_zoom_reset")
    ("C-x C-y" . "paste_to_node_topic")
    ("C-x C-w" . "copy_node_topic")
    ("C-f"     . "eaf-send-right-key")
    ("C-b"     . "eaf-send-left-key")
    ("C-n"     . "eaf-send-down-key")
    ("C-p"     . "eaf-send-up-key")
    ("C-m"     . "eaf-send-return-key")
    )
  "The keybinding of EAF Mind Elixir."
  :type 'cons)

(add-to-list 'eaf-app-binding-alist '("mind-elixir" . eaf-mind-elixir-keybinding))

(setq eaf-mind-elixir-module-path (concat (file-name-directory load-file-name) "buffer.py"))
(add-to-list 'eaf-app-module-path-alist '("mind-elixir" . eaf-mind-elixir-module-path))
(add-to-list 'eaf-app-extensions-alist '("mind-elixir" . eaf-mind-elixir-extension-list))

(defcustom eaf-mind-elixir-rainbow-colors-light
  '("#E74C3C"                           ; Red
    "#F39C12"                           ; Orange
    "#F1C40F"                           ; Yellow
    "#2ECC71"                           ; Green
    "#3498DB"                           ; Blue
    "#9B59B6"                           ; Purple
    "#1ABC9C"                           ; Teal
    "#D35400"                           ; Deep Orange
    "#27AE60"                           ; Deep Green
    "#2980B9")                          ; Deep Blue
  "Rainbow connection line color scheme for light themes."
  :type '(repeat string)
  :group 'eaf-mind-elixir)

(defcustom eaf-mind-elixir-rainbow-colors-dark
  '("#FF6B6B"                           ; Bright Red
    "#FFAB4C"                           ; Bright Orange
    "#FFD93D"                           ; Bright Yellow
    "#6BCB77"                           ; Bright Green
    "#4D96FF"                           ; Bright Blue
    "#B983FF"                           ; Bright Purple
    "#56D1C1"                           ; Bright Teal
    "#FF8C42"                           ; Bright Deep Orange
    "#59C36A"                           ; Bright Deep Green
    "#5DA3E4")                          ; Bright Deep Blue
  "Rainbow connection line color scheme for dark themes."
  :type '(repeat string)
  :group 'eaf-mind-elixir)

(defun eaf-mind-elixir-get-rainbow-colors ()
  "Get rainbow color schemes as strings separated by '|' character."
  (let ((light-colors (mapconcat 'identity eaf-mind-elixir-rainbow-colors-light "|"))
        (dark-colors (mapconcat 'identity eaf-mind-elixir-rainbow-colors-dark "|")))
    (list light-colors dark-colors)))

(provide 'eaf-mind-elixir)

;;; eaf-mind-elixir.el ends here
