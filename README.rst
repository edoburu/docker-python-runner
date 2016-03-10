Python Runner for Docker
========================

This image can be used to run a Python project (e.g. unit tests)
and install Python packages that require C-extensions.

All packages are available to install projects
such as: ``Pillow``, ``psycopg2``, ``pylibmc``, ``lxml``, ``cffi``, ``reportlab``.

The image consists of a base Debian jessie install,
with Both Python 2.7, Python 3.4 and development packages added.
Python system packages are kept to a minimum, with only
``pip``, ``setuptools``, ``wheel`` and ``virtualenv`` installed system-wide.
A minimalistic ``git`` install is present too, to support ``pip install -e git+...``.

We use this docker image to install, unittest and deploy projects via GitLab.
All pip built wheels are stored in the ``/cache`` dir,
which is the default volume in GitLab where persistent storage is mounted.

Building the containers
-----------------------

::

    docker build -t edoburu/python-runner:base base/
    docker build -t edoburu/python-runner:wkhtmltopdf wkhtmltopdf/
    docker tag edoburu/python-runner:base edoburu/python-runner:latest

Updating on dockerhub::

    docker login
    docker push edoburu/python-runner:base
    docker push edoburu/python-runner:latest
    docker push edoburu/python-runner:wkhtmltopdf

Usage in GitLab
---------------

You can use the container in the ``.gitlab-ci.yml`` file::

    image: edoburu/python-runner:base

    # The test build
    test:
      type: test
      script:
      - pip install --src=/ -r src/requirements.txt
      - ./src/runtests.py

The ``--src`` argument avoids installing the editable packages in the current folder,
avoiding conflicts with your current build directory.
You may also choose to install a virtualenv first,
though the limited system-wide packages avoid this need.

