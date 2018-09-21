FROM  byrnedo/alpine-curl as fetcher
RUN apk add --no-cache unzip
ARG VERSION
RUN curl -L http://nexus.radioafricaplatforms.com/repository/pipeline/glowroot.zip --output glowroot.zip
RUN unzip glowroot && rm glowroot.zip
WORKDIR /glowroot
RUN rm -r LICENSE NOTICE lib
COPY plugins /glowroot/plugins

FROM alpine:3.7
COPY --from=fetcher /glowroot /glowroot
