FROM alpine:3.21 AS build_hardened
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && apk add --no-cache hardened-malloc bash
ENTRYPOINT ["bash"]

