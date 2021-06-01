;;; cp-win-spot.el --- script for copying Windows Spotlight images -*- Emacs-Lisp -*-

;; Copyright (C) 2021 suyeden

;; Author: suyeden
;; Keywords: tools
;; Package-Requires: ((emacs "27.1"))

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Write the path for the output directory to ".config_cpws.txt" file and place it in current directory.
;; Then, execute "emacs --script cp-win-spot.el" from your shell.

;;; Code:

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-file-name-coding-system 'cp932)
(set-keyboard-coding-system 'cp932)
(set-terminal-coding-system 'cp932)
(set-default 'buffer-file-coding-system 'utf-8)
(setq locale-coding-system 'cp932)
(coding-system-put 'cp932 :encode-translation-table
                   (get 'japanese-ucs-jis-to-cp932-map 'translation-table))

(defvar cpws-output-path nil "出力先ディレクトリのパス")
(defvar cpws-output-existing-pics nil "出力先ディレクトリに含まれるすべてのファイルのリスト")
(defvar cpws-userdir nil "ユーザーディレクトリのパス")
(defvar cpws-windows-spotlight-path nil "Windows Spotlight が格納されているディレクトリのパス")
(defvar cpws-windows-spotlight-files nil "cpws-windows-spotlight-path に含まれるすべてのファイルのリスト")
(defvar cpws-windows-spotlight-pics nil "cpws-windows-spotlight-path に含まれるファイルのうち、コピーする必要のあるファイルのリスト")
(defvar cpws-copy-count 0 "コピーした画像の枚数を格納")

(defun main ()
  "Windowsスポットライトの画像を取り込むスクリプト"
  (if (file-exists-p ".config_cpws.txt")
      (progn
        (with-temp-buffer
          (insert-file-contents ".config_cpws.txt")
          (goto-char (point-min))
          (setq cpws-output-path (buffer-substring (point) (progn (end-of-line) (point)))))
        (identify-userdir)
        (setq cpws-windows-spotlight-path (format "%s/AppData/Local/Packages/Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy/LocalState/Assets" cpws-userdir))
        (setq cpws-windows-spotlight-files (cdr (cdr (directory-files cpws-windows-spotlight-path))))
        (setq cpws-output-existing-pics (cdr (cdr (directory-files cpws-output-path))))
        (filesize-checker)
        (file-compare)
        (pics-copy)
        (princ (format "%s pictures are successfully copied." cpws-copy-count)))
    (princ "\nPlace .config_cpws.txt file in current directory!"))
  ;; save-buffers-kill-emacs の際に改行が出力される
  (save-buffers-kill-emacs))

(defun identify-userdir ()
  "ユーザーディレクトリを特定する"
  (let ((mydirs (directory-files "C:/Users/"))
        (nonvalid `("." ".." "All Users" "Default" "Default User" "Public" "desktop.ini"))
        a)
    (catch 'hoge
      (while mydirs
        (setq a (car mydirs))
        (let (b (c nonvalid))
          (while c
            (setq b (car c))
            (if (string= b a)
                (progn
                  (setq c nil)
                  (setq a nil))
              (setq c (cdr c))))
          (if (not (string= (format "%s" a) "nil"))
              (progn
                (setq cpws-userdir (format "C:/Users/%s" a))
                (throw 'hoge t))
            (setq mydirs (cdr mydirs)))
          (setq nonvalid (cdr nonvalid)))))))

(defun filesize-checker ()
  "ファイルサイズが200000より大きいものだけを cpws-windows-spotlight-pics に格納"
  (let (a
        filesize)
    (while cpws-windows-spotlight-files
      (setq a (format "%s/%s" cpws-windows-spotlight-path (car cpws-windows-spotlight-files)))
      (setq filesize
            (nth 7 (file-attributes a)))
      (if (> filesize 200000)
          (setq cpws-windows-spotlight-pics (cons (car cpws-windows-spotlight-files) cpws-windows-spotlight-pics))
        nil)
      (setq cpws-windows-spotlight-files (cdr cpws-windows-spotlight-files)))))

(defun file-compare ()
  "cpws-windows-spotlight-pics 中のファイルのうち cpws-output-existing-pics に無いものを cpws-windows-spotlight-pics に再格納"
  (let ((my-pics cpws-windows-spotlight-pics)
        a)
    (setq cpws-windows-spotlight-pics nil)
    (while my-pics
      (setq a (format "%s.jpg" (car my-pics)))
      (let ((my-pics-existing cpws-output-existing-pics)
            b)
        (while my-pics-existing
          (setq b (car my-pics-existing))
          (if (string= a b)
              (progn
                (setq my-pics-existing nil)
                (setq a nil))
            (setq my-pics-existing (cdr my-pics-existing))))
        (if (not (string= (format "%s" a) "nil"))
            (setq cpws-windows-spotlight-pics (cons (car my-pics) cpws-windows-spotlight-pics))
          nil))
      (setq my-pics (cdr my-pics)))))

(defun pics-copy ()
  "cpws-windows-spotlight-pics に記録されているファイルを順にコピーする"
  (let (a)
    (while cpws-windows-spotlight-pics
      (setq a (car cpws-windows-spotlight-pics))
      (copy-file (format "%s/%s" cpws-windows-spotlight-path a) (format "%s/" cpws-output-path))
      (pict-rename (format "%s/%s" cpws-output-path a))
      (princ (format "%s/%s.jpg\n" cpws-output-path (car cpws-windows-spotlight-pics)))
      (setq cpws-copy-count (1+ cpws-copy-count))
      (setq cpws-windows-spotlight-pics (cdr cpws-windows-spotlight-pics)))))

(defun pict-rename (old-file-name)
  "コピーした画像ファイルに拡張子.jpgをつける"
  (rename-file old-file-name (format "%s.jpg" old-file-name)))

(main)
;;; cp-win-spot.el ends here
