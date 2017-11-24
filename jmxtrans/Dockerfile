FROM openjdk:8

# source: https://github.com/dvpe/MonitoringJVM/tree/5ca9003a8ba8ffe4446ac91fd9b7151e3089645c

LABEL Maintainer="Malcolm Jones <bossjones@theblacktonystark.com>"

ENV JVMTOP_VERSION=0.8.0 \
    GOSS_VERSION=v0.3.4 \
    JMXTRANS_VERSION=268

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
&& wget http://central.maven.org/maven2/org/jmxtrans/jmxtrans/${JMXTRANS_VERSION}/jmxtrans-${JMXTRANS_VERSION}.deb \
&& dpkg -i jmxtrans-${JMXTRANS_VERSION}.deb

COPY run-jmxtrans.sh /run-jmxtrans.sh
RUN chmod 755 /run-jmxtrans.sh

CMD /run-jmxtrans.sh

# source: https://fabianlee.org/2017/02/20/monitoring-java-jmx-exploration-from-the-console-using-jmxterm/
# > java -jar jmxterm-1.0-alpha-4-uber.jar
# Welcome to JMX terminal. Type "help" for available commands.
# $>open localhost:9991
# #Connection to localhost:9991 is opened

RUN set -x; apt-get update && apt-get install -yqq net-tools vim htop ccze && \
    cd /usr/local/bin && curl -L "https://github.com/patric-r/jvmtop/releases/download/0.8.0/jvmtop-$JVMTOP_VERSION.tar.gz" | tar zxf - && \
    cd /opt && \
    curl -L 'https://downloads.sourceforge.net/project/cyclops-group/jmxterm/1.0-alpha-4/jmxterm-1.0-alpha-4-uber.jar?r=https://sourceforge.net/projects/cyclops-group/files/jmxterm/1.0-alpha-4/&ts=1511489083&use_mirror=iweb' > jmxterm-1.0-alpha-4-uber.jar && \
    # Add goss for local, serverspec-like testing
    curl -L https://github.com/aelsabbahy/goss/releases/download/${GOSS_VERSION}/goss-linux-amd64 -o /usr/local/bin/goss && \
    chmod +x /usr/local/bin/goss

# Overlay the root filesystem from this repo
COPY ./container/root /

RUN goss -g /tests/goss.jmxtrans.yaml validate
