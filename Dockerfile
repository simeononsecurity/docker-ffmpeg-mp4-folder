FROM ubuntu:latest

# Set Labels
LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/docker-ffmpeg-mp4-folder"
LABEL org.opencontainers.image.description="Stream From a Folder of MP4 Files to Twitch, YouTube, andor Kick"
LABEL org.opencontainers.image.authors="simeononsecurity"

# Set ENV Variables
ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV TERM=xterm

# Install necessary dependencies
RUN apt update && \
    apt full-upgrade -y --no-install-recommends && \
    apt install -y \
    ffmpeg

# Copy the shell script into the container
COPY stream_videos.sh /usr/local/bin/

# Set execute permissions for the script
RUN chmod +x /usr/local/bin/stream_videos.sh

# Set the entrypoint to the shell script
ENTRYPOINT ["/usr/local/bin/stream_videos.sh"]
