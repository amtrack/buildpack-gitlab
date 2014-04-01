# Dockerfile for running unit tests for amtrack/buildpack-gitlab
FROM progrium/cedarish
MAINTAINER Matthias Rolke <mr.amtrack@gmail.com>
RUN sudo apt-get update -qq
RUN sudo apt-get -y install git
ADD . /app
RUN cd /app && ./bin/test-setup