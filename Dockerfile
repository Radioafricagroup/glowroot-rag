FROM  byrnedo/alpine-curl as fetcher
RUN apk add --no-cache unzip
ARG VERSION
RUN curl -L https://github.com/glowroot/glowroot/releases/download/v0.10.12/glowroot-0.10.12-dist.zip --output glowroot.zip
RUN unzip glowroot && rm glowroot.zip
WORKDIR /glowroot
RUN rm -r LICENSE NOTICE
COPY plugins /glowroot/plugins
COPY admin.json /glowroot/admin.json

FROM alpine:3.7
COPY --from=fetcher /glowroot /glowroot
