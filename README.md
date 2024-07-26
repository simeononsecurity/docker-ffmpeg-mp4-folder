# MP4 Streamer for Twitch, YouTube, and Kick

[![Sponsor](https://img.shields.io/badge/Sponsor-Click%20Here-ff69b4)](https://github.com/sponsors/simeononsecurity) 

This Docker container allows you to stream MP4 and MKV files directly to Twitch.tv, YouTube, and Kick (or a similar platform) using `ffmpeg`. It supports streaming the files in the specified directory once or looping indefinitely.

## Usage

1. **Build the Docker image:**

    ```bash
    docker build -t mp4-streamer .
    ```

2. **Run the Docker container with looping:**

    To stream your MP4 files in a continuous loop, you can set the `LOOP_INDEFINITELY` environment variable to `true`. 

    ```bash
    docker run -td --restart unless-stopped -v /path/to/mp4/files:/videos -e TWITCH_STREAM_KEY=<your_twitch_stream_key> -e YOUTUBE_STREAM_KEY=<your_youtube_stream_key> -e KICK_STREAM_URL=<your_kick_stream_url> -e KICK_STREAM_KEY=<your_kick_stream_key> -e VIDEO_DIR=/videos -e LOOP_INDEFINITELY=true mp4-streamer
    ```

    For a single run through your MP4 files without looping, omit the `LOOP_INDEFINITELY` variable or set it to `false`.

    ```bash
    docker run -td --restart unless-stopped -v /path/to/mp4/files:/videos -e TWITCH_STREAM_KEY=<your_twitch_stream_key> -e YOUTUBE_STREAM_KEY=<your_youtube_stream_key> -e KICK_STREAM_URL=<your_kick_stream_url> -e KICK_STREAM_KEY=<your_kick_stream_key> -e VIDEO_DIR=/videos mp4-streamer
    ```

    Replace `/path/to/mp4/files` with the directory path containing your MP4 files, `<your_twitch_stream_key>`, `<your_youtube_stream_key>`, `<your_kick_stream_url>`, and `<your_kick_stream_key>` with your respective streaming credentials.

3. **Streaming Options:**

    - **MP4 Files:** Mount your directory containing MP4 files to `/videos` in the container.
    - **Twitch Stream Key:** Set your Twitch stream key as an environment variable `TWITCH_STREAM_KEY`.
    - **YouTube Stream Key:** Set your YouTube stream key as an environment variable `YOUTUBE_STREAM_KEY`.
    - **Kick Stream URL and Key:** Set your Kick stream URL and key as environment variables `KICK_STREAM_URL` and `KICK_STREAM_KEY`, respectively.
    - **Loop Indefinitely:** Optionally, set `LOOP_INDEFINITELY=true` to loop through the video files indefinitely. Default behavior is a single run without looping.

## Dockerfile Details

- Based on Ubuntu latest image.
- Installs `ffmpeg` and other necessary dependencies for streaming.
- Utilizes a custom script `stream_videos.sh` as the entrypoint to facilitate streaming to Twitch, YouTube, and Kick using `ffmpeg`. This script supports looping through the MP4 files indefinitely or streaming them once based on the `LOOP_INDEFINITELY` environment variable.

## License

This Dockerfile and the accompanying scripts are licensed under the [MIT License](LICENSE).

## Website
- For more information and updates, visit [simeononsecurity.com](https://simeononsecurity.com).
