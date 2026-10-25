#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-dkcissp-web-lab}"
export DKCISSP_PORT="${DKCISSP_PORT:-1003}"
export DKCISSP_DVWA_PORT="${DKCISSP_DVWA_PORT:-1006}"
export DKCISSP_WEBGOAT_PORT="${DKCISSP_WEBGOAT_PORT:-1007}"

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

Targets (localhost only):
  OWASP Juice Shop  http://127.0.0.1:1003
  DVWA              http://127.0.0.1:1006
  OWASP WebGoat     http://127.0.0.1:1007/WebGoat

Commands:
  start     Start all three vulnerable training applications.
  status    Show containers and health checks for all targets.
  logs      Follow lab logs (Ctrl+C to exit).
  scenarios Open the guided local security-test scenario menu.
  stop      Stop all lab services without deleting their containers.
  reset     Recreate all lab services after confirmation.
  destroy   Remove lab containers and the dedicated network after confirmation.

Optional port overrides:
  DKCISSP_PORT=1013 DKCISSP_DVWA_PORT=1016 DKCISSP_WEBGOAT_PORT=1017 ./lab.sh start
USAGE
}

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

print_urls() {
  printf '\nLocal training targets (loopback only):\n'
  printf '  Juice Shop : http://127.0.0.1:%s\n' "$DKCISSP_PORT"
  printf '  DVWA       : http://127.0.0.1:%s\n' "$DKCISSP_DVWA_PORT"
  printf '  WebGoat    : http://127.0.0.1:%s/WebGoat\n' "$DKCISSP_WEBGOAT_PORT"
  printf 'Network exposure: localhost only\n'
}

check_url() {
  local label="$1" url="$2"
  if command -v curl >/dev/null 2>&1 && curl --silent --fail --max-time 4 "$url" >/dev/null 2>&1; then
    ok "$label is responding."
    return 0
  fi
  warn "$label is not responding yet."
  return 1
}

wait_for_http() {
  local attempt juice=0 dvwa=0 webgoat=0
  info "Waiting for the training applications to start (up to 4 minutes)..."
  for attempt in $(seq 1 120); do
    if [[ "$juice" -eq 0 ]] && curl --silent --fail --max-time 2 "http://127.0.0.1:$DKCISSP_PORT/" >/dev/null 2>&1; then juice=1; fi
    if [[ "$dvwa" -eq 0 ]] && curl --silent --fail --max-time 2 "http://127.0.0.1:$DKCISSP_DVWA_PORT/" >/dev/null 2>&1; then dvwa=1; fi
    if [[ "$webgoat" -eq 0 ]] && curl --silent --fail --max-time 2 "http://127.0.0.1:$DKCISSP_WEBGOAT_PORT/WebGoat" >/dev/null 2>&1; then webgoat=1; fi
    if [[ "$juice" -eq 1 && "$dvwa" -eq 1 && "$webgoat" -eq 1 ]]; then
      ok "All three training applications are responding."
      printf '\nDKCISSP LAB READY\n'
      print_urls
      printf 'Use only for authorized testing of these local training targets.\n'
      return 0
    fi
    sleep 2
  done
  warn "One or more targets did not pass the HTTP check within 4 minutes."
  print_urls
  printf 'Inspect services with: ./lab.sh status && ./lab.sh logs\n' >&2
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
    print_urls
    check_url "Juice Shop" "http://127.0.0.1:$DKCISSP_PORT/" || true
    check_url "DVWA" "http://127.0.0.1:$DKCISSP_DVWA_PORT/" || true
    check_url "WebGoat" "http://127.0.0.1:$DKCISSP_WEBGOAT_PORT/WebGoat" || true
    ;;
  logs)
    compose logs --tail=200 -f
    ;;
  scenarios)
    exec "$ROOT_DIR/scenarios.sh"
    ;;
  stop)
    compose stop
    ok "All lab services stopped. Container resources have been retained."
    ;;
  reset)
    printf "Reset will recreate all three training containers and discard their writable state. Continue? [y/N] "
    read -r answer
    case "$answer" in
      y|Y|yes|YES) compose down; compose up -d; wait_for_http ;;
      *) info "Reset cancelled." ;;
    esac
    ;;
  destroy)
    printf "Destroy will remove all three lab containers and the dedicated network. Continue? [y/N] "
    read -r answer
    case "$answer" in
      y|Y|yes|YES) compose down --remove-orphans; ok "Lab containers and dedicated network removed." ;;
      *) info "Destroy cancelled." ;;
    esac
    ;;
  -h|--help|help|"") usage ;;
  *) usage >&2; exit 2 ;;
esac
