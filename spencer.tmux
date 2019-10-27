#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

theme_option="@spencer"
default_theme='default'
colour_option="@spencer_colours"
default_colour='first'

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
  if [ -f "$CURRENT_DIR/${theme}.theme" ]; then
    if [ -f "$CURRENT_DIR/${colour}.colours" ]; then
        tmux source-file "$CURRENT_DIR/${colour}.colours"
    else
        tmux source-file "$CURRENT_DIR/${default_colour}.colours"
    fi
    tmux source-file "$CURRENT_DIR/${theme}.theme"
  else
    tmux source-file "$CURRENT_DIR/unsetvars.sh"
    tmux source-file "$CURRENT_DIR/default.theme"
  fi
}

main
