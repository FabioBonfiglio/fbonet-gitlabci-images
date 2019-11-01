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

# Install latest solc
RUN apt-get update && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:ethereum/ethereum && \
	apt-get update && \
	apt-get install -y solc

# Install graphviz, curl, git, make, g++, nodejs, truffle and solgraph
RUN apt-get install -y graphviz curl git make g++ && \
	curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
	apt-get install -y nodejs

FROM ubusolnode AS fbonetci

USER root

RUN npm install -g --unsafe-perm=true --allow-root truffle && \
	npm install -g --unsafe-perm=true --allow-root @truffle/hdwallet-provider
	
RUN npm install -g --unsafe-perm=true --allow-root solgraph
	
WORKDIR /src

CMD ["/bin/bash"]
