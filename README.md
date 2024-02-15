# MP4 Streamer for Twitch, YouTube, and Kick

This Docker container allows you to stream MP4 files directly to Twitch.tv, YouTube, and Kick (or a similar platform) using `ffmpeg`.

## Usage

1. **Build the Docker image:**

    ```bash
    docker build -t mp4-streamer .
    ```

2. **Run the Docker container:**

    ```bash
    docker run -td --restart unless-stopped -v /path/to/mp4/files:/videos -e TWITCH_STREAM_KEY=<your_twitch_stream_key> -e YOUTUBE_STREAM_KEY=<your_youtube_stream_key> -e KICK_STREAM_URL=<your_kick_stream_url> -e KICK_STREAM_KEY=<your_kick_stream_key> -e VIDEO_DIR=/videos mp4-streamer
    ```

    Replace `/path/to/mp4/files` with the directory path containing your MP4 files, `<your_twitch_stream_key>` with your actual Twitch stream key, `<your_youtube_stream_key>` with your YouTube stream key, `<your_kick_stream_url>` with your Kick stream URL, and `<your_kick_stream_key>` with your Kick stream key.

3. **Streaming Options:**

    - **MP4 Files:** Mount your directory containing MP4 files to `/videos` in the container.
    - **Twitch Stream Key:** Set your Twitch stream key as an environment variable `TWITCH_STREAM_KEY`.
    - **YouTube Stream Key:** Set your YouTube stream key as an environment variable `YOUTUBE_STREAM_KEY`.
    - **Kick Stream URL and Key:** Set your Kick stream URL and key as environment variables `KICK_STREAM_URL` and `KICK_STREAM_KEY`, respectively.

## Dockerfile Details

- Based on Ubuntu latest image.
- Installs `ffmpeg` and other necessary dependencies.
- Uses `stream_videos.sh` script as the entrypoint to stream MP4 files to Twitch, YouTube, and Kick (or similar platforms) using `ffmpeg`.

## Notes

- Ensure all stream keys and URLs are kept confidential and secure.
- The Kick platform streaming options can be used to stream to any RTMP(S) server. Specify the kick stream url and kick stream key with whatever you feel like.
## License

This Dockerfile is licensed under the [MIT License](LICENSE).

## Website
- [simeononsecurity.com](https://simeononsecurity.com)
