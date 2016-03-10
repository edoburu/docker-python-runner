# Extra package for projects that need `wkhtmltopdf` as well.
# TO build: docker build -t edoburu/python-runner:wkhtmltopdf .
FROM edoburu/python-runner:latest
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		fontconfig libicu52 libx11-6 libxext6 libxrender1 libxcb1 xfonts-base xfonts-75dpi && \
	python -c 'import urllib; urllib.urlretrieve("https://bitbucket.org/wkhtmltopdf/wkhtmltopdf/downloads/wkhtmltox-0.13.0-alpha-7b36694_linux-jessie-amd64.deb", "wkhtmltox.dpkg")' && \
	dpkg -i wkhtmltox.dpkg && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/debconf/*-old
