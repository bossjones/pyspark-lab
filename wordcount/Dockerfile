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

ENV TERM=xterm-256color
#  \
#     DEBIAN_FRONTEND=noninteractive

# sed -i "s@^#precedence ::ffff:0:0/96  100@precedence ::ffff:0:0/96  100@" /etc/gai.conf; \
#     apt-get update && \
#     # install apt-fast and other deps
#     apt-get -y upgrade && \
#     apt-get install -y \
#     language-pack-en-base && \
#     apt-get clean && \
#     apt-get autoclean -y && \
#     apt-get autoremove -y && \
#     rm -rf /var/lib/{cache,log}/ && \
#     rm -rf /var/lib/apt/lists/*.lz4 /tmp/* /var/tmp/* && \
#     # Set locale (fix the locale warnings)
#     locale-gen en_US.UTF-8 && \
#     localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || : && \
#     export LANG=en_US.UTF-8 && \
#     export LC_ALL=en_US.UTF-8 && \
#     PATH=/usr/local/bin:/usr/local/sbin:$PATH && \
#     set -x \
#     apt-get update && \
#     apt-get install -y software-properties-common && \
#     add-apt-repository -y ppa:saiarcot895/myppa && \
#     apt-get update && \

# Python binary dependencies, developer tools
    RUN set -x \
    sed -i "s@^#precedence ::ffff:0:0/96  100@precedence ::ffff:0:0/96  100@" /etc/gai.conf; \
    apt-get update && \
    apt-get install -yqq software-properties-common python3-software-properties && \
    add-apt-repository -y ppa:jonathonf/python-3.6 && \
    apt-get update && \
    # Python 3
    apt-get -yqq install python3.6 python3.6-dev && \
    # from pdonorio/dockerizing/python/py3base
    apt-get install -yqq \
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
    if [ ! -e /usr/bin/pip3 ]; then : \
        && wget -O /tmp/get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
        && python3 /tmp/get-pip.py "pip" \
        && rm /tmp/get-pip.py \
    ; fi \
    && \
    pip install --no-cache-dir --upgrade --force-reinstall "pip" && \
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

RUN ls -lta /tests && goss -g /tests/wordcount/ubuntu.goss.yaml validate
