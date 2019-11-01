#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
themes_dir="${CURRENT_DIR}/themes"
scripts_dir="${CURRENT_DIR}/scripts"
colours_dir="${CURRENT_DIR}/colours"
icons_dir="${CURRENT_DIR}/icons"
actions_dir="${CURRENT_DIR}/actions"

source "${scripts_dir}/helpers.sh"
tmux bind u source-file "${actions_dir}/url.action"

theme_option="@tweaks_theme"
default_theme='tmux-tweaks'

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
  if is_opt_set "$theme_option"; then
    tmux run-shell "${themes_dir}/themes.tmux"
  fi
}

main
