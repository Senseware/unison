# Dockerfile for Alpine-based Unison server with inotify fsmonitor support

# 1. Build Unison with fsmonitor (inotify) support
FROM alpine:latest AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    ocaml \
    ocaml-findlib \
    wget

# Specify Unison version
ENV UNISON_VER=2.53.7

# Prepare source directory and download, compile Unison + fsmonitor helper
RUN mkdir -p /usr/src \
    && wget https://github.com/bcpierce00/unison/archive/refs/tags/v${UNISON_VER}.tar.gz -O /tmp/unison.tar.gz \
    && tar xzf /tmp/unison.tar.gz -C /usr/src \
    && cd /usr/src/unison-${UNISON_VER} \
    && make \
    && cp src/unison src/unison-fsmonitor /usr/local/bin/ \
    && chmod +x /usr/local/bin/unison /usr/local/bin/unison-fsmonitor \
    && rm -rf /tmp/unison.tar.gz /usr/src/unison-${UNISON_VER}

# 2. Create minimal runtime image
FROM alpine:latest

# Copy Unison binaries from builder
COPY --from=builder /usr/local/bin/unison /usr/local/bin/unison
COPY --from=builder /usr/local/bin/unison-fsmonitor /usr/local/bin/unison-fsmonitor

# Expose Unison socket port
EXPOSE 5000

# Run Unison server with low-latency watch mode
ENTRYPOINT ["unison"]
CMD ["-socket", "5000", "-auto", "-batch", "-repeat", "watch", "-terse"]

