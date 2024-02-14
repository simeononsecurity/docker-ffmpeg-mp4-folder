FROM ubuntu:latest

# Set Labels
LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/docker-ffmpeg-mp4-folder"
LABEL org.opencontainers.image.description="Streams to Twich.TV from a folder of mp4 files"
LABEL org.opencontainers.image.authors="simeononsecurity"

# Set ENV Variables
ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV TERM=xterm

# Install necessary dependencies
RUN apt update && \
    apt full-upgrade -y --no-install-recommends && \
    apt install -y \
    ffmpeg \
    x11vnc \
    xvfb \
    fluxbox \
    wget \
    libxcb-shm0 \
    libxcb-shape0 \
    libxcb-xfixes0 \
    libxcb-randr0 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-icccm4 \
    libxcb-xinerama0 \
    libxcb-render-util0 \
    libxcb-xkb1 \
    libxkbcommon-x11-0

# Set the entrypoint to the ffmpeg command
ENTRYPOINT ["ffmpeg", "-stream_loop", "-1", "-re", "-i", "/videos/*.mp4", "-c:v", "libx264", "-preset", "veryfast", "-maxrate", "3000k", "-bufsize", "6000k", "-vf", "scale=1280:-1", "-g", "50", "-c:a", "aac", "-b:a", "128k", "-ar", "44100", "-f", "flv", "rtmp://live.twitch.tv/app/$TWITCH_STREAM_KEY"]
