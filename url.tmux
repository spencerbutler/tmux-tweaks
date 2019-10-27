
split-window \;
capture-pane -b tone
run-shell 'tmux show-buffer -b one | tr -d '\012' | urlview'
