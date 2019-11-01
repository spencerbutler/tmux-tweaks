#!/usr/bin/env bash
# Spencer Butler <github@crooked.app>
# PITA defaults

set -eo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS="${CURRENT_DIR}/helpers.sh"
source "$HELPERS"
CACHE_DIR="${TMUX_PLUGIN_MANAGER_PATH/\/plugins\/}/tmux-tweaks/cache"
SESSION_CREATED_DATE=make-a-real-variable

RESET="${CURRENT_DIR}/../set-factory-settings.defaults"
ACTION_DIR="${CURRENT_DIR}/../actions"

if ! have_cache_dir; then
  make_cache_dir
else
  make_temp_cache_dir
fi

#save_to_set
#save_to_unset
##
#unset_previous
#set_previous
case "$1" in
  reset-tmux-config) 
    set_factory_defaults
    tmux source "${ACTION_DIR}/${1}.action" ;;
  reset) tmux source "$RESET" ;;
  unset) save_to_unset && unset_previous
esac
