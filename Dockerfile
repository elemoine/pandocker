# A simple Pandoc machine for pandoc with filters, fonts and the latex bazaar
#
# Based on :
#    https://github.com/jagregory/pandoc-docker/blob/master/Dockerfile
#    https://github.com/geometalab/docker-pandoc/blob/develop/Dockerfile
#    https://github.com/vpetersson/docker-pandoc/blob/master/Dockerfile

FROM debian:latest
MAINTAINER damien clochard <daamien@gmail.com>

# Check for latest version here : 
ENV PANDOC_SOURCE https://github.com/jgm/pandoc/releases/

# Pandoc Version
ENV PANDOC_VERSION 1.19.2
ENV DEBIAN_REVISION ${PANDOC_VERSION}-1

# Set the env variables to non-interactive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes

RUN apt-get -qq update && \
    # latex toolchain 
    apt-get -qq -y install texlive texlive-xetex && \
    # fonts
    apt-get -qq -y install fonts-lato && \
    # build tools
    apt-get -qq -y install git wget tar xz-utils python-setuptools && \
    # required by pandoc-latex-tip
    apt-get -qq -y install python-imaging libjpeg62-turbo-dev libfreetype6 libfreetype6-dev && \
    # clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install pandoc 
RUN wget -O pandoc.deb ${PANDOC_SOURCE}/download/${PANDOC_VERSION}/pandoc-${DEBIAN_REVISION}-amd64.deb && \
    dpkg --install pandoc.deb

#
# Pandoc filters
#
RUN easy_install pip && \
    pip install pandocfilters \
		panflute \
                pandoc-latex-environment \
                pandoc-latex-barcode \ 
		icon_font_to_png 
 
# https://github.com/chdemko/pandoc-latex-tip/issues/1
RUN pip install git+https://github.com/chdemko/pandoc-latex-tip.git --egg


# Install wkhtmltopdf
RUN wget -O wkhtmltox.tar.xz http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz && \
    tar -xf wkhtmltox.tar.xz
ENV PATH ${PATH}:/wkhtmltox/bin

# Entrypoint
RUN mkdir /pandoc
WORKDIR /pandoc
ENTRYPOINT ["pandoc"]


