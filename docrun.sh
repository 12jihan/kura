#!/bin/bash

case "$1" in
dev)
  docker compose -p kura-dev -f docker-compose.yml -f docker-compose.dev.yml up --build
  ;;
prod)
  docker compose -p kura-prod -f docker-compose.yml up --build
  ;;
down-dev)
  docker compose -p kura-dev down -v
  ;;
down-prod)
  docker compose -p kura-prod down -v
  ;;
down-all)
  docker compose -p kura-dev down -v
  docker compose -p kura-prod down -v
  docker image prune -f
  ;;
*)
  echo "Usage: ./kura.sh {dev|prod|down-dev|down-prod|down-all}"
  exit 1
  ;;
esac
