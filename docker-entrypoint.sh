#!/bin/sh

set -e

# Resolve UNISONLOCALHOSTNAME using cascading fallback
export UNISONLOCALHOSTNAME="${LOCAL_HOSTNAME:-${UNISONLOCALHOSTNAME:-${hostname:-}}}"

# Set UNISON archive folder path
export UNISON="/data/.unison/${UNISONLOCALHOSTNAME}"
# Ensure archive folder exists
mkdir -p "$UNISON"

# remote
if [ -n "$REMOTE_HOSTNAME" ]; then
    REMOTE_DATA="socket://$REMOTE_HOSTNAME:5000//data"
fi

if [ -n "$REMOTE_DATA" ]; then
    # client
    echo "Starting Unison Client"
    exec unison /data "$REMOTE_DATA" -auto -batch -repeat watch -terse \
      -ignore "BelowPath .unison" \
      -ignore "Regex \.unison.*" \
      -ignore "Name *.swp"
else
    # server
    echo "Starting Unison Server"
    exec unison -socket 5000 -auto -batch -repeat watch -terse
fi
