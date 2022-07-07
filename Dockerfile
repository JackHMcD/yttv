FROM arm32v7/python:3.9-slim-bullseye
ENV PYTHONUNBUFFERED=1 \
    WEBDRIVER_PATH="/usr/local/bin/geckodriver" \
    FIREFOX_BIN="/usr/bin/firefox"
RUN --mount=type=cache,target=/root/.cache/pip \
    buildDeps='gcc python-dev' \
    && set -x \
    && apt-get update && apt-get install -y --no-install-recommends $buildDeps firefox-esr libx11-xcb1 libdbus-glib-1-2 packagekit-gtk3-module pulseaudio pulseaudio-utils curl \
    && curl -sSLO https://github.com/jamesmortensen/geckodriver-arm-binaries/releases/download/v0.31.0/geckodriver-v0.31.0-linux-armv7l.tar.gz \
    && tar -zxf geckodriver-*.tar.gz \
    && mv geckodriver /usr/bin \
    && pip install --no-cache-dir selenium==4.0.0a6.post2 \
    async-generator atomicwrites attrs certifi cffi colorama cryptography h11 \
    idna iniconfig outcome packaging pluggy py pycparser pyopenssl pyparsing pysocks requests \
    six sniffio sortedcontainers tomli trio trio-websocket urllib3 wsproto --index-url https://www.piwheels.org/simple \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/*

# Copy Source Code
WORKDIR /app
COPY yttv.py .
ADD ./entrypoint.sh /entrypoint.sh

WORKDIR /app
ENTRYPOINT /entrypoint.sh
