#!/bin/bash

command -v tmate || sudo apt -y install tmate || exit 1

echo Running tmate...
tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready

echo ________________________________________________________________________________
echo
echo To connect to this session copy-n-paste the following into a terminal:
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'

timeout=$((15*60))
while [ -S /tmp/tmate.sock ]; do
    sleep 1
    timeout=$(($timeout-1))
    if (( timeout < 0 )); then
        echo Waiting on tmate connection timed out!
        exit 1
    fi
done
true