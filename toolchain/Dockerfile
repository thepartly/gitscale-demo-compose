# What a service runs from its working tree with: the x-build commands of the
# demo's repositories. Everything is installed outside $HOME, which the stack
# mounts for the caches in it.
FROM rust:1-bookworm
RUN cargo install cargo-watch --locked \
    && rm -rf /usr/local/cargo/registry /usr/local/cargo/git
COPY --from=node:22-bookworm-slim /usr/local/bin/ /usr/local/bin/
COPY --from=node:22-bookworm-slim /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
