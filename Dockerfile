FROM  byrnedo/alpine-curl as fetcher
RUN apk add --no-cache unzip
ARG VERSION
RUN curl -L https://github.com/glowroot/glowroot/releases/download/v0.10.12/glowroot-0.10.12-dist.zip --output glowroot.zip
RUN unzip glowroot && rm glowroot.zip
WORKDIR /glowroot
RUN rm -r LICENSE NOTICE lib
COPY plugins /glowroot/plugins

FROM alpine:3.7
COPY --from=fetcher /glowroot /glowroot
