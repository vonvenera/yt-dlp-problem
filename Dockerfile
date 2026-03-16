FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        ffmpeg \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    -o /usr/local/bin/yt-dlp && \
    chmod +x /usr/local/bin/yt-dlp

WORKDIR /downloads

RUN printf '#!/bin/sh\n\
set -e\n\
CHANNEL=${YTDLP_CHANNEL:-master}\n\
echo "Updating yt-dlp channel: $CHANNEL"\n\
if [ "$CHANNEL" = "stable" ]; then\n\
  yt-dlp -U || true\n\
else\n\
  yt-dlp --update-to "$CHANNEL" || true\n\
fi\n\
exec yt-dlp "$@"\n' > /entrypoint.sh \
 && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]