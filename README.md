# Unison Docker Image

A minimal Alpine-based [Unison](https://github.com/bcpierce00/unison) Docker image with inotify support. Ideal for production, CI/CD pipelines, or sync-based service containers.

## Features

- Unison v2.53.7 built from source
- Includes `unison-fsmonitor` for inotify-based sync
- Small image footprint (~20MB compressed)
- Based on Alpine 3.22
- No build dependencies in final image
- Supports server and client modes
- Suitable for Docker Swarm, Kubernetes, CI, or standalone use

## Usage

### Environment Variables
- `LOCAL_DATA`: Local directory to sync (default: `/data`)
- `REMOTE_DATA`: Remote Unison server (e.g., `socket://host.example.com:5000//data`)
- `UNISON_EXTRA`: Additional Unison flags (e.g., `-ignore 'Name *.tmp'`)

### Check Version
```bash
docker run --rm ghcr.io/youruser/unison -version
```

### Server Mode
Run Unison as a server, listening on port 5000:
```bash
docker run --rm -v $(pwd):/data -p 5000:5000 ghcr.io/youruser/unison
```

### Client Mode
Sync local `/data` with a remote Unison server:
```bash
docker run --rm -v $(pwd):/data ghcr.io/youruser/unison \
    -e REMOTE_DATA=socket://host.example.com:5000//data
```

### Example with Extra Flags
Ignore temporary files during sync:
```bash
docker run --rm -v $(pwd):/data ghcr.io/youruser/unison \
    -e REMOTE_DATA=socket://host.example.com:5000//data \
    -e UNISON_EXTRA="-ignore 'Name *.tmp'"
```

## Building Locally
```bash
docker build -t unison:local .
```

## License
MIT License. See LICENSE for details.

## Credits
Based on the official Unison File Synchronizer project. Built for container-native environments.
