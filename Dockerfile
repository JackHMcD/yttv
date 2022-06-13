FROM arm32v7/rust:slim-bullseye AS geckodriver
RUN apt-get update && apt-get install -y --no-install-recommends curl wget \
    && curl -sSLO https://github.com/jamesmortensen/geckodriver-arm-binaries/releases/download/v0.31.0/geckodriver-v0.31.0-linux-armv7l.tar.gz \
    && tar -zxf geckodriver-*.tar.gz \
    && rm -rf /var/lib/apt/lists/*

FROM arm32v7/python:3.9-slim-bullseye
ENV PYTHONUNBUFFERED=1 \
    WEBDRIVER_PATH="/usr/local/bin/geckodriver" \
    FIREFOX_BIN="/usr/bin/firefox"
COPY --from=geckodriver /geckodriver /usr/local/bin
RUN --mount=type=cache,target=/root/.cache/pip \
    buildDeps='gcc python-dev' \
    && set -x \
    && apt-get update && apt-get install -y --no-install-recommends $buildDeps firefox-esr libpq-dev  \
    && pip install --no-cache-dir Scrapy selenium scrapy-selenium itemloaders itemadapter \
    psycopg2 SQLAlchemy pandas rq redis python-dotenv python-dateutil \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/*

# Copy Source Code
WORKDIR /app
COPY yttv.py .
ADD ./entrypoint.sh /entrypoint.sh

WORKDIR /app
ENTRYPOINT /entrypoint.sh
