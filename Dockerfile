ARG BASE_IMAGE_NAME=gs-base
ARG BASE_IMAGE_TAG=latest
FROM geosolutionsit/${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}
MAINTAINER Alessandro Parma<alessandro.parma@geo-solutions.it>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
#RUN  ln -s /bin/true /sbin/initctl

# Install updates
RUN apt-get -y update

#------------- Install Utils --------------------------------------------------
RUN apt-get install -y vim zip unzip net-tools telnet procps curl

#------------- ContainerPilot -------------------------------------------------

# get ContainerPilot release
RUN curl -Lo /tmp/cb.tar.gz https://github.com/joyent/containerpilot/releases/download/3.8.0/containerpilot-3.8.0.tar.gz \
:q
    && tar -xz -f /tmp/cb.tar.gz && mv /containerpilot /bin/

# add ContainerPilot config and tell ContainerPilot where to find it
COPY containerpilot.json /etc/containerpilot.json
ENV CONTAINERPILOT=file:///etc/containerpilot.json

#------------- Cleanup --------------------------------------------------------
# Delete resources after installation
RUN    rm -rf /tmp/resources \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $CATALINA_HOME

ENV TERM xterm

EXPOSE 8080

CMD [ "/bin/containerpilot", "catalina-wrapper.sh" ]
