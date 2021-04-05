# Fulla

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