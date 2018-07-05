ARG VERSION=0.10.12

FROM  byrnedo/alpine-curl as fetcher
RUN apk add --no-cache unzip
ARG VERSION
RUN curl -L https://github.com/glowroot/glowroot/releases/download/v$VERSION/glowroot-$VERSION-dist.zip --output glowroot.zip
RUN unzip glowroot && rm glowroot.zip
WORKDIR /glowroot
RUN rm -r LICENSE NOTICE lib
COPY plugins /glowroot/plugins

FROM alpine:3.7
COPY --from=fetcher /glowroot /glowroot
ONBUILD ARG GLOWROOT_CENTRAL_URL
ONBUILD ARG GLOWROOT_AGENT_ID_PREFIX
ONBUILD RUN if [ -z "$GLOWROOT_CENTRAL_URL" ]; then echo "GLOWROOT_CENTRAL_URL NOT SET - ERROR"; exit 1; else : ; fi && \
            if [ -z "$GLOWROOT_AGENT_ID_PREFIX" ]; then echo "GLOWROOT_AGENT_ID_PREFIX NOT SET - ERROR"; exit 1; else : ; fi && \
            printf "collector.address=${GLOWROOT_CENTRAL_URL}\nagent.id=${GLOWROOT_AGENT_ID_PREFIX}" > /glowroot/glowroot.properties