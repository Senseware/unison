# Dockerfile for Alpine-based Unison server/client with inotify fsmonitor support

# Specify Alpine version
ARG ALPINE_VERSION=3.22
# Specify Unison version
ARG UNISON_VERSION=2.53.7

# 1. Build Unison with fsmonitor (inotify) support
FROM alpine:${ALPINE_VERSION} AS builder

# Pass UNISON_VERSION to builder stage
ARG UNISON_VERSION

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    ocaml \
    ocaml-findlib \
    wget

# Prepare source directory and download, compile Unison + fsmonitor helper
RUN mkdir -p /usr/src \
    && wget https://github.com/bcpierce00/unison/archive/refs/tags/v${UNISON_VERSION}.tar.gz -O /tmp/unison.tar.gz \
    && tar xzf /tmp/unison.tar.gz -C /usr/src \
    && cd /usr/src/unison-${UNISON_VERSION} \
    && make \
    && cp src/unison src/unison-fsmonitor /usr/local/bin/ \
    && chmod +x /usr/local/bin/unison /usr/local/bin/unison-fsmonitor \
    && rm -rf /tmp/unison.tar.gz /usr/src/unison-${UNISON_VERSION} && \
    apk del build-base ocaml ocaml-findlib wget

# 2. Create minimal runtime image
FROM alpine:${ALPINE_VERSION}

# Install runtime dependencies
RUN apk add --no-cache inotify-tools

# Copy Unison binaries from builder
COPY --from=builder /usr/local/bin/unison /usr/local/bin/unison
COPY --from=builder /usr/local/bin/unison-fsmonitor /usr/local/bin/unison-fsmonitor
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/unison /usr/local/bin/unison-fsmonitor

# Sync directory
RUN mkdir /data
VOLUME /data
WORKDIR /data
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 5000
