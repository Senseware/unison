#!/bin/sh

set -e

# Resolve UNISONLOCALHOSTNAME using cascading fallback
export UNISONLOCALHOSTNAME="${UNISON_LOCAL_HOSTNAME:-${UNISONLOCALHOSTNAME:-${hostname:-}}}"

# Set UNISON archive folder path
export UNISON="/data/.unison/${UNISONLOCALHOSTNAME}"
UNISON_EXTRA="-terse"

# Ensure archive folder exists
mkdir -p "$UNISON"

if [ -n "$REMOTE_DATA" ]; then
    # client
    echo "Starting Unison Client: unison /data $REMOTE_DATA -auto -batch -repeat watch -ignore 'Regex .*/\.unison.*' $UNISON_EXTRA"
    exec unison /data "$REMOTE_DATA" -auto -batch -repeat watch -ignore "Regex .*/\.unison.*" $UNISON_EXTRA
else
    # server
    echo "Starting Unison Server: unison -socket 5000 -auto -batch -repeat watch $UNISON_EXTRA"
    exec unison -socket 5000 -auto -batch -repeat watch $UNISON_EXTRA
fi
