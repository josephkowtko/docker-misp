# syntax=docker/dockerfile:1
# Use the Latest Ubuntu Image
FROM ubuntu:latest
# Set Initial User, Working Directory, and Environment
USER root
WORKDIR /
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBIAN_PRIORITY=critical
ARG MISP_USER=misp
ARG MISP_USER_PW=P@55word!
# Update and Install Pre-Requisites
RUN apt-get update && apt-get upgrade -y \
    apache2 \
    apache2-utils \
    curl \
    etckeeper \
    apt-utils \
    autoconf \
    bc \
    build-essential \
    daemon \
    dc \
    dialog \
    dnsutils \
    gawk \
    gettext \
    gcc \
    iputils-ping \
    libapache2-mod-php \
    libc6 \
    libc6-dev \
    libgd-dev \
    libmcrypt-dev \
    libnet-snmp-perl \
    libperl-dev \
    libssl-dev \
    make \
    net-tools \
    openssl \
    perl \
    php \
    php-gd \
    postfix \
    snmp \
    tini \
    tzdata \
    unzip \
    vim \
    wget
RUN apt clean
# Add Users and Groups
WORKDIR /
RUN useradd -m -s /bin/bash ${MISP_USER}
RUN usermod -a -G staff ${MISP_USER}
RUN usermod -a -G www-data ${MISP_USER}
RUN usermod -a -G sudo ${MISP_USER}
RUN echo "${MISP_USER}:${MISP_USER_PW}" | chpasswd
RUN chmod 2775 /usr/local/src
RUN chown root:staff /usr/local/src
# Copy Required Files Into Container Image
WORKDIR /
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
# Expose the Container and Start
WORKDIR /
ENTRYPOINT ["/usr/bin/tini", "--", "./entrypoint.sh"]
