# Unison Docker Image

A minimal, statically-compiled [Unison](https://github.com/sensewarecom/unison) Docker image based on Alpine Linux. Ideal for use in production, CI/CD pipelines, or sync-based service containers.

## Features

- Unison v2.48.4 built from source
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

