SSH_ENV="$HOME/.ssh/environment"
unset SSH_AGENT_PID

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
	. "${SSH_ENV}" > /dev/null
fi

# Check if program with pid of $SSH_AGENT_PID is ssh-agent
[[ -f /proc/$SSH_AGENT_PID/cmdline ]] && cat /proc/$SSH_AGENT_PID/cmdline |\
                                         grep "^$(which ssh-agent)" > /dev/null

# If ssh-agent isn't running, start it
if [ $? -ne 0 ]; then
	#echo "Initialising new SSH agent..."
	/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
	#echo succeeded
	chmod 600 "${SSH_ENV}"
	. "${SSH_ENV}" > /dev/null
fi
