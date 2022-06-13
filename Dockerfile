FROM arm32v7/python:3.9-slim-bullseye
ENV PYTHONUNBUFFERED=1 \
    WEBDRIVER_PATH="/usr/local/bin/geckodriver" \
    FIREFOX_BIN="/usr/bin/firefox"
RUN --mount=type=cache,target=/root/.cache/pip \
    buildDeps='gcc python-dev' \
    && set -x \
    && apt-get update && apt-get install -y --no-install-recommends $buildDeps firefox-esr libpq-dev curl  \
    && curl -sSLO https://github.com/jamesmortensen/geckodriver-arm-binaries/releases/download/v0.31.0/geckodriver-v0.31.0-linux-armv7l.tar.gz \
    && tar -zxf geckodriver-*.tar.gz \
    && mv geckodriver /usr/local/bin \
    && pip install --no-cache-dir Scrapy selenium==4.2.0 scrapy-selenium itemloaders itemadapter \
    psycopg2 SQLAlchemy pandas rq redis python-dotenv python-dateutil \
    async-generator atomicwrites attrs certifi cffi colorama cryptography h11 \
    idna iniconfig outcome packaging pluggy py pycparser pyopenssl pyparsing pysocks requests \
    sniffio sortedcontainers tomli trio trio-websocket urllib3 wsproto --index-url https://www.piwheels.org/simple \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/*

# Copy Source Code
WORKDIR /app
COPY yttv.py .
ADD ./entrypoint.sh /entrypoint.sh

WORKDIR /app
ENTRYPOINT /entrypoint.sh
