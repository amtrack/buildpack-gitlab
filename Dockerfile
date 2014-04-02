# Dockerfile for running unit tests for amtrack/buildpack-gitlab
# travis and drone.io
# FROM ubuntu:12.04
# dokku
FROM progrium/cedarish
MAINTAINER Matthias Rolke <mr.amtrack@gmail.com>
RUN sudo apt-get update -qq
RUN sudo apt-get -y install git wget
ADD . /app
RUN cd /app && ./bin/test-setup