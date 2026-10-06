# gitscale-demo-compose

The local stack of the [GitScale demo](https://github.com/thepartly/gitscale-demo):
run from any repository of the workspace, or a clone of one.

```sh
cd imports/frontend
./imports/compose/compose up -d
```

Every service runs in the stack's network under its own name, from its image
or from its working tree. A service and its environment are written once, in
its repository's `docker-compose.yml`; running it from the working tree
changes only how it runs.

| Repository | Runs |
|---|---|
| On the topic here — joined, or the repository itself on a topic branch | From its working tree: `x-build.run` in the toolchain container |
| Any other | Its image, tagged by `tags` |
| `--build DIR` | From its working tree, though not on the topic |
| `--image DIR` | Its image, though on the topic — once its pipeline built what you pushed |

```
compose [--build DIR] [--image DIR] [--network NAME] [--committed]
        [--allow-released] COMMAND [ARGS...]
tags [--committed] [--allow-released] DIR...
```

The options come before the compose command; everything from it on goes to
`docker compose`. `compose logs -f application-a` shows a build and its
restarts; `compose run --rm shell` gives a shell on the stack's network.

## A service repository

`docker-compose.yml`: its services as they run from images, and under the
top-level `x-build` — which compose ignores — how each runs from the working
tree. Its variables are `deploy/app.env`, the file Kubernetes reads too.

| `x-build.<service>` | Meaning |
|---|---|
| `run` | The command, in the repository's directory, in the foreground until stopped. It listens where the image does |
| `environment` | Added to the service's; a variable of the same name is replaced |
| `resources` | `cpus` and `memory`, replacing the service's limits; the build runs within them |

Compose files name every path through `GITSCALE_DEMO_<NAME>_DIR`, the
repository's absolute path, and the image through `GITSCALE_DEMO_<NAME>_TAG`.

## From a dev container

The paths `compose` mounts are read by the Docker daemon, on its host: a dev
container using the host's daemon needs the workspace and `$HOME` at the same
paths as the host, and the host's `/etc/passwd` and `/etc/group`.
`--network NAME` runs the stack on that container's network, so it reaches
every service by name.

Needs Docker Compose v2, `jq` and GitScale.
