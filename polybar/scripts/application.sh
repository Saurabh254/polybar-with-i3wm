#!/bin/bash

# Get the active window ID
win_id=$(xdotool getactivewindow 2>/dev/null)

if [ -z "$win_id" ]; then
    echo "󰘳 No Active App"
    exit 0
fi

# Get the application name (class) and window title
app_name=$(xprop -id "$win_id" WM_CLASS | awk -F '"' '{print $4}')
win_title=$(xdotool getwindowname "$win_id")

# Shorten title if too long
win_title=$(echo "$win_title" | cut -c1-40)

if [ -z "$app_name" ]; then
    app_name="Unknown"
fi

if [ -z "$win_title" ]; then
    win_title="No Title"
fi

# Display:  Terminal - Editing file.txt
echo "󰋞 $app_name - $win_title"

