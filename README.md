# Unison Docker Image

A minimal, statically-compiled [Unison](https://github.com/sensewarecom/unison) Docker image based on Alpine Linux. Ideal for use in production, CI/CD pipelines, or sync-based service containers.

## Features

- Unison v2.53.7 built from source
- Statically compiled with `STATIC=true` (no runtime OCaml dependencies)
- Includes `unison-fsmonitor` for improved sync performance
- Small image footprint (~20MB compressed)
- Based on Alpine 3.19
- No unnecessary packages (build dependencies removed)
- Suitable for Docker Swarm, Kubernetes, CI, or standalone use

## Usage

### Check version
```bash
docker run --rm ghcr.io/youruser/unison -version
```

## Basic sync example

Assuming a Unison daemon is running on host.example.com:
```bash
docker run --rm -v $(pwd):/data \
    ghcr.io/senseware/unison \
    /data socket://host.example.com:5000//data \
    -auto -batch -repeat watch -terse
```
You can use this image as a sidecar container, for one-time syncs, or as a persistent service with a process manager.

## Building locally

```bash
docker build -t unison:local .
```
## License

MIT License. See LICENSE for details.

## Credits

Based on the official Unison File Synchronizer project. Built for use in container-native environments.
