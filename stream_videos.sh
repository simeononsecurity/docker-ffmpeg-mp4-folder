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

            # Initialize the base ffmpeg command with input file
            local FFMPEG_CMD="ffmpeg -re -i \"$file\" -map 0:v -map 0:a -c:v libx264 -c:a aac -preset veryfast -maxrate 3000k -bufsize 6000k -g 50 -b:a 128k -ar 44100"
            
            # Construct the tee muxer output part of the command
            local TEE_CMD="-f tee"
            local STREAMS=()

            # Add Twitch stream if key is provided
            if [ -n "${TWITCH_STREAM_KEY}" ]; then
                STREAMS+=("[f=flv:onfail=ignore]rtmp://live-lax.twitch.tv/app/${TWITCH_STREAM_KEY}")
            fi

            # Add YouTube stream if API key is provided
            if [ -n "${YOUTUBE_API_KEY}" ]; then
                STREAMS+=("[f=flv:onfail=ignore]rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_API_KEY}")
            fi

            # Add Kick stream if URL and key are provided
            if [ -n "${KICK_STREAM_URL}" ] && [ -n "${KICK_STREAM_KEY}" ]; then
                STREAMS+=("[f=flv:onfail=ignore]${KICK_STREAM_URL}/${KICK_STREAM_KEY}")
            fi

            # Join the streams array into a string separated by '|'
            local TEE_TARGETS=$(IFS='|'; echo "${STREAMS[*]}")
            
            if [ -n "${TEE_TARGETS}" ]; then
                FFMPEG_CMD+=" ${TEE_CMD} \"${TEE_TARGETS}\""
                echo "Streaming $file to the specified platforms..."
                eval "${FFMPEG_CMD} &"
            else
                echo "No streaming destinations specified."
            fi

            # Wait for the ffmpeg process to finish
            wait
        done
    done
}

# Start streaming videos without passing parameters
stream_videos
