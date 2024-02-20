# syntax=docker/dockerfile:1

FROM alpine:3.14

# Install Needed programs
RUN apk update
RUN apk add --no-cache git
RUN apk add --no-cache make
RUN apk add --no-cache g++
RUN apk add --no-cache --update bash
# Optional text editors
RUN apk add --no-cache vim
RUN apk add --no-cache nano

COPY files /files
WORKDIR /files

# Make the script executable
RUN chmod +x ./start.sh
RUN chmod +x ./setup.sh

# Flag, 0 means start, 1 means setup
ENV MODE=0

CMD ["/bin/sh", "/files/start.sh"]

