.PHONY: install-ship run-local run-local-headless lint clean-assets print-generated-assets deps run-compose deploy-swarm
SHIP := $(shell which ship)
PATH := $(shell pwd)
SHELL := /bin/bash -lo pipefail
lint_reporter := console
# Optional -- tweak this based on your deployment target  https://docs.docker.com/compose/compose-file/
compose_version := 3.7

# Replace this with your private or public ship repo in github
REPO := replicatedhq/ship-starter-compose

# Optional -- replace with your app details
APP_NAME := "My Cool App"
ICON := "https://vendor.replicated.com/011a5f1125bce80a8ced6fae0c409c91.png"


install-ship:
	brew tap replicatedhq/ship
	brew install ship

deps:
	[ -x `npm bin`/replicated-lint ] || npm install replicated-lint

lint:
	`npm bin`/replicated-lint validate --project replicatedShip -f ship.yaml --reporter $(lint_reporter)

run-local: clean-assets lint
	mkdir -p tmp
	cd tmp && \
	$(SHIP) app \
	    --runbook $(PATH)/ship.yaml  \
	    --set-github-contents $(REPO):/compose:master:$(PATH) \
	    --set-channel-icon $(ICON) \
	    --set-channel-name $(APP_NAME) \
	@$(MAKE) print-generated-assets

run-local-headless: clean-assets lint
	mkdir -p tmp
	cd tmp && \
	$(SHIP) app \
	    --runbook $(PATH)/ship.yaml  \
	    --set-github-contents $(REPO):/compose:master:$(PATH) \
	    --headless \
	    --log-level=error
	@$(MAKE) print-generated-assets

run-compose:
	@echo
	@echo  ┌───────────┐
	@echo "│  Running  │"
	@echo  └───────────┘
	@echo
	@sleep .5
	docker-compose -f tmp/compose/docker-compose.yaml  up

deploy-swarm:
	@echo
	@echo  ┌─────────────┐
	@echo "│  Deploying  │"
	@echo  └─────────────┘
	@echo
	@sleep .5
	docker stack deploy --compose-file tmp/compose/docker-compose.yaml

clean-assets:
	rm -rf tmp/compose

print-generated-assets:
	@echo
	@echo  ┌────────────────────┐
	@echo "│  Generated Assets  │"
	@echo  └────────────────────┘
	@echo
	@sleep .5
	@ls tmp/ tmp/compose
