ARG BASE_IMAGE_NAME=gs-base
ARG BASE_IMAGE_TAG=latest
FROM geosolutionsit/${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}
MAINTAINER Alessandro Parma<alessandro.parma@geo-solutions.it>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
#RUN  ln -s /bin/true /sbin/initctl

ENV jpeg_turbo_version 1.5.3

# Install updates
# Install Utils 
# Install GDAL
# Install JPEG Turbo 
# Cleanup 
RUN apt-get -y update \
 && apt-get install -y vim zip unzip net-tools telnet procps postgresql-client-9.6 gdal-bin \
 && wget https://downloads.sourceforge.net/project/libjpeg-turbo/${jpeg_turbo_version}/libjpeg-turbo-official_${jpeg_turbo_version}_amd64.deb \
 && dpkg -i ./libjpeg*.deb \
 && apt-get -f install \
 && rm -rf /tmp/resources \
 && rm -rf /var/lib/apt/lists/*

WORKDIR $CATALINA_HOME

ENV TERM xterm

EXPOSE 8080
