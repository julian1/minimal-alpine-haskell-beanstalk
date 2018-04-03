

# FROM debian:sid
FROM debian:stretch

RUN echo "building"

RUN apt-get -y update
RUN apt-get -y upgrade


