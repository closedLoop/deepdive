FROM ubuntu
MAINTAINER adamwgoldberg@gmail.com
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y gnuplot python libpython2.7-dev default-jre default-jdk emacs postgresql postgresql-contrib git build-essential libnuma-dev bc unzip locales
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

ENV USER=root
WORKDIR /root
#RUN git clone https://github.com/closedLoop/deepdive.git
ADD . deepdive
WORKDIR /root/deepdive
ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash
RUN ["/bin/bash", "-c", "make"]

RUN mkdir -p ~/deepdive/app
WORKDIR /root/deepdive/app
VOLUME ["/root/deepdive/app"]

ENTRYPOINT ["/root/deepdive/docker_start.sh"]
