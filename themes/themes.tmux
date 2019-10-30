#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

themes_dir="${CURRENT_DIR}"
colours_dir="${CURRENT_DIR}/colours"
icons_dir="${CURRENT_DIR}/icons"

theme_option="@tweaks_theme"
default_theme='spencer'
colour_option="@tweaks_theme_colours"
default_colour='baby_blues'
icon_option="@tweaks_theme_icons"
default_icon="baby_blues"

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

  if [ $theme == factory-defaults ]; then
    #tmux run-shell "${CURRENT_DIR}/../bin/reset-defaults.sh unset"
    tmux source-file "${themes_dir}/${theme}.theme"
  else
    if [ -f "${themes_dir}/${theme}.theme" ]; then
      tmux source-file "${themes_dir}/${theme}.theme"
        else
      tmux source-file "${themes_dir}/${default_theme}.theme"
    fi

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
  fi
}

main
