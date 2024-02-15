#!/bin/bash

# Stream videos to multiple platforms using ffmpeg and the tee muxer
stream_videos() {
    echo "Starting the streaming process..."

    # Access environment variables directly
    local VIDEO_DIR="${VIDEO_DIR}"
    local TWITCH_STREAM_KEY="${TWITCH_STREAM_KEY}"
    local YOUTUBE_API_KEY="${YOUTUBE_API_KEY}"
    local KICK_STREAM_URL="${KICK_STREAM_URL}"  # Kick stream URL
    local KICK_STREAM_KEY="${KICK_STREAM_KEY}"  # Kick stream key

    echo "Video directory: ${VIDEO_DIR}"
    echo "Twitch Stream Key: ${TWITCH_STREAM_KEY}"
    echo "YouTube API Key: ${YOUTUBE_API_KEY}"
    echo "Kick Stream URL: ${KICK_STREAM_URL}"
    echo "Kick Stream Key: ${KICK_STREAM_KEY}"

    # Loop through all MP4 files in the video directory
    find "${VIDEO_DIR}" -type f -name '*.mp4' | while read -r file; do
        echo "Preparing to stream file: $file"

        # Base ffmpeg command setup
        local FFMPEG_CMD="ffmpeg -re -nostdin -i \"$file\" -map 0 -flags +global_header -c:v libx264 -c:a aac -preset ultrafast -minrate 3000k -maxrate 3000k -bufsize 3000k -g 30 -b:a 128k -ar 44100 -vf \"scale=1920:1080\" -r 30"

        # Initializing tee muxer command with empty streams array
        local TEE_CMD="-f tee"
        local STREAMS=()

        # Configure stream for Twitch if a stream key is provided
        if [ -n "${TWITCH_STREAM_KEY}" ]; then
            echo "Configuring stream for Twitch"
            STREAMS+=("[f=flv:onfail=ignore]rtmp://live-lax.twitch.tv/app/${TWITCH_STREAM_KEY}")
        fi

        # Configure stream for YouTube if an API key is provided
        if [ -n "${YOUTUBE_API_KEY}" ]; then
            echo "Configuring stream for YouTube"
            STREAMS+=("[f=flv:onfail=ignore]rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_API_KEY}")
        fi

        # Configure stream for Kick if both URL and key are provided
        if [ -n "${KICK_STREAM_URL}" ] && [ -n "${KICK_STREAM_KEY}" ]; then
            echo "Configuring stream for Kick"
            STREAMS+=("[f=flv:onfail=ignore]${KICK_STREAM_URL}:443/app/${KICK_STREAM_KEY}")
        fi

        # Combine the stream configurations into a single string
        local TEE_TARGETS=$(IFS='|'; echo "${STREAMS[*]}")

        # Check if there are any configured streams and construct the final ffmpeg command
        if [ -n "${TEE_TARGETS}" ]; then
            FFMPEG_CMD+=" ${TEE_CMD} \"${TEE_TARGETS}\""
            echo "Final ffmpeg command: ${FFMPEG_CMD}"
            echo "Streaming $file to the specified platforms..."
            eval "${FFMPEG_CMD} &"
        else
            echo "No streaming destinations specified. Skipping $file."
        fi

        # Wait for the ffmpeg process to finish before moving to the next file
        wait
    done
}

echo "Initiating stream_videos function..."
stream_videos
