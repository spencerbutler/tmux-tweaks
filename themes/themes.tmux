#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
themes_dir="${CURRENT_DIR}"
colours_dir="${CURRENT_DIR}/colours"
icons_dir="${CURRENT_DIR}/icons"

scripts_dir="${CURRENT_DIR}/../scripts"
actions_dir="${CURRENT_DIR}/../actions"
source "${scripts_dir}/helpers.sh"
circle_window_script="${scripts_dir}/circle_window.sh"

theme_option="@tweaks_theme"
default_theme='tmux-tweaks'

colour_option="@tweaks_theme_colours"
default_colour='tmux-tweaks'

icon_option="@tweaks_theme_icons"
default_icon="tmux-tweaks"

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
  local theme="$(get_tmux_option "$theme_option" "$default_theme")"
  local colour="$(get_tmux_option "$colour_option" "$default_colour")"
  local icon="$(get_tmux_option "$icon_option" "$default_icon")"

  if [ $theme == factory-settings ]; then
    tmux source-file "${themes_dir}/${theme}.theme"
  else
    if [ -f "${colours_dir}/${colour}.colours" ]; then
      tmux source-file "${colours_dir}/${colour}.colours"
    else
      tmux source-file "${colours_dir}/${default_colour}.colours"
    fi

    if [ -f "${icons_dir}/${icon}.icons" ]; then
      tmux source-file "${icons_dir}/${icon}.icons"
    else
      tmux source-file "${icons_dir}/${default_icon}.icons"
    fi

    if [ -f "${themes_dir}/${theme}.theme" ]; then
      tmux source-file "${themes_dir}/${theme}.theme"
        else
      tmux source-file "${themes_dir}/${default_theme}.theme"
    fi
  fi
}

main
