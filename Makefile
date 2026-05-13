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

status:
	@echo "── parent ──"
	@git status --short
	@echo
	@echo "── submodules ──"
	@git submodule foreach --quiet 'echo "▸ $$name"; git status --short; echo'

add:
	@git submodule foreach --quiet 'git add -A'
	@git add -A

commit:
	@git submodule foreach --quiet 'git diff --cached --quiet || git commit -m "$(m)"'
	@git diff --cached --quiet || git commit -m "$(m)"

push:
	@git submodule foreach --quiet 'git push'
	@git push

sync: add commit push
	@echo "✓ synced with message: $(m)"

pull:
	@git pull
	@git submodule update --init --recursive

reset-submodules:
	@git submodule update --init --recursive --force
