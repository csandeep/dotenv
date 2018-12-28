;; ____________________________________________________________________________
;; Aquamacs custom-file warning:
;; Warning: After loading this .emacs file, Aquamacs will also load
;; customizations from `custom-file' (customizations.el). Any settings there
;; will override those made here.
;; Consider moving your startup settings to the Preferences.el file, which
;; is loaded after `custom-file':
;; ~/Library/Preferences/Aquamacs Emacs/Preferences
;; _____________________________________________________________________________

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-l" 'goto-line)

;; turn on font-lock mode
(global-font-lock-mode t)


(set-face-attribute 'default nil :height 170)
(set-face-attribute 'mode-line nil :height 170)


;; turn off menu bar
(menu-bar-mode -1)

;; show column number mode
(setq column-number-mode t)

;; enable visual feedback on selections
(setq-default transient-mark-mode t)

;; necessary support function for buffer burial
(defun crs-delete-these (delete-these from-this-list)
  "Delete DELETE-THESE FROM-THIS-LIST."
  (cond
   ((car delete-these)
    (if (member (car delete-these) from-this-list)
	(crs-delete-these (cdr delete-these) (delete (car delete-these)
						     from-this-list))
      (crs-delete-these (cdr delete-these) from-this-list)))
   (t from-this-list)))

;; this is the list of buffers I never want to see
(defvar crs-hated-buffers
  '("KILL" "*Compile-Log*"))

;; might as well use this for both
(setq iswitchb-buffer-ignore (append '("^ " "*Buffer") crs-hated-buffers))

(defun crs-hated-buffers ()
  "List of buffers I never want to see, converted from names to buffers."
  (delete nil
	  (append
	   (mapcar 'get-buffer crs-hated-buffers)
	   (mapcar (lambda (this-buffer)
		     (if (string-match "^ " (buffer-name this-buffer))
			 this-buffer))
		   (buffer-list)))))

;; I'm sick of switching buffers only to find KILL right in front of me
(defun crs-bury-buffer (&optional n)
  (interactive)
  (unless n
    (setq n 1))
  (let ((my-buffer-list (crs-delete-these (crs-hated-buffers)
					  (buffer-list (selected-frame)))))
    (switch-to-buffer
     (if (< n 0)
	 (nth (+ (length my-buffer-list) n)
	      my-buffer-list)
       (bury-buffer)
       (nth n my-buffer-list)))))

(global-set-key [(meta n)] 'crs-bury-buffer)
(global-set-key [(meta N)] (lambda ()
				       (interactive)
				       (crs-bury-buffer -1)))



;; Remember recently opened files
(require 'recentf)
(recentf-mode 1)

(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil)) 
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)



;;(require 'color-theme-solarized)
;;(color-theme-solarized)
;;(load-theme 'solarized t)
;;(color-theme-clarity)

;;(tool-bar-mode 0)
(ido-mode)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; ** Misc Config **
(if (fboundp 'toggle-max-frame)
    (toggle-max-frame))

(add-to-list 'exec-path "/Users/sandeep/bin")
(put 'scroll-left 'disabled nil)
(add-to-list 'load-path "/Users/sandeep/.emacs.d/lisp/")

(require 'paredit)
