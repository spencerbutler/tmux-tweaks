#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

THEMES="${CURRENT_DIR}/themes/themes.tmux"

theme_option="@tweaks_theme"
default_theme='default'
colour_option="@tweaks_theme_colours"
default_colour='first'
icon_option="@tweaks_theme_icons"
default_icon="@tweaks_theme_colours"


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
    source "$THEMES"
  fi
}

main
