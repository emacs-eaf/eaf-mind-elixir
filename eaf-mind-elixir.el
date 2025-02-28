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

;;;###autoload
(defun eaf-open-mind-elixir ()
  "Open EAF vue demo"
  (interactive)
  (eaf-open "eaf-mind-elixir" "mind-exlixir"))

(defcustom eaf-mind-elixir-keybinding
  '(("<f12>" . "open_devtools")
    ("M-r" . "js_edit_current_topic")
    )
  "The keybinding of EAF Mind Elixir."
  :type 'cons)

(add-to-list 'eaf-app-binding-alist '("mind-exlixir" . eaf-mind-elixir-keybinding))

(setq eaf-mind-elixir-module-path (concat (file-name-directory load-file-name) "buffer.py"))
(add-to-list 'eaf-app-module-path-alist '("mind-exlixir" . eaf-mind-elixir-module-path))

(provide 'eaf-mind-elixir)

;;; eaf-mind-elixir.el ends here
