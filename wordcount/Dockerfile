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
    MESOS_DIRECTORY=/tmp \
    NOT_ROOT_USER_HOME=/home/${NOT_ROOT_USER} \
    MAIN_DIR=${SPARK_HOME}

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

############################[BEGIN - USER]##############################################
# FIXME: investigate secure_path: http://manpages.ubuntu.com/manpages/zesty/man5/sudoers.5.html
# NOTE: umask 077 -> allow read, write, and execute permission for the file's owner, but prohibit read, write, and execute permission for everyone else
# NOTE: The file mode creation mask is initialized to this value. If not specified, the mask will be initialized to 022.
# Source: http://manpages.ubuntu.com/manpages/xenial/man8/useradd.8.html
# FIXME: Look at this guy: https://hub.docker.com/r/radmas/mtc-plus-fpm/~/dockerfile/
# RUN set -xe \
#     && useradd -U -d ${NOT_ROOT_USER_HOME} -m -r -G adm,sudo,dip,plugdev,tty,audio ${NOT_ROOT_USER} \
#     && usermod -a -G ${NOT_ROOT_USER} -s /bin/bash -u ${UID} ${NOT_ROOT_USER} \
#     && groupmod -g ${UID} ${NOT_ROOT_USER} \
#     && chown -hR ${NOT_ROOT_USER}:${NOT_ROOT_USER} ${MAIN_DIR} \
#     && echo "${NOT_ROOT_USER}     ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
#     && echo "%${NOT_ROOT_USER}     ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
#     && cat /etc/sudoers \
#     && echo "${NOT_ROOT_USER}:raspberry" | chpasswd

# This step will need to be completed on all the servers. We need to install the package dependencies for mesos.

# sudo apt install -y openjdk-8-jdk
# sudo apt -y install build-essential python-dev libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev
# sudo apt install unzip

