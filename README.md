Replicated Ship Starter (Compose/Swarm)
==================

Starter project for managing a [Ship](https://ship.replicated.com) application in a GitHub repo.

### Prequisites

- `make`
- `node`
- `ship` installed. On macOS, you can use `brew tap replicatedhq/ship && brew install ship` to install with Homebrew
- A GitHub repository created to store your Ship application assets.
- While testing, it can be useful to have a [locally configured docker daemon](https://www.docker.com/products/docker-desktop) to run your application.

**Note:** While Ship supports any git repository, this example leverages features that are GitHub-only (for now). The repo you create can be private or public.

### Project overview

This project contains an example application that can be deployed with ship. The main pieces are

- `compose/docker-compose.yaml` -- Docker compose file for defining your application
- `ship.yaml` -- ties these pieces together into a deployable application
- `Makefile` -- Workflows for testing the application installation experience
- [CI integration](#integrating-with-ci) starters for testing changes to your application.

### Get started

First, clone the repo and re-initialize it

```
export MY_APP_NAME=my-cool-app

git clone github.com/replicatedhq/ship-starter-compose.git ${MY_APP_NAME}
cd ${MY_APP_NAME}
rm -rf .git
git init
git remote add origin <your git repo>
```

### Hello, World!

To get started, you'll want to update the following fields in `Makefile` and `ship.yaml`:

- `Makefile` `REPO` -- update this to the `<owner>/<repo>` of your repository on GitHub
- `ship.yaml` `assets.v1.*.github.repo` -- this should match the `REPO` value in `Makefile`

You can test this out by launching ship with

    make deps
    make run-local

This will open a browser and walk you through configuring the application defined in `ship.yaml`. The test application creates a small Compose service to run Nginx, but it's a good way to get a sense of how ship works.

You can inspect the YAML at `tmp/compose/compose.yaml`, and test the app using docker-compose by running

    make run-compose

or

    docker-compose -f tmp/compose/compose.yaml up

Deploy to swarm with

    make deploy-swarm


### Iterate on your App

From here, you can add messaging and configuration options in the [config](https://ship.replicated.com/reference/config/items/) and [lifecycle](https://ship.replicated.com/reference/lifecycle/overview/) sections of `ship.yaml`, and modify YAML in `compose` to match your application's compose YAML.

The above

    make run-local

task can be run again to see the new changes. To iterate without using the UI, you can use

    make run-local-headless

to regenerate assets. State will be stored in `tmp/.ship/state.json` between runs, and will persist any changes to config options or Kustomize patches. To deploy it after running, you can

    make run-local-headless run-compose

### Integrate with CI

The project includes CI configs for [Travis CI](https://travis-ci.org) and [CircleCI](https://circleci.com).

Both configs will lint your `ship.yaml` for syntax and logic errors. You can use the [Ship Console](https://console.replicated.com/ship) to update and promote new releases as changes are made to your YAML in this repository.

### Tools reference

- [ship](https://github.com/replicatedhq/ship)
- [replicated-lint](https://github.com/replicatedhq/replicated-lint)

### License

MIT
