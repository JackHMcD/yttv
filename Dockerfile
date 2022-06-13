FROM arm32v7/debian:bullseye-slim

COPY install-packages.sh .
RUN ["chmod", "+x", "install-packages.sh"]
RUN ./install-packages.sh

ENV GECKODRIVER_VER v0.31.0

# Add geckodriver
RUN set -x \
   && curl -sSLO https://github.com/jamesmortensen/geckodriver-arm-binaries/releases/download/${GECKODRIVER_VER}/geckodriver-${GECKODRIVER_VER}-linux-armv7l.tar.gz \
   && tar zxf geckodriver-*.tar.gz \
   && mv geckodriver /usr/local/bin/

# Copy Source Code
WORKDIR /app
COPY yttv.py .
ADD ./entrypoint.sh /entrypoint.sh

WORKDIR /app
ENTRYPOINT /entrypoint.sh
