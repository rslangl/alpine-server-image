FROM alpine:3.14 AS build_hardened
RUN apk add bash
ENTRYPOINT ["bash"]

