# Default commit message — override with `make push m="your message"`
m ?= wip: sync

.PHONY: help status add commit push sync pull reset-submodules

help:
	@echo "Targets:"
	@echo "  make status   - show dirty state of parent + all submodules"
	@echo "  make add      - stage everything in submodules + parent"
	@echo "  make commit   - commit submodules then parent  (m=\"msg\")"
	@echo "  make push     - push submodules then parent"
	@echo "  make sync     - add + commit + push, end to end (m=\"msg\")"
	@echo "  make pull     - pull parent and update submodules to recorded SHAs"
	@echo "  make reset-submodules - hard-reset submodules to parent's pointers"
	@echo "  make dev      - start up kura development environment"
	@echo "  make prod     - start up kura production environment"
	@echo "  make dev-down - shut down kura development environment"
	@echo "  make prod-down - shut down kura production environment"
	@echo "  make down-all - shut down all environments and prune image"

status:
	@echo "── parent ──"
	@git status
	@echo
	@echo "── submodules ──"
	@git submodule foreach 'echo "▸ $$name"; git status; echo'

add:
	@git submodule foreach 'git add .'
	@git add .

commit:
	@git submodule foreach --quiet 'git diff --cached || git commit -m "$(m)"'
	@git diff --cached --quiet || git commit -m "$(m)"

push:
	@git submodule foreach 'git push'
	@git push

sync: add commit push
	@echo "✓ synced with message: $(m)"

pull:
	@git pull
	@git submodule update --init --recursive

reset-submodules:
	@git submodule update --init --recursive --force

dev:
	@docker compose -p kura-dev -f docker-compose.yml -f docker-compose.dev.yml up --build

prod:
	@docker compose -p kura-dev -f docker-compose.yml up --build

dev-down:
	@docker compose -p kura-dev down -v 

prod-down:
	@docker compose -p kura-prod down -v 

down-all:
	@docker compose -p kura-dev down -v 
	@docker compose -p kura-prod down -v 
	@docker image prune -f
