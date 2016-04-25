# Extra package for projects that need to run `Sphinx` to build documentation.
#
# This image layer adds some additional packages needed for our deploys,
# and by building on top of the existing python-runner the layer size stays small.
#
# TO build: docker build -t edoburu/python-runner:sphinx .
#
# The generated docs can be exported to a mounted volume using rsync.

FROM edoburu/python-runner:base
RUN apt-get update && \
    apt-get install -y --no-install-recommends rsync graphviz libgraphviz-dev fonts-liberation && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/debconf/*-old && \
    pip install --no-cache-dir Sphinx sphinx_rtd_theme
