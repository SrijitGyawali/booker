# =============================================================================
# booker: developer commands. Run `make` to list them.
#
# Recipes avoid shell-specific syntax, so every target behaves the same from
# PowerShell (where make runs recipes with cmd.exe), Git Bash, WSL, macOS,
# Linux and CI.
# =============================================================================

.DEFAULT_GOAL := help

# Plain `make` or `make help` only prints help: silence make's own
# "Nothing to be done" line. Every other target still echoes its commands.
ifeq ($(filter-out help,$(MAKECMDGOALS)),)
MAKEFLAGS += --silent
endif

# $(info) strips leading spaces, so help lines are indented with this variable.
empty :=
I := $(empty)  $(empty)

.PHONY: help
help:
	$(info Usage: make <target>)
	$(info )
	$(info Local infrastructure)
	$(info $(I)up          Start PostgreSQL and Redis, wait until healthy)
	$(info $(I)down        Stop containers (data is kept in volumes))
	$(info $(I)reset       Stop containers and DELETE local data volumes)
	$(info $(I)ps          Show container status and health)
	$(info $(I)logs        Follow container logs)
	$(info $(I)psql        Open a psql shell in the postgres container)
	$(info $(I)redis-cli   Open redis-cli in the redis container)
	$(info )
	$(info Go)
	$(info $(I)tidy        Sync go.mod and go.sum with the code)
	$(info $(I)fmt         Format all Go code (gofmt -s))
	$(info $(I)vet         Run go vet)
	$(info $(I)lint        Run golangci-lint (config: .golangci.yml))
	$(info $(I)test        Run all tests)
	$(info $(I)test-race   Run all tests with the race detector (needs cgo + gcc))
	$(info $(I)check       vet + lint + test, the same checks CI will run)
	$(info )
	$(info Repository)
	$(info $(I)hooks       Enable the pre-commit hook in .githooks/)

# --- Local infrastructure -----------------------------------------------------

.PHONY: up down reset ps logs psql redis-cli

up:
	docker compose up -d --wait

down:
	docker compose down

reset:
	docker compose down -v

ps:
	docker compose ps

logs:
	docker compose logs -f

psql:
	docker compose exec postgres psql

redis-cli:
	docker compose exec redis redis-cli

# --- Go -------------------------------------------------------------------------

.PHONY: tidy fmt vet lint test test-race check

tidy:
	go mod tidy

fmt:
	gofmt -s -w .

vet:
	go vet ./...

lint:
	golangci-lint run

test:
	go test ./...

test-race:
	go test -race -count=1 ./...

check: vet lint test

# --- Repository -----------------------------------------------------------------

.PHONY: hooks

hooks:
	git config core.hooksPath .githooks
