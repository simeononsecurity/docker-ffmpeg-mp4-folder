# MP4 Streamer for Twitch and YouTube

This Docker container allows you to stream MP4 files directly to Twitch.tv and YouTube using `ffmpeg`.

## Usage

1. **Build the Docker image:**

    ```bash
    docker build -t mp4-streamer .
    ```

2. **Run the Docker container:**

    ```bash
    docker run -td --restart unless-stopped -v /path/to/mp4/files:/videos -e TWITCH_STREAM_KEY=<your_twitch_stream_key> -e YOUTUBE_STREAM_KEY=<your_youtube_stream_key> -e VIDEO_DIR=/videos mp4-streamer
    ```

    Replace `/path/to/mp4/files` with the directory path containing your MP4 files, `<your_twitch_stream_key>` with your actual Twitch stream key, and `<your_youtube_stream_key>` with your YouTube stream key.

3. **Streaming Options:**

    - **MP4 Files:** Mount your directory containing MP4 files to `/videos` in the container.
    - **Twitch Stream Key:** Set your Twitch stream key as an environment variable `TWITCH_STREAM_KEY`.
    - **YouTube Stream Key:** Set your YouTube stream key as an environment variable `YOUTUBE_STREAM_KEY`.

## Dockerfile Details

- Based on Ubuntu latest image.
- Installs `ffmpeg` and other necessary dependencies.
- Uses `stream_videos.sh` script as the entrypoint to simultaneously stream MP4 files to Twitch and YouTube using `ffmpeg`

## License

This Dockerfile is licensed under the [MIT License](LICENSE).

