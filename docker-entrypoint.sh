#!/bin/sh

set -e

# Resolve UNISONLOCALHOSTNAME using cascading fallback
export UNISONLOCALHOSTNAME="${LOCAL_HOSTNAME:-${UNISONLOCALHOSTNAME:-${hostname:-}}}"

# Set UNISON archive folder path
export UNISON="/data/.unison/${UNISONLOCALHOSTNAME}"
# Ensure archive folder exists
mkdir -p "$UNISON"

# Construct REMOTE_DATA from REMOTE_HOSTNAME if only REMOTE_HOSTNAME is provided
if [ -z "$REMOTE_DATA" ] && [ -n "$REMOTE_HOSTNAME" ]; then
    REMOTE_DATA="socket://$REMOTE_HOSTNAME:5000//data"
fi

if [ -n "$REMOTE_DATA" ]; then
    # Client
    echo "Starting Unison Client"
    exec unison /data "$REMOTE_DATA" -auto -batch -repeat watch -terse \
      -ignore "BelowPath .unison" \
      -ignore "Regex \.unison.*"
else
    # Server
    echo "Starting Unison Server"
    exec unison -socket 5000 -auto -batch -repeat watch -terse
fi
