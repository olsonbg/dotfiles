SSH_ENV="$HOME/.ssh/environment"

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
	. "${SSH_ENV}" > /dev/null
fi

# Check if program with pid of $SSH_AGENT_PID is ssh-agent, if not, start
# ssh-agent
if ! grep "^$(command -v ssh-agent)" "/proc/$SSH_AGENT_PID/cmdline" > /dev/null 2> /dev/null; then

	echo "Initialising new SSH agent..."
	/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
	echo succeeded
	chmod 600 "${SSH_ENV}"
	. "$SSH_ENV" > /dev/null
fi

unset SSH_ENV
