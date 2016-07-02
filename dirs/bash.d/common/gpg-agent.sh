GPG_ENV="$HOME/.gnupg/environment"
unset GPG_AGENT_PID

if [ -f "${GPG_ENV}" ]; then
	. "${GPG_ENV}" > /dev/null
	GPG_AGENT_PID=$(echo $GPG_AGENT_INFO|sed -e 's/^.*S.gpg-agent:\(.*\):.*$/\1/')
fi

# Check if program with pid of $GPG_AGENT_PID is gpg-agent
[[ -f /proc/$GPG_AGENT_PID/cmdline ]] && cat /proc/$GPG_AGENT_PID/cmdline |\
                                         grep "^$(which gpg-agent)" > /dev/null

# If gpg-agent isn't running, start it.
if [ $? -ne 0 ]; then
#	echo "Initialising new GPG agent..."
	/usr/bin/gpg-agent --daemon  --write-env-file "${GPG_ENV}" > /dev/null
	chmod 600 "${GPG_ENV}"
	. "${GPG_ENV}" > /dev/null
fi

export GPG_AGENT_INFO

# Cleanup
unset GPG_AGENT_PID
unset GPG_ENV
