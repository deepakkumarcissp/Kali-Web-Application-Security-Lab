#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-dkcissp-web-lab}"
export DKCISSP_PORT="${DKCISSP_PORT:-1003}"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; BLUE='\033[0;34m'; RESET='\033[0m'
info() { printf "${BLUE}[DKCISSP]${RESET} %s\n" "$*"; }
ok() { printf "${GREEN}[  OK  ]${RESET} %s\n" "$*"; }
warn() { printf "${YELLOW}[ WARN ]${RESET} %s\n" "$*"; }
die() { printf "${RED}[ ERROR ]${RESET} %s\n" "$*" >&2; exit 1; }

usage() {
  cat <<'USAGE'
DKCISSP Web Application Security Lab

Usage:
  ./lab.sh start
  ./lab.sh status
  ./lab.sh logs
  ./lab.sh scenarios
  ./lab.sh stop
  ./lab.sh reset
  ./lab.sh destroy

Commands:
  start    Start the lab and wait for its HTTP health check.
  status   Show container status and local URL.
  logs     Follow application logs (Ctrl+C to exit).
  scenarios Open the guided local security-test scenario menu.
  stop     Stop the lab without deleting its container.
  reset    Recreate the application container; this discards its writable state.
  destroy  Remove the lab container and its dedicated network after confirmation.

Environment:
  DKCISSP_PORT=1004 ./lab.sh start   Use another localhost port (default: 1003).
USAGE
}

# Detect both Compose version and Docker permissions before choosing the command.
if docker info >/dev/null 2>&1; then
  DOCKER=(docker)
elif command -v sudo >/dev/null 2>&1 && sudo docker info >/dev/null 2>&1; then
  DOCKER=(sudo docker)
else
  die "Docker is unavailable or the current account cannot access it. Run ./install.sh and check the Docker service."
fi

if "${DOCKER[@]}" compose version >/dev/null 2>&1; then
  COMPOSE=( "${DOCKER[@]}" compose )
elif command -v docker-compose >/dev/null 2>&1; then
  if [[ "${DOCKER[0]}" == "sudo" ]]; then COMPOSE=(sudo docker-compose); else COMPOSE=(docker-compose); fi
else
  die "Docker Compose is unavailable. Run ./install.sh first."
fi

compose() { "${COMPOSE[@]}" -f "$ROOT_DIR/docker-compose.yml" "$@"; }

wait_for_http() {
  local url="http://127.0.0.1:${DKCISSP_PORT}/"
  local attempt
  info "Waiting for the application health check..."
  for attempt in $(seq 1 45); do
    if command -v curl >/dev/null 2>&1 && curl --silent --fail --max-time 2 "$url" >/dev/null 2>&1; then
      ok "Application is responding."
      printf "\nDKCISSP LAB READY\n"
      printf "URL: %s\n" "$url"
      printf "Network exposure: localhost only\n"
      printf "Next: open the URL in your browser and begin your first practice exercise.\n"
      return 0
    fi
    sleep 2
  done
  warn "The application did not become healthy within 90 seconds."
  printf "Check logs with: ./lab.sh logs\n" >&2
  return 1
}

command_name="${1:-}"
case "$command_name" in
  start)
    compose config >/dev/null
    compose up -d
    wait_for_http
    ;;
  status)
    compose ps
    printf "\nLocal URL: http://127.0.0.1:${DKCISSP_PORT}/\n"
    if command -v curl >/dev/null 2>&1 && curl --silent --fail --max-time 2 "http://127.0.0.1:${DKCISSP_PORT}/" >/dev/null; then
      ok "HTTP health check passed."
    else
      warn "HTTP health check did not pass."
    fi
    ;;
  logs)
    compose logs --tail=200 -f
    ;;
  scenarios)
    exec "$ROOT_DIR/scenarios.sh"
    ;;
  stop)
    compose stop
    ok "Lab stopped. Container resources have been retained."
    ;;
  reset)
    printf "Reset will recreate the Juice Shop container and discard its writable state. Continue? [y/N] "
    read -r answer
    case "$answer" in
      y|Y|yes|YES) compose down; compose up -d; wait_for_http ;;
      *) info "Reset cancelled." ;;
    esac
    ;;
  destroy)
    printf "Destroy will remove this lab's container and dedicated network. Continue? [y/N] "
    read -r answer
    case "$answer" in
      y|Y|yes|YES) compose down --remove-orphans; ok "Lab containers and dedicated network removed." ;;
      *) info "Destroy cancelled." ;;
    esac
    ;;
  -h|--help|help|"") usage ;;
  *) usage >&2; exit 2 ;;
esac
