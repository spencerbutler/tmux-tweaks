# a single-quote `'`           needs double-quotes `"'"`
# a semi-colon   `;`           needs a backslash   `\;`
# these chars    `?$&./#%!"<~` need single-quote   `'?'`
single='?$&./#%!~"'

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
  vals=(status-interval status-style status-left-style status-left-length status-left status-right-style status-right-length status-right window-status-format window-status-current-format window-status-current-style window-status-activity-style window-status-separator status-justify pane-border-style display-panes-colour display-panes-active-colour clock-mode-colour clock-mode-style message-style message-command-style mode-style)
  echo "# tmux-tweaks exported this file on $(date)" > "$export_file"

  for val in "${vals[@]}"; do
    if [[ $val =~ clock ]]; then
      echo "set-window-option $val \"$(tmux show-window-option -gv $val)\"" >> "$export_file"
    else
      echo "set-option $val \"$(tmux show-option -gv $val)\"" >> "$export_file"
    fi
  done

  echo "Your theme has been saved to $export_file"
  echo " "
  cat "$export_file"
}


reset_tmux_config() {
    set_factory_defaults
    tmux source ~/.tmux.conf
}

have_dir() {
  [ -d $1 ]
}

make_dir() {
  [ ! -d $1 ] && mkdir -p "$1"
}

have_cache_dir() {
  [ -d $CACHE_DIR ]
}

make_cache_dir() {
  [ ! -d $CACHE_DIR ] && mkdir -p $CACHE_DIR
}

make_temp_cache_dir() {
  mktemp --directory --tmpdir tmux_tweaks_XXXX &>/dev/null
}

unset_previous() {
  tmux source "${CACHE_DIR}/unset_previous_options_${SESSION_CREATED_DATE}"
}

set_previous() {
  tmux source "${CACHE_DIR}/set_previous_options_${SESSION_CREATED_DATE}"
}

set_factory_defaults() {
  tmux source "${actions_dir}/reset-tmux-config.action" 
}

save_to_unset() {
  local file="${CACHE_DIR}/unset_previous_options_${SESSION_CREATED_DATE}"
  [ -f $file ] && mv "$file" "${file}_$(date +%s)"
  tmux list-keys |\
    sed -Ee "s/(.*) ([$single]) (.*)/\1  '\2' \3 /g" \
      -e 's/(.*) (;) (.*)/\1 \\\2 \3/g' \
      -e 's/(.*) ('\'') (.*)/\1 \"\2\" \3/g' \
      -e "s/(.*[[:space:]]+ if-shell -F ).*(#\{.*\}) (".*") (".*")/\1 '\2' '\3' '\4'/g" \
      -e "s/[[:space:]](#[[:alpha:]])[[:space:]]/'\1'/g" \
      -e 's/^/un/g' -e 's/-r//g' |\
    awk '{print $1,$2,$3,$4}' >> "$file"
  #tmux show-environment -gs |\
  #  sed -e 's/; export.*$//g' \
  #    -e "s/^/set-environment -gu /g" |\
  #  tr '=' ' ' |\
  #  awk '{print $1,$2,$3}' >> "$file"
  tmux show-options | sed -e "s/^/set-option -u /g" | awk '{print $1,$2,$3}' >> "$file"
  tmux show-options -s | sed -e "s/^/set-option -su /g" | awk '{print $1,$2,$3}' >> "$file"
  tmux show-options -g | sed -e "s/^/set-option -gu /g" | awk '{print $1,$2,$3}' >> "$file"
  tmux show-window-options  | sed -e "s/^/set-window-option -u /g" | awk '{print $1,$2,$3}' >> "$file"
  tmux show-window-options  -g | sed -e "s/^/set-window-option -gu /g" | awk '{print $1,$2,$3}' >> "$file"
}

save_to_set() {
  local file="${CACHE_DIR}/set_previous_options_${SESSION_CREATED_DATE}"
  [ -f $file ] && mv "$file" "$file_$(date +%s)"
  tmux list-keys |\
    sed -Ee "s/(.*) ([$single]) (.*)/\1  '\2' \3 /g" \
      -e 's/(.*) (;) (.*)/\1 \\\2 \3/g' \
      -e "s/(.*[[:space:]]+ if-shell -F ).*(#\{.*\}) (".*") (".*")/\2 '\2' '\3' '\4'/g" \
      -e "s/[[:space:]](#[[:alpha:]])[[:space:]]/'\1'/g" \
      -e 's/(.*) ('\'') (.*)/\1 \"\2\" \3/g' >> "$file"
  # I don't think we want to do this
  #tmux show-environment -gs |\
  #  sed -e 's/; export.*$//g' \
  #    -e "s/^/set-environment -g /g" |\
  #  tr '=' ' ' >> "$file"
  tmux show-options | sed -e "s/^/set-option /g" >> "$file"
  tmux show-options -s | sed -e "s/^/set-option -s /g" >> "$file"
  tmux show-options -g | sed -e "s/^/set-option -g /g" >> "$file"
  tmux show-window-options  | sed -e "s/^/set-window-option /g" >> "$file"
  tmux show-window-options  -g | sed -e "s/^/set-window-option -g /g" >> "$file"
}
