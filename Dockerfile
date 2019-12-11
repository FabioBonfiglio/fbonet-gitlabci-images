# FBO Network GitlabCI docker images
# Copyright (C) 2019  Fabio Bonfiglio <fabio.bonfiglio@fbo.network>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

FROM ubuntu:bionic AS ubusolnode

LABEL maintainer="Fabio Bonfiglio <fabio.bonfiglio@fbo.network>"
LABEL description="This image is used as a docker executor for Gitlab CI/CD of \
Solidity smart contracts projects."

# Install dev dependencies (workaround for missing security repos)
RUN apt-get update && \
	apt-get install -y libjpeg-turbo8-dev

# Install latest solc
RUN apt-get update && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:ethereum/ethereum && \
	apt-get update && \
	apt-get install -y solc

# Install graphviz, curl, git, make, g++, php and nodejs
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/Europe/Bern /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get install -y -q graphviz curl git make g++ php && \
	curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
	apt-get install -y nodejs

# Install pandoc, latex and pdftex, with recommended fonts
RUN apt-get install -y pandoc && \
	apt-get install -y pandoc-citeproc texlive

FROM ubusolnode AS fbonetci

USER root

# Install truffle
RUN npm install -g --unsafe-perm=true --allow-root truffle && \
	npm install -g --unsafe-perm=true --allow-root @truffle/hdwallet-provider

# Install ganache-cli
RUN npm install -g --unsafe-perm=true --allow-root ganache-cli

# Install solgraph
RUN npm install -g --unsafe-perm=true --allow-root solgraph

WORKDIR /src

# Install truffle/hdwallet-provider for require hook
RUN npm install @truffle/hdwallet-provider

CMD ["/bin/bash"]
