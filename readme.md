# Fulla

- [Fulla](#fulla)
  - [Why?](#why)
  - [Configuration](#configuration)
  - [Example docker compose file](#example-docker-compose-file)
  - [Start server](#start-server)
  - [Generate thumbnails](#generate-thumbnails)
  - [Hotkeys](#hotkeys)
  - [Note](#note)
  - [Screenshots](#screenshots)

## Why?

We have a lot of pictures (mostly about our children). I store them
in my Minio instance and the backup is on Wasabi. I tried to find a good
soltion that can be used in a very simple way, like no database, but I
coulnd't find an good solution for my probelem. I only wanted a small
software that can list all images and view them. I need only one "login"
credential that can be shared between us (close family members).

Intended environment: local network, not on the public internet.
Of course you can do it, but I have no intention to make it bullet-proof.
Just host it in your own network (homeserver, rpi, whatever).

* Why Go? Because I like Go and with 1.16+, the embed module is awesome.
* Why Elm? Because I want to learn more Elm and it was a good candidate.

## Configuration

Endironment variables:

```
FULLA_ENDPOINT          -> endpoint
  Example: storage.efertone.me, s3.eu-central-1.wasabisys.com

FULLA_ACCESS_KEY_ID     -> access key id
FULLA_SECRET_ACCESS_KEY -> secret access key
FULLA_BUCKET            -> target bucket name
FULLA_NOSSL             -> if it's not empty, use http, otherwise use https

FULLA_LOGIN_SECRET      -> secret for login
  If not provided, the system will generate one (not persistent)
```

## Example docker compose file

* `xxxx` -> access key id (aws, wasabi, minio, any s3 compatible service)
* `yyyy` -> secret access key (aws, wasabi, minio, any s3 compatible service)
* `zzzz` -> secret token for login (example: `openssl rand -base64 30`)

```yaml
---
version: '3.2'

services:
  web:
    image: yitsushi/fulla:1.0.1
    networks:
      - traefik-public
    ports:
      - 9876
    command: serve --listen="0.0.0.0:9876"
    environment:
      - FULLA_ENDPOINT=storage.mydomain.tld
      - FULLA_BUCKET=fulla-photos
      - FULLA_ACCESS_KEY_ID=xxxx
      - FULLA_SECRET_ACCESS_KEY=yyyy
      - FULLA_LOGIN_SECRET=zzzz
    deploy:
      labels:
        - "traefik.enable=true"
        - "traefik.http.routers.fulla-router.rule=Host(`fulla.mydomain.tld`)"
        - "traefik.http.services.fulla-service.loadbalancer.server.port=9876"
        - "traefik.http.routers.fulla-router.tls=true"
        - "traefik.http.routers.fulla-router.tls.certresolver=cloudflare"
        - "traefik.docker.network=traefik-public"
        - "traefik.http.middlewares.wg.ipwhitelist.sourcerange=127.0.0.1/32, 10.100.100.1/24, 172.18.0.1/24"
        - "traefik.http.routers.fulla-router.middlewares=wg@docker"

networks:
  traefik-public:
    external: true
```

## Start server

```
fulla serve --listen="0.0.0.0:9876" [--debug]
```

## Generate thumbnails

```
fulla thumbnail --workers=4 [--debug]
```

## Hotkeys

* `Esc`: Close single-image view
* `ArrowLeft`: Previous image in single-image view
* `ArrowRight`: Previous image in single-image view

## Note

This project target audiance is not a hosted solition for large user base.

The name field on the login screen is just a placeholder. It does not
matter what is the value, it will be saved in the JWT token and will be
used on image upload ([Issue#3][issue-3]) to populate object metadata.

[issue-3]: https://gitea.code-infection.com/efertone/fulla/issues/3

## Screenshots

![Directory list](https://gitea.code-infection.com/efertone/fulla/raw/branch/main/.assets/screenshot-01.png)
![Image list](https://gitea.code-infection.com/efertone/fulla/raw/branch/main/.assets/screenshot-02.png)
![Single image view](https://gitea.code-infection.com/efertone/fulla/raw/branch/main/.assets/screenshot-03.png)