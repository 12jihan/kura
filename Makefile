# Default commit message — override with `make push m="your message"`
m ?= wip: sync

.PHONY: help status add commit push pull branch sync reset-submodules

help:
	@echo "Git Targets:"
	@echo "  make status   - show dirty state of parent + all submodules"
	@echo "  make add      - stage everything in submodules + parent"
	@echo "  make commit   - commit submodules then parent  (m=\"msg\")"
	@echo "  make push     - push submodules then parent"
	@echo "  make sync     - add + commit + push, end to end (m=\"msg\")"
	@echo "  make pull     - pull parent and update submodules to recorded SHAs"
	@echo "  make branch   - create a new branch (name=\"your-new-branch-name\")"
	@echo "  make reset-submodules - hard-reset submodules to parent's pointers"
	@echo " "
	@echo "Docker Targets:"
	@echo "  make dev      - start up kura development environment"
	@echo "  make prod     - start up kura production environment"
	@echo "  make dev-down - shut down kura development environment"
	@echo "  make prod-down - shut down kura production environment"
	@echo "  make down-all - shut down all environments and prune image"

#Git Commands
status:
	@echo "── parent ──"
	@git status
	@echo
	@echo "── submodules ──"
	@git submodule foreach 'echo "▸ $$name"; git status; echo'

add:
	@echo "Staging submodules..."
	@git submodule foreach 'git add . || true'
	@echo "Staging parent..."
	@git add .
	@echo "Status check:"
	@git status

commit:
	@git submodule foreach 'git commit -m "$(m)" || true'
	@git commit -m "$(m)" || true

push:
	@git submodule foreach 'git push'
	@git push


pull:
	@git pull
	@git submodule update --init --recursive --remote --merge

branch:
	@if [ -z "$(name)" ]; then \
		echo "Error: Branch name is required. Usage: make branch name=your-branch-name"; \
		exit 1; \
	fi
	@echo "Creating branch $(name) in main repository..."
	git checkout -b $(name)
	@echo "Creating branch $(name) in all submodules (frontend, backend, etc.)..."
	git submodule foreach 'git checkout -b $(name) || true'

sync: add commit push
	@echo "✓ synced with message: $(m)"

reset-submodules:
	@git submodule update --init --recursive --force


# Docker Commands
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
