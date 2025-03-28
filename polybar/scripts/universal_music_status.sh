#!/bin/bash

# Detect active MPRIS player
player=$(playerctl -l 2>/dev/null | grep -v 'chrome' | head -n 1)
if [ -z "$player" ]; then
    echo " No Media Playing"
    exit 0
fi

# Get metadata
app_name=$(playerctl -p "$player" metadata --format "{{ playerName }}")
song=$(playerctl -p "$player" metadata --format "{{ artist }} - {{ title }}")

# Get progress and duration
position=$(playerctl -p "$player" position)
duration=$(playerctl -p "$player" metadata mpris:length)  # microseconds

# Convert duration to seconds
dur_sec=$((duration / 1000000))
pos_sec=${position%.*}  # Remove decimal

# Function to format time as MM:SS
format_time() {
    min=$(( $1 / 60 ))
    sec=$(( $1 % 60 ))
    printf "%dm:%02ds" "$min" "$sec"
}

# Get formatted time strings
pos_time=$(format_time "$pos_sec")
dur_time=$(format_time "$dur_sec")

# Handle case where duration is zero
if [ "$dur_sec" -eq 0 ]; then
    dur_sec=1  # Avoid division by zero
fi

# Choose icon based on app
case "$app_name" in
    "Spotify") icon="" ;;   # Spotify
    "VLC") icon="󰕼" ;;       # VLC
    "mpv") icon="" ;;       # MPV
    "firefox") icon="" ;;   # Firefox (YouTube, etc.)
    *) icon="" ;;           # Default music note
esac

# Display formatted output: 🎵 MusicApp | Song Title | Time
echo "$icon  $app_name | $song  ($pos_time / $dur_time)"

