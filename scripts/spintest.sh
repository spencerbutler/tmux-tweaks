#!/bin/sh

mess="starting now"
endmess="bye bye"
./scripts/tmux_spinner.sh "$mess" "$endmess" &
SPINNER_ID=$!
sleep 9
kill $SPINNER_ID
