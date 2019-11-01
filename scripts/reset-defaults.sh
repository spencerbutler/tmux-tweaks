#!/usr/bin/env bash
# Spencer Butler <github@crooked.app>
# PITA defaults

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CACHE_DIR="${TMUX_PLUGIN_MANAGER_PATH/\/plugins\/}/tmux-tweaks/cache"
SESSION_CREATED_DATE=make-a-real-variable #FIXME
scripts_dir="${CURRENT_DIR}"
actions_dir="${CURRENT_DIR}/../actions"

source "${CURRENT_DIR}/helpers.sh"


if ! have_cache_dir; then
  make_cache_dir
else
  make_temp_cache_dir
fi

case "$1" in
  reset-tmux-config) reset_tmux_config ;;
  set-factory-defaults) set_factory_defaults ;;
  unset) save_to_unset && unset_previous ;;
esac