# Python binary dependencies, developer tools
    RUN set -xe \
    # && useradd -U -d ${NOT_ROOT_USER_HOME} -m -r -G adm,sudo,dip,plugdev,tty,audio ${NOT_ROOT_USER} \
    # && groupadd -g ${UID} ${NOT_ROOT_USER} \
    # && usermod -a -G ${NOT_ROOT_USER} -s /bin/bash -u ${UID} ${NOT_ROOT_USER} \
    # && groupmod -g ${UID} ${NOT_ROOT_USER} \
    # && chown -hR ${NOT_ROOT_USER}:${NOT_ROOT_USER} ${MAIN_DIR} \
    # && echo "${NOT_ROOT_USER}     ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    # && echo "%${NOT_ROOT_USER}     ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    # && cat /etc/sudoers \
    # && echo "${NOT_ROOT_USER}:raspberry" | chpasswd \
    sed -i "s@^#precedence ::ffff:0:0/96  100@precedence ::ffff:0:0/96  100@" /etc/gai.conf; \
    apt-get update && \
    # apt-get install -yqq software-properties-common python3-software-properties && \
    # add-apt-repository -y ppa:jonathonf/python-3.6 && \
    # apt-get update && \
    # # Python 3
    # apt-get -yqq install python3.6 python3.6-dev && \
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
    chown root:root -R ${SPARK_HOME} && \
    # now clean regular apt-get stuff
    apt-get clean && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/*.lz4 /tmp/* /var/tmp/*

COPY ./container/root /

####################################################################################
# source: https://github.com/ActivisionGameScience/ags_conda_recipes
# current error:
# Fetching package metadata .....
# WARNING: The remote server could not find the noarch directory for the
# requested channel with url: https://conda.anaconda.org/confluent-kafka

# It is possible you have given conda an invalid channel. Please double-check
# your conda configuration using `conda config --show`.

# If the requested url is in fact a valid conda channel, please request that the
# channel administrator create `noarch/repodata.json` and associated
# `noarch/repodata.json.bz2` files, even if `noarch/repodata.json` is empty.
# $ mkdir noarch
# $ echo '{}' > noarch/repodata.json
# $ bzip2 -k noarch/repodata.json
# ..........
# Solving package specifications: .

# UnsatisfiableError: The following specifications were found to be in conflict:
# - pykafka -> python 3.4* -> xz 5.0.5
# - python 3.6*
# Use "conda info <package>" to see the dependencies for each package.

# RUN cp -a /scripts/.condarc /root/.condarc && \
#     conda update --all && \
#     conda install jinja2 git conda-build anaconda-client
####################################################################################

# Python essential libs
# https://github.com/pdonorio/dockerizing/blob/master/python/py3base/Dockerfile
RUN conda update --all && \
    conda install jinja2 git conda-build anaconda-client && \
    # install and compile libkafka
    # ldconfig gets around LD_LIBRARY_PATH issue:
    # issue: https://github.com/confluentinc/confluent-kafka-python/issues/65
    # https://unix.stackexchange.com/questions/354295/what-is-the-default-value-of-ld-library-path
    git clone https://github.com/edenhill/librdkafka /usr/local/src/librdkafka && \
    cd /usr/local/src/librdkafka && \
    git checkout v0.11.1 && \
    ./configure && \
    make && \
    make install && \
    ldconfig && \
    /opt/conda/bin/pip install --upgrade \
    # the very base
    setuptools pip lxml ipython \
    # utilities
    attrs wrapt tracestack wget httpie \
    # cli utilities
    plumbum paramiko invoke \
    # pretty print
    prettytable beeprint confluent-kafka

###############################
## A little Docker magic here

# Force bash always
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
# Default conda installation
# This is how you will activate this conda environment
ENV CONDA_ENV_PATH=/opt/conda
ENV MY_CONDA_PY3ENV="python36"
ENV CONDA_ACTIVATE="source $CONDA_ENV_PATH/bin/activate $MY_CONDA_PY3ENV"
# ENV CONDA_ACTIVATE=". $CONDA_ENV_PATH/bin/activate $MY_CONDA_PY3ENV"
ENV PATH=$CONDA_ENV_PATH/bin:$PATH

###############################
# (mini)CONDA package manager

###############################
# Extra libs
# Needed by matplotlib inline
# Needed by howdoi
RUN apt-get update && \
    apt-get install -yqq \
    python-qt4 \
    libxml2-dev libxslt-dev \
    mesos netcat

###############################
# Install PyData modules and IPython dependencies
# WORKDIR /tmp

# python 3.6 conda
RUN conda create -y -n $MY_CONDA_PY3ENV python=3.6 && \
    conda update --quiet --yes conda \
    && \
    conda install -y -n $MY_CONDA_PY3ENV \
    pip jupyter ipython notebook ipywidgets \
    six sqlalchemy cython pyzmq statsmodels \
    theano tornado jinja2 sphinx pygments readline openpyxl xlrd \
    && \
    conda install -y -n $MY_CONDA_PY3ENV \
    numpy scipy pandas scikit-learn sympy \
    matplotlib seaborn bokeh \
    && \
    conda clean -y -t

# RUN conda install -c confluent-kafka pykafka

###############################
# Add other libraries not found in anaconda
RUN $CONDA_ACTIVATE && \
    pip install howdoi cheat && \
    conda install -y numpy pandas pip setuptools && \
    conda install -c conda-forge pyspark && \
    conda install -y py4j && \
    pip install pdbpp gnureadline pydocstyle autopep8 pylint coverage flake8 confluent-kafka && \
    git clone https://github.com/bossjones/boss-cheatsheets.git ~/.cheat
    # Note: this is how you use the conda pip instead of the existing one

###############################
# Script: Activate virtualenv and launch notebook
ENV STARTSCRIPT=/opt/start \
    CHEATCOLORS=true
#RUN source activate $MY_CONDA_PY3ENV \
RUN echo "#!/bin/bash" > $STARTSCRIPT \
    && echo "$CONDA_ACTIVATE" >> $STARTSCRIPT \
    && echo -e "# install kernels\npython3 -m ipykernel.kernelspec" >> $STARTSCRIPT \
    && echo -e "# launch notebook\njupyter notebook --ip=0.0.0.0 --no-browser" >> $STARTSCRIPT \
    && chmod +x $STARTSCRIPT

# \
# && cp -a /scripts/pyspark_vars.sh /opt/conda/envs/python36/etc/conda/activate.d/pyspark_vars.sh

# grab the appropriate jars from maven
# RUN cd ${HADOOP_HOME}/share/hadoop/tools/lib && \
#     curl --retry 3 -sSL -O http://central.maven.org/maven2/org/apache/spark/spark-streaming-kafka-assembly_2.11/1.6.3/spark-streaming-kafka-assembly_2.11-1.6.3.jar

# WORKDIR /data

RUN mkdir /jars && \
    cd /jars && \
    curl --retry 3 -SL http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.39/mysql-connector-java-5.1.39.jar -o /jars/mysql-connector-java-5.1.39.jar && \
    curl --retry 3 -sSL -O http://central.maven.org/maven2/org/apache/spark/spark-streaming-kafka-0-8-assembly_2.11/2.2.0/spark-streaming-kafka-0-8-assembly_2.11-2.2.0.jar

# http://central.maven.org/maven2/org/apache/spark/spark-streaming-kafka-0-8-assembly_2.11/2.2.0/spark-streaming-kafka-0-8-assembly_2.11-2.2.0.jar

# http://central.maven.org/maven2/org/apache/spark/spark-streaming-kafka-0-8_2.11/2.2.0/spark-streaming-kafka-0-8_2.11-2.2.0.jar

# # Move this into spark
# ENV MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so

# Overlay the root filesystem from this repo
COPY . /app

RUN cp -a /app/conf/log4j.properties $SPARK_HOME/conf/log4j.properties

RUN ls -lta /tests && goss -g /tests/wordcount/ubuntu.goss.yaml validate
