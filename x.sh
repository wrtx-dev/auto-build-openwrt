#!/bin/bash

command -v tmate || sudo apt -y install tmate || exit 1

echo Running tmate...
tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready

echo ________________________________________________________________________________
echo
echo To connect to this session copy-n-paste the following into a terminal:
WEBSSH=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')
SSH=$(tmate -S /tmp/tmate.sock display -p '#{tmate_web}')

timeout=$((150*60))
while [ -S /tmp/tmate.sock ]; do
    sleep 1
    timeout=$(($timeout-1))
    if (( timeout < 0 )); then
        echo Waiting on tmate connection timed out!
        exit 1
    fi
    echo ${WEBSSH}
    echo ${SSH}
done
true