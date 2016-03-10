# This file builds a base container with all Python development packages installed.
#
# This should be sufficient to install a Python project with C-extensions
# such as: Pillow, psycopg2, pylibmc, lxml, cffi, reportlab
#
# We use this docker image to install, unittest and deploy projects via GitLab.
# The /cache dir is typically connected to a shared cache on GitLab.
#
# Building the container: `docker build -t edoburu/python-runner .`
# Help to get started:
#   https://docs.docker.com/engine/userguide/containers/dockerimages/
#   https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/
#
# NOTE:
# - The apt cache is not present in the base image, hence the call to apt-get update.
# - Each RUN instruction creates a new image layer, hence the single RUN command that combines all steps.
# - Many unneeded files are removed afterwards to keep the image size smaller.
# - Git is extracted over the filesystem to avoid perl dependencies, avoiding another 100MB.

FROM debian:jessie
MAINTAINER opensource@edoburu.nl
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_CACHE_DIR=/cache
RUN mkdir -p /cache && \
	sh -c 'echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup' && \
	sh -c 'echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache' && \
	sh -c 'echo 'Acquire::Languages "none;"' > /etc/apt/apt.conf.d/no-lang' && \
	apt-get update && \
	apt-get install --no-install-recommends -y \
		python python3 python-setuptools python3-setuptools \
		make gcc libffi-dev libgeoip1 libjpeg-dev libmemcached-dev libpq-dev libssl-dev libxml2-dev libxslt1-dev python-dev python3-dev \
		libcurl3-gnutls ca-certificates && \
	apt-get download git && dpkg -x git_* / && rm git_* && \
	apt-get clean && \
	cp -R /usr/share/locale/en\@* /tmp/ && rm -rf /usr/share/locale/* && mv /tmp/en\@* /usr/share/locale/ && \
    rm -rf /usr/share/doc/* /var/lib/apt/lists/* /var/cache/debconf/*-old

# Make sure the latest pip is installed, not the 1.5.6 version from Debian
# This also results in a very clean system-packages folder, making virtualenv almost unneeded
# This is done as separate layer to make it easy to reconfigure this.
RUN easy_install3 pip virtualenv wheel && easy_install-2.7 pip virtualenv wheel && pip install -U setuptools && pip3 install -U setuptools
