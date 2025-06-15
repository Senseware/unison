# Unison Docker Image

A minimal Alpine-based [Unison](https://github.com/bcpierce00/unison) Docker image with **inotify (fsmonitor)** support. Ideal for real-time file synchronization in production, CI/CD pipelines, Docker Swarm, or Kubernetes.

## Features

- Unison **v2.53.7**, compiled from source
- Includes `unison-fsmonitor` for efficient inotify-based sync
- Minimal image size (~20MB compressed)
- Based on Alpine Linux **3.22**
- Clean runtime image (no build dependencies)
- Automatically switches between **client** and **server** mode
- Stores Unison archive in `/data/.unison/<LOCAL_HOSTNAME>`

## Usage

### Image Location

The image is published at:

```
ghcr.io/senseware/unison
```

### Environment Variables

| Variable              | Description                                                                 |
|-----------------------|-----------------------------------------------------------------------------|
| `REMOTE_DATA`         | Remote Unison endpoint (`socket://host:5000//data`). Triggers client mode.  |
| `REMOTE_HOSTNAME`     | Optional shorthand for `REMOTE_DATA`. Generates `REMOTE_DATA` if not set.   |
| `LOCAL_HOSTNAME`      | **Required**. Must be set to the hostname of the container.                 |

### Check Version

```bash
docker run --rm ghcr.io/senseware/unison -version
```

### Server Mode

Start Unison as a server, listening on TCP port 5000:

```bash
docker run --rm -v $(pwd):/data -p 5000:5000 \
  -e LOCAL_HOSTNAME=$(hostname) \
  ghcr.io/senseware/unison
```

### Client Mode

Sync local `/data` with a remote Unison server:

```bash
docker run --rm -v $(pwd):/data \
  -e LOCAL_HOSTNAME=$(hostname) \
  -e REMOTE_DATA=socket://host.example.com:5000//data \
  ghcr.io/senseware/unison
```

Or using shorthand with `REMOTE_HOSTNAME`:

```bash
docker run --rm -v $(pwd):/data \
  -e LOCAL_HOSTNAME=$(hostname) \
  -e REMOTE_HOSTNAME=host.example.com \
  ghcr.io/senseware/unison
```

## Building Locally

```bash
docker build -t unison:local .
```

## License

MIT License. See `LICENSE` file for details.

## Source

Source code available at: [github.com/Senseware/unison](https://github.com/Senseware/unison)
