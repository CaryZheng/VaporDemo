FROM ubuntu:16.04
FROM vapor/toolbox:3.1.2

LABEL maintainer="zyxep"

# Install CURL
RUN apt-get update && \
    apt-get -y install curl && \
    rm -rf /var/lib/apt/lists/*;

# Get Vapor repo including Swift
RUN curl -sL https://apt.vapor.sh | bash;

# Installing Swift & Vapor
RUN apt-get update && \
    apt-get -y install swift vapor && \
    rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
	apt-get install -y libmysqlclient20 libmysqlclient-dev

WORKDIR /vapor

ADD . /vapor

RUN vapor build && \
	vapor run &

RUN ["vapor", "--help"]