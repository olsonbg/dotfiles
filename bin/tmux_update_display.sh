#!/usr/bin/env bash

# From:
# https://github.com/rjmccabe3701/linux_config/blob/master/scripts/update_display.sh

#This was inspired by
# https://gist.github.com/mikeboiko/b6e50210b4fb351b036f1103ea3c18a9

# The problem:
# When you `ssh -X` into a machine and attach to an existing tmux session, the
# session contains the old $DISPLAY env variable. In order the x-server/client
# to work properly, you have to update $DISPLAY after connection. For example,
# the old $DISPLAY=:0 and you need to change to $DISPLAY=localhost:10.0 for my
# ssh session to perform x-forwarding properly.

# The solution:
# When attaching to tmux session, update $DISPLAY for each tmux pane in that
# session.  This is performed by using tmux send-keys to the shell. It will
# update the DISPLAY for panes running:
#   * zsh
#   * bash
#   * vim/nvim
#   * python
# If a pane is running something else (e.g. an ssh session into another
# machine) it is ignored.  Even if the pane is running one of the above
# processes, if you exit that process (say its running nvim and you exit to
# the zsh shell), the parent process will have the old DISPLAY variable.  In
# these cases manually run this script later.

NEW_DISPLAY=$(tmux show-env | sed -n 's/^DISPLAY=//p')
FORMAT_STR="#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}"

tmux list-panes -s -F "$FORMAT_STR" | \
while IFS=' ' read -ra pane_process
do
	case "${pane_process[1]}" in
		zsh|bash)
			tmux send-keys -t "${pane_process[0]}" \
			     " export DISPLAY=$NEW_DISPLAY" Enter
			;;
		*python*)
			tmux send-keys -t "${pane_process[0]}" \
			     "export DISPLAY=$NEW_DISPLAY" Enter
			;;
		*vim*)
			tmux send-keys -t "${pane_process[0]}" \
			     Escape
			tmux send-keys -t "${pane_process[0]}" \
			     ":let \$DISPLAY = \"$NEW_DISPLAY\"" Enter
			;;
	esac
done
