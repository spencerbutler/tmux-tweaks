have_export() {
  export_var="$(tmux show -gqv @tweaks_export)"
  ! [ -z $export_var ] && export_file="${themes_dir}/${export_var}.theme"
}

have_export_file() {
  [ -f $export_file ]
}

send_to_export() {
  export_theme "$export_file"
}

send_to_load() {
  tmux source-file "$export_file"
  tmux display -F '#{@tweaks_export} was loaded!!'
}

export_theme() {
  option_vals=(buffer-limit default-terminal escape-time exit-unattached focus-events history-file message-limit set-clipboard terminal-overrides assume-paste-time base-index bell-action default-command default-shell destroy-unattached detach-on-destroy display-panes-active-colour display-panes-colour display-panes-time display-time history-limit key-table lock-after-time lock-command message-command-style message-style mouse prefix prefix2 renumber-windows repeat-time remain-on-exit set-titles set-titles-string status status-interval status-justify status-keys status-left status-left-length status-left-style status-position status-right status-right-length status-right-style status-style update-environment visual-activity visual-bell visual-silence word-separators)
  window_vals=(aggressive-resize allow-rename alternate-screen automatic-rename automatic-rename-format clock-mode-colour clock-mode-style force-height force-width main-pane-height main-pane-width mode-keys mode-style monitor-activity monitor-silence other-pane-height other-pane-width pane-active-border-style pane-base-index pane-border-format pane-border-status pane-border-style remain-on-exit synchronize-panes window-active-style window-style window-status-activity-style window-status-bell-style window-status-current-format window-status-current-style window-status-format window-status-last-style window-status-separator window-status-style wrap-search xterm-keys)
  echo "# tmux-tweaks exported this file on $(date)" > "$export_file"

  for oval in "${option_vals[@]}"; do
      echo "set-option -g $oval \"$(tmux show-option -gv $oval)\"" >> "$export_file"
  done

  for wval in "${window_vals[@]}"; do
      echo "set-window-option -g $wval \"$(tmux show-window-option -gv $wval)\"" >> "$export_file"
  done

  echo "Your theme has been saved to $export_file"
  echo "Press Enter to continue."
  echo " "
  cat "$export_file"
}
