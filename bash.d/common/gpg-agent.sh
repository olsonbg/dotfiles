GPG_ENV="$HOME/.gnupg/environment"

function start_gpg_agent {
#    echo "Initialising new GPG agent..."
    /usr/bin/gpg-agent --daemon  --write-env-file "${GPG_ENV}" > /dev/null
#    echo succeeded
    chmod 600 "${GPG_ENV}"
    . "${GPG_ENV}" > /dev/null
}

# Source GPG settings, if applicable

if [ -f "${GPG_ENV}" ]; then
    . "${GPG_ENV}" > /dev/null
	GPG_AGENT_PID=$(echo $GPG_AGENT_INFO|sed -e 's/^.*S.gpg-agent:\(.*\):.*$/\1/')
    #ps ${GPG_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${GPG_AGENT_PID} | grep "/usr/bin/gpg-agent" > /dev/null || {
        start_gpg_agent;
    }
    unset GPG_AGENT_PID
else
    start_gpg_agent;
fi
