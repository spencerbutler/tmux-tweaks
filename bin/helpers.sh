# a single-quote `'`           needs double-quotes `"'"`
# a semi-colon   `;`           needs a backslash   `\;`
# these chars    `?$&./#%!"<~` need single-quote   `'?'`
single='?$&./#%!~"'

have_cache_dir() {
  [ -d $CACHE_DIR ]
}

make_cache_dir() {
  [ ! -d $CACHE_DIR ] && mkdir -p $CACHE_DIR
}

make_temp_cache_dir() {
  mktemp --directory --tmpdir tmux_tweaks_XXXX 1>/dev/null
}

unset_previous() {
  tmux source "${CACHE_DIR}/unset_previous_options_${SESSION_CREATED_DATE}"
}

set_previous() {
  tmux source "${CACHE_DIR}/set_previous_options_${SESSION_CREATED_DATE}"
}

set_factory_defaults() {
  tmux source $RESET
}

save_to_unset() {
  local file="${CACHE_DIR}/unset_previous_options_${SESSION_CREATED_DATE}"
  [ -f $file ] && mv "$file" "$file_$(date +%s)"
  tmux list-keys |\
    sed -Ee "s/(.*) ([$single]) (.*)/\1  '\2' \3 /g" \
      -e 's/(.*) (;) (.*)/\1 \\\2 \3/g' \
      -e 's/(.*) ('\'') (.*)/\1 \"\2\" \3/g' \
      -e "s/(.*[[:space:]]+ if-shell -F ).*(#\{.*\}) (".*") (".*")/\1 '\2' '\3' '\4'/g" \
      -e "s/[[:space:]](#[[:alpha:]])[[:space:]]/'\1'/g" \
      -e 's/^/un/g' -e 's/-r//g' |\
    awk '{print $1,$2,$3,$4}' >> "$file"
  tmux show-environment -gs |\
    sed -e 's/; export.*$//g' \
      -e "s/^/set-environment -gu /g" |\
    tr '=' ' ' |\
    awk '{print $1,$2,$3}' >> "$file"
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
  tmux show-environment -gs |\
    sed -e 's/; export.*$//g' \
      -e "s/^/set-environment -g /g" |\
    tr '=' ' ' >> "$file"
  tmux show-options | sed -e "s/^/set-option /g" >> "$file"
  tmux show-options -s | sed -e "s/^/set-option -s /g" >> "$file"
  tmux show-options -g | sed -e "s/^/set-option -g /g" >> "$file"
  tmux show-window-options  | sed -e "s/^/set-window-option /g" >> "$file"
  tmux show-window-options  -g | sed -e "s/^/set-window-option -g /g" >> "$file"
}
