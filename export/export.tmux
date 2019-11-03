#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOCAL_DIR="${TMUX_PLUGIN_MANAGER_PATH/\/plugins\/}/tmux-tweaks/local"
export_dir="${LOCAL_DIR}/export"
themes_dir="${export_dir}/themes"
colours_dir="${export}/colours"
icons_dir="${export}/icons"

scripts_dir="${CURRENT_DIR}/../scripts"
actions_dir="${CURRENT_DIR}/../actions"
source "${scripts_dir}/helpers.sh"
source "${scripts_dir}/helpers.sh"

is_opt_set() {
  local opt=$1
  local val=$(tmux show-option -gqv "$opt")
  [ -z $val ] && return 1 || return 0
}

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv "$option")"

  if [ -n "$option_value" ]; then
    echo "$option_value"
  else
    echo "$default_value"
  fi
}

main() {
  if ! have_dir "$themes_dir"; then
    make_dir "$themes_dir"
  fi
}

main
case $1 in
  set-export)
    tmux command-prompt -p "What is the name of your theme?" "set -g @tweaks_export %1"
    ;;
  export)
    if have_export; then
      send_to_export
    fi
    ;;
  load-theme)
    tmux command-prompt -I "#{@tweaks_export}" -p "Which theme are we loading?" \
      "source-file ~/.tmux/tmux-tweaks/local/export/themes/%1.theme ; display 'Theme %1 was loaded!!'" 
    #if have_export; then
    #  send_to_load "$export_file"
    #fi
    ;;
  *) main ;;
esac
