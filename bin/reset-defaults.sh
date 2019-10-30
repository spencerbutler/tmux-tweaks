#!/bin/sh
# Spencer Butler <github@crooked.app>
# PITA defaults

# a single-quote `'`           needs double-quotes `"'"`
# a semi-colon   `;`           needs a backslash   `\;`
# these chars    `?$&./#%!"<~` need single-quote   `'?'`
single='?$&./#%!~"'

save_to_unset() {
  tmux list-keys |\
    sed -Ee "s/(.*) ([$single]) (.*)/\1  '\2' \3 /g" \
      -e 's/(.*) (;) (.*)/\1 \\\2 \3/g' \
      -e 's/(.*) ('\'') (.*)/\1 \"\2\" \3/g' \
      -e "s/(.*[[:space:]]+ if-shell -F )(#\{.*\}) (".*") (".*")/\1 '\2' '\3' '\4'/g" \
      -e 's/^/un/g' -e 's/-r//g' |\
    awk '{print $1,$2,$3,$4}' > /tmp/unset-list-keys
  tmux show-env -gs |\
    sed -e 's/; export.*$//g' \
      -e "s/^/set-env -gu /g" |\
    tr '=' ' ' |\
    awk '{print $1,$2,$3}' > /tmp/unset-env
  tmux show | sed -e "s/^/set -u /g" | awk '{print $1,$2,$3}' > /tmp/unset-opt
  tmux show -s | sed -e "s/^/set -su /g" | awk '{print $1,$2,$3}' > /tmp/unset-opt-s
  tmux show -g | sed -e "s/^/set -gu /g" | awk '{print $1,$2,$3}' > /tmp/unset-opt-g
  tmux showw  | sed -e "s/^/setw -u /g" | awk '{print $1,$2,$3}' > /tmp/unset-optw
  tmux showw  -g | sed -e "s/^/setw -gu /g" | awk '{print $1,$2,$3}' > /tmp/unset-opt-gw

  cat /tmp/unset-list-keys /tmp/unset-env /tmp/unset-opt \
   /tmp/unset-opt-s  /tmp/unset-opt-g \
   /tmp/unset-optw /tmp/unset-opt-gw > /tmp/unset-full
}

save_to_set() {
  tmux list-keys |\
    sed -Ee "s/(.*) ([$single]) (.*)/\1  '\2' \3 /g" \
      -e 's/(.*) (;) (.*)/\1 \\\2 \3/g' \
      -e 's/(.*) ('\'') (.*)/\1 \"\2\" \3/g' > /tmp/list-keys
  tmux show-env -gs |\
    sed -e 's/; export.*$//g' \
      -e "s/^/set-env -g${envunset} /g" |\
    tr '=' ' ' > /tmp/show-env
  tmux show | sed -e "s/^/set /g" > /tmp/show
  tmux show -s | sed -e "s/^/set -s /g" > /tmp/show-s
  tmux show -g | sed -e "s/^/set -g /g" > /tmp/show-g
  tmux showw  | sed -e "s/^/setw /g" > /tmp/showw
  tmux showw  -g | sed -e "s/^/setw -g /g" > /tmp/show-gw

  cat /tmp/list-keys /tmp/show-env /tmp/show \
    /tmp/show-s  /tmp/show-g \
    /tmp/showw /tmp/show-gw > /tmp/full
}

case $1 in
  set  ) save_to_set   ;;
  unset) save_to_unset ;;
  *    ) { echo "set or unset"; exit; }
esac
