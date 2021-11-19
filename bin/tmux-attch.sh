#!/bin/bash

if tmux list-session; then
    tmux attach-session -t 0
else
    tmux
fi
