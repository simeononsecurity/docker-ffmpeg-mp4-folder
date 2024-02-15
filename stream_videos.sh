#!/bin/bash

# Function to stream videos to Twitch
stream_videos() {
    local VIDEO_DIR="$1"
    local TWITCH_STREAM_KEY="$2"
    local YOUTUBE_API_KEY="$3"
    
    while true; do
        # Find all MP4 files recursively in the video directory
        find "$VIDEO_DIR" -type f -name '*.mp4' | while read -r file; do
            echo "Streaming $file to Twitch and YouTube..."
            ffmpeg -re -i "$file" -c:v libx264 -preset veryfast -maxrate 1000k -bufsize 6000k -g 50 -c:a aac -b:a 128k -ar 44100 -f flv "rtmp://live-lax.twitch.tv/app/$TWITCH_STREAM_KEY" \
                -c:v libx264 -preset veryfast -maxrate 1000k -bufsize 6000k -g 50 -c:a aac -b:a 128k -ar 44100 -f flv "rtmp://a.rtmp.youtube.com/live2/$YOUTUBE_API_KEY"
        done
    done
}

# Check if the required environment variables are set
if [ -z "$VIDEO_DIR" ] || [ -z "$TWITCH_STREAM_KEY" ]; then
    echo "ERROR: Please set the VIDEO_DIR and TWITCH_STREAM_KEY environment variables."
    exit 1
fi

# Check if YouTube API key is provided
if [ -z "$YOUTUBE_API_KEY" ]; then
    echo "WARNING: YouTube API key is not provided. Streaming only to Twitch."
fi

# Start streaming videos
stream_videos "$VIDEO_DIR" "$TWITCH_STREAM_KEY" "$YOUTUBE_API_KEY"
