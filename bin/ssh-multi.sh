#!/bin/bash

# ssh-multi : a script to ssh multiple servers over multiple tmux panes with
#             with all panes syncronized.
#
# olsonbg   : bin/ssh-multi.sh @ https://github.com/olsonbg/dotfiles
#
# Based on nomad-fr  : https://github.com/nomad-fr/scripts-systems
#
# Based on D.Kovalov work : https://gist.github.com/dmytro/3984680

session="sshmulti"

usage() {
	[[ -n "$1" ]] && echo -e "$1\n"
	echo "$(basename $0) -d hosts [-l] [-u username]"
	echo
	echo '   -d "serv0 serv1 ... servN"  : list servers to connect to.'
	echo '   -l                          : include localhost.'
	echo '   -u user                     : user for ssh connection.'
	echo
	echo '  Tips:'
	echo '   -d "$(echo serv{0..2})"'
	echo '   -d "$(script)"'
}

starttmux() {
	local hosts=( $HOSTS )
	local launchedtmux=0

	[[ -n "$user" ]] && user="$user@"

	local window="ssh-multi $user${hosts[0]}"
	window=${window//./-} # tmux uses dots internally to delimit windows and panes
	
	if [ -z "$TMUX" ]; then # if not in a tmux session create one
		if [ "$useLOCALHOST" = 1 ] ; then
			tmux -u new-session -d -s "${session}" -n "${window}"
		else
			tmux -u new-session -d -s "${session}" -n "${window}" ssh "$user${hosts[0]}"
			unset hosts[0];
		fi

		launchedtmux=1
	else # Get session name of current tmux session.
		session="$(tmux display-message -p '#S')"

		# Use a shorter window name when already in a tmux session
		window=${window##ssh-multi }

		if [ "$useLOCALHOST" = 1 ] ; then
			tmux new-window -t "${session}" -n "${window}"
		else
			tmux new-window -t "${session}" -n "${window}" ssh $user${hosts[0]}
			unset hosts[0];
		fi
		launchedtmux=0
	fi

	# Since the name is not guaranteed to be unique, use the window_id.
	local windowid=$(tmux display-message -p '#{window_id}')

	for i in "${hosts[@]}"
	do
			tmux split-window -t "${session}:${windowid}" -h "ssh $user$i"
			tmux select-layout -t "${session}:${windowid}" tiled
	done

	tmux select-layout -t "${session}:${windowid}" tiled
	tmux select-pane -t "${session}:${windowid}"
	tmux set-window-option -t "${session}:${windowid}"  synchronize-panes on

	# Setup complete. If we were already inside a tmux session, then we should
	# be on the newly created window with synchronized panes, otherwise, we
	# need to connect to the new tmux session.
	if [ "$launchedtmux" = 1 ]; then tmux a -dt ${session}; fi
}

checkopt() {
	if [ -z "$HOSTS" ]; then
		usage "Please provide list of hosts with -d option."
		return 1
	fi

	return 0
}


useLOCALHOST=0

while getopts "u:d:lh" opts; do
	case "${opts}" in
		h)
			usage
			exit 0
			;;
		u)
			user=${OPTARG}
			;;
		d)
			HOSTS=${OPTARG}
			;;
		l)
			useLOCALHOST=1
			;;
		*)
			usage
			exit 1
			;;
	esac
done

checkopt || exit 1

starttmux
