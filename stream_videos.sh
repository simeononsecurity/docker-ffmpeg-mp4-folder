#!/bin/bash

# Function to stream videos
stream_videos() {
    # Access environment variables directly
    local VIDEO_DIR="${VIDEO_DIR}"
    local TWITCH_STREAM_KEY="${TWITCH_STREAM_KEY}"
    local YOUTUBE_API_KEY="${YOUTUBE_API_KEY}"
    local KICK_STREAM_URL="${KICK_STREAM_URL}"  # Kick stream URL
    local KICK_STREAM_KEY="${KICK_STREAM_KEY}"  # Kick stream key
    
    while true; do
        # Find all MP4 files recursively in the video directory
        find "${VIDEO_DIR}" -type f -name '*.mp4' | while read -r file; do
            echo "Preparing to stream $file..."
            
            # Initialize an empty command for ffmpeg
            local FFMPEG_CMD="ffmpeg -re -i \"$file\""
            
            # Append to the ffmpeg command for Twitch if the Twitch stream key is provided
            if [ -n "${TWITCH_STREAM_KEY}" ]; then
                echo "Streaming $file to Twitch..."
                FFMPEG_CMD+=" -c:v libx264 -preset veryfast -maxrate 1000k -bufsize 6000k -g 50 -c:a aac -b:a 128k -ar 44100 -f flv \"rtmp://live-lax.twitch.tv/app/${TWITCH_STREAM_KEY}\""
            fi
            
            # Append to the ffmpeg command for YouTube if the YouTube API key is provided
            if [ -n "${YOUTUBE_API_KEY}" ]; then
                echo "Streaming $file to YouTube..."
                FFMPEG_CMD+=" -c:v libx264 -preset veryfast -maxrate 1000k -bufsize 6000k -g 50 -c:a aac -b:a 128k -ar 44100 -f flv \"rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_API_KEY}\""
            fi

            # Append to the ffmpeg command for Kick if the Kick stream URL and key are provided
            if [ -n "${KICK_STREAM_URL}" ] && [ -n "${KICK_STREAM_KEY}" ]; then
                echo "Streaming $file to Kick..."
                FFMPEG_CMD+=" -c:v libx264 -preset veryfast -maxrate 1000k -bufsize 6000k -g 50 -c:a aac -b:a 128k -ar 44100 -f flv \"${KICK_STREAM_URL}/${KICK_STREAM_KEY}\""
            fi
            
            # Execute the ffmpeg command if any stream key is provided
            if [ -n "${TWITCH_STREAM_KEY}" ] || [ -n "${YOUTUBE_API_KEY}" ] || ([ -n "${KICK_STREAM_URL}" ] && [ -n "${KICK_STREAM_KEY}" ]); then
                eval "${FFMPEG_CMD} &"
            fi
            
            # Wait for the ffmpeg process to finish
            wait
        done
    done
}

# Start streaming videos without passing parameters
stream_videos
