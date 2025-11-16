;; init-tab-bar.el --- Initialize tab-bar settings configurations.	-*- lexical-binding: t -*-

;;; Commentary:
;;
;; - https://github.com/ema2159/centaur-tabs
;; - https://github.com/manateelazycat/awesome-tab
;; 

;;; Code:

(use-package centaur-tabs
  :hook
  (after-init . centaur-tabs-mode)
  :custom
  (centaur-tabs-projectile-buffer-group-calc t)
  ;; (centaur-tabs-enable-buffer-reordering)
  ;; (setq centaur-tabs-adjust-buffer-order t)
  ;; (centaur-tabs-change-fonts "arial" 160)
  (uniquify-separator "/")
  (uniquify-buffer-name-style 'forward)
  :config
  (setq centaur-tabs-style "bar"
        centaur-tabs-height 32
        centaur-tabs-set-icons t
        centaur-tabs--buffer-show-groups t
        centaur-tabs-set-modified-marker t
        centaur-tabs-show-navigation-buttons t
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-set-bar 'under
        x-underline-at-descent-line t)
  (centaur-tabs-headline-match)
  (centaur-tabs-group-by-projectile-project))

(use-package awesome-tab
  :disabled t
  :load-path "localelpa/awesome-tab"
  :config
  (awesome-tab-mode t))

(use-package sort-tab
  :disabled t
  :load-path "localelpa/sort-tab"
  :init
  (require 'sort-tab)
  :config
  (sort-tab-mode 1))

(use-package otpp
  :disabled t
  :after project
  :init
  ;; Enable `otpp-mode` globally
  (otpp-mode 1)
  ;; If you want to advice the commands in `otpp-override-commands`
  ;; to be run in the current's tab (so, current project's) root directory
  (otpp-override-mode 1))

(use-package project-tab-groups
  :disabled t
  :init
  (setq project-tab-groups-tab-group-name-function #'+project-tab-groups-name-by-project-root)
  (project-tab-groups-mode t)
  :config
  (defun +project-tab-groups-name-by-project-root (dir)
    "Derive tab group name for project in DIR."
    (with-temp-buffer
      (setq default-directory dir)
      (hack-dir-local-variables-non-file-buffer)
      (let ((name (or (and (boundp 'tab-group-name) tab-group-name)
                      (and (boundp 'project-name) project-name)
                      (and (fboundp 'project-root)
                           (when-let ((project-current (project-current)))
                             (project-root project-current)))
                      (file-name-nondirectory (directory-file-name dir))))
            (name-template (or (and (boundp 'tab-group-name-template) tab-group-name-template)
                               (and (boundp 'project-name-template) project-name-template)
                               "%s")))
        (format name-template name)))))

;; tabspaces - https://github.com/mclear-tools/tabspaces
(use-package tabspaces
  :disabled t
  :hook (after-init . tabspaces-mode)
  :bind-keymap ("H-t" . tabspaces-command-map)
  :bind (:map tabspaces-command-map
              ("2" . tab-new)
              ("0" . tabspaces-close-workspace)
              ("p" . project-other-tab-command)
              ("k" . tabspaces-kill-buffers-close-workspace)
              ("DEL" . tabspaces-remove-current-buffer))
  :custom
  (tab-bar-show nil)

  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-initialize-project-with-todo nil)
  (tabspaces-default-tab "Default")
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*" "*Messages*"))
  ;; sessions
  ;; (tabspaces-session t)
  ;; (tabspaces-session-auto-restore t)
  :config
  ;; Ensure reading project list
  (require 'project)
  (project--ensure-read-project-list)
  
  (tabspaces-mode 1)
  
  ;; Rename the first tab to `tabspaces-default-tab'
  (tab-bar-rename-tab tabspaces-default-tab))

(provide 'init-tab-bar)
;;; init-tab-bar.el ends here
