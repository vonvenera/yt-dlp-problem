#!/bin/sh
set -e

CHANNEL=${YTDLP_CHANNEL:-stable}

echo "Updating yt-dlp channel: $CHANNEL"

if [ "$CHANNEL" = "stable" ]; then
    yt-dlp -U || true
else
    yt-dlp --update-to "$CHANNEL" || true
fi

exec yt-dlp "$@"