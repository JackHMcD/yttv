FROM --platform=$BUILDPLATFORM arm32v7/rust:slim-bullseye AS geckodriver
RUN apt-get update && apt-get install -y --no-install-recommends curl wget \
    && GECKODRIVER_VERSION=`curl https://github.com/mozilla/geckodriver/releases/latest | grep -oE '[0-9]+.[0-9]+.[0-9]+'` \
    && wget https://github.com/jamesmortensen/geckodriver-arm-binaries/releases/download/${GECKODRIVER_VERSION}/geckodriver-${GECKODRIVER_VERSION}-linux-armv7l.tar.gz \ \
    && tar -zxf geckodriver.tar.gz \
    && cd geckodriver-$GECKODRIVER_VERSION \
    && cargo build --release \
    && cp target/release/geckodriver / \
    && rm -rf /var/lib/apt/lists/*

FROM --platform=$BUILDPLATFORM arm32v7/python:3.9-slim-bullseye
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
