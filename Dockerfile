# This file builds a base container with all Python development packages installed.
#
# This should be sufficient to install a Python project with C-extensions
# such as: Pillow, psycopg2, pylibmc, lxml, cffi, reportlab
#
# We use this docker image to install, unittest and deploy projects via GitLab.
# The /cache dir is typically connected to a shared cache on GitLab.
#
# General help: https://docs.docker.com/engine/userguide/containers/dockerimages/
# Building the container: `docker build -t edoburu/docker-python-runner .`
# NOTE that each RUN instruction creates a new image layer

FROM debian:jessie
MAINTAINER opensource@edoburu.nl
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_CACHE_DIR=/cache
RUN mkdir -p /cache && \
	apt-get update && \
	apt-get install --no-install-recommends -y \
		python python3 \
		python-pip python-virtualenv virtualenv \
		git-core gettext curl \
		gcc libffi-dev libmemcached-dev libpq-dev libssl-dev libxml2-dev libxslt1-dev python-dev python3-dev && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists && \
	pip install -U pip wheel setuptools
