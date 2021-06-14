# docker/rails

This directory contains various resources that facilitate a local Rails development environment.

## Gotchas


### env files
The `docker-compose.yml` assumes that a `.env` file and a `.env-local` file exists in the same directory, so it may be necessary to create them:

```sh
touch .env .env-local
```

The intention is that `.env` is checked into version control, while `.env-local` is not, and allows overriding configurations locally.
