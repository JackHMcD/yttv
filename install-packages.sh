#!/bin/bash

# Bash "strict mode", to help catch problems and bugs in the shell
# script. Every bash script you write should include this. See
# http://redsymbol.net/articles/unofficial-bash-strict-mode/ for
# details.
set -euo pipefail

# Tell apt-get we're never going to be able to give manual
# feedback:
export DEBIAN_FRONTEND=noninteractive

# Update the package listing, so we know what package exist:
apt-get update

# Install security updates:
apt-get -y upgrade

# Install a new package, without unnecessary recommended packages:
apt-get -y install --no-install-recommends libx11-xcb1 libdbus-glib-1-2 packagekit-gtk3-module python pip pulseaudio pulseaudio-utils curl firefox-esr

pip install async-generator atomicwrites attrs certifi cffi colorama cryptography h11 idna iniconfig outcome packaging pluggy py pycparser pyopenssl pyparsing pysocks requests selenium sniffio sortedcontainers tomli trio trio-websocket urllib3 wsproto --index-url https://www.piwheels.org/simple

# Delete cached files we don't need anymore (note that if you're
# using official Docker images for Debian or Ubuntu, this happens
# automatically, you don't need to do it yourself):
apt-get clean
# Delete index files we don't need anymore:
rm -rf /var/lib/apt/lists/*
