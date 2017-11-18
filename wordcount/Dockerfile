FROM bossjones/boss-spark:latest

# inspiration:
# - https://github.com/pdonorio/dockerizing/blob/master/python/py3base/Dockerfile
# - https://github.com/pdonorio/dockerizing/blob/master/python/py3dataconda/Dockerfile
# - https://github.com/bossjones/dockerizing

LABEL Maintainer="Malcolm Jones <bossjones@theblacktonystark.com>"

# Not essential, but wise to set the lang
# RUN apt update && apt install -y language-pack-en
# ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US.UTF-8
# ENV LC_ALL en_US.UTF-8
# RUN locale-gen en_US.UTF-8
# RUN dpkg-reconfigure locales

ENV TERM=xterm-256color \
    DEBIAN_FRONTEND=noninteractive

# Python binary dependencies, developer tools
RUN apt update && \
    add-apt-repository -y ppa:jonathonf/python-3.6 && \
    apt-get update && \
    # Python 3
    apt-get -yqq install python3.6 python3.6-dev && \
    # from pdonorio/dockerizing/python/py3base
    apt install -y -q \
    aptitude \
    curl nano vim wget git \
    # Compiler libs
    build-essential make gcc \
    libssl-dev libffi-dev zlib1g-dev \
    # requested for openssl in python
    libffi-dev \
    # extras for python
    libzmq3-dev sqlite3 libsqlite3-dev \
    # python3-lxml \
    libcurl4-openssl-dev libpq-dev \
    # python3-sphinx pandoc \
    # CLEAN
    && \
    # install latest pip
    cd /tmp && \
    wget -q https://bootstrap.pypa.io/get-pip.py && \
    python3.6 get-pip.py && \
    rm *.py && \
    # now clean regular apt-get stuff
    apt-get clean && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/*.lz4 /tmp/* /var/tmp/*

# Python essential libs
# https://github.com/pdonorio/dockerizing/blob/master/python/py3base/Dockerfile
# RUN pip3.6 install --upgrade \
#     # the very base
#     setuptools pip lxml ipython \
#     # utilities
#     attrs wrapt tracestack wget httpie \
#     # cli utilities
#     plumbum paramiko invoke \
#     # pretty print
#     prettytable beeprint

COPY ./container/root /
