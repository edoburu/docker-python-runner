Python Runner for Docker
========================

This image can be used to run a Python project (e.g. unit tests)
and install Python packages that require C-extensions.

The image consists of a base Debian jessie install,
with both Python 2.7, Python 3.6 and development packages added
to install projects such as: : ``Pillow``, ``psycopg2``, ``pylibmc``,
``lxml``, ``cffi``, ``reportlab``.

Python system packages are kept to a minimum, with only
``pip``, ``setuptools``, ``wheel`` and ``virtualenv`` installed system-wide.
A minimalistic ``git`` install is present too, to support ``pip install -e git+...``.

We use this docker image to install, unittest and deploy projects via GitLab.
All pip built wheels are stored in the ``/cache`` dir,
which is the default volume in GitLab where persistent storage is mounted.

Building the containers
-----------------------

.. code-block:: bash

    make all
    make push

Usage in GitLab
---------------

You can use the container in the ``.gitlab-ci.yml`` file:

.. code-block:: yaml

    image: edoburu/python-runner:base

    # The test build
    test:
      type: test
      script:
      - virtualenv env
      - source env/bin/activate
      - pip install -r src/requirements.txt
      - ./src/runtests.py

The virtualenv is not really needed as the image is already clean.
However, it makes sure the packages are installed in the ``/build`` folder,
which makes it easier to debug failed builds later.

Deployment
~~~~~~~~~~

For deployment, you can use the other image types:

.. code-block:: yaml

    # Deploy to test server
    deploy_beta:
      image: edoburu/python-runner:ansible
      stage: deploy
      script:
      - cd deployment
      - ansible-playbook deploy.yml --limit="$CI_BUILD_REF_NAME" --extra-vars="git_branch=$CI_BUILD_REF"
      only:
      - beta

    # Export documentation
    upload_docs:
      image: edoburu/python-runner:sphinx
      stage: deploy
      script:
      - cd docs
      - make html
      - rsync -av --delete _build/html/ /exported/docs/$(basename $CI_PROJECT_DIR)

An easy way to make sure the Docker process can access SSH keys,
is by exposing them via a mounted volume.
For example, add to ``config.toml``:

.. code-block:: INI

    [[runners]]
        executor = "docker"
        # ...

        [runners.docker]
          # The default image, if none specified
          image = "edoburu/python-runner"

          # Make sure the image can't become root on the host machine
          # Accessed files must be owned by the user Docker runs as.
          privileged = false
          cap_drop = ["DAC_OVERRIDE"]

          # Share pip cache files, provide deployment key
          volumes = [
              "/cache",
              "/sites/docs/public_html:/exported/docs:rw",
              "/home/deploy/.ssh/:/root/.ssh:ro"
          ]
