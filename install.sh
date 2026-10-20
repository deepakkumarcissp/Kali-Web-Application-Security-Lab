#!/usr/bin/env bash
set -Eeuo pipefail

# DKCISSP Web Application Security Lab
# This installer is intentionally interactive before installing system packages.

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; BLUE='\033[0;34m'; RESET='\033[0m'
info() { printf "${BLUE}[DKCISSP]${RESET} %s\n" "$*"; }
ok() { printf "${GREEN}[  OK  ]${RESET} %s\n" "$*"; }
warn() { printf "${YELLOW}[ WARN ]${RESET} %s\n" "$*"; }
die() { printf "${RED}[ ERROR ]${RESET} %s\n" "$*" >&2; exit 1; }

on_error() {
  local code=$?
  printf "\n${RED}[ ERROR ]${RESET} Setup failed near line %s (exit %s).\n" "${BASH_LINENO[0]:-unknown}" "$code" >&2
  printf "Review the message above, then run: ./lab.sh logs\n" >&2
  exit "$code"
}
trap on_error ERR

[[ "$(uname -s)" == "Linux" ]] || die "This lab currently supports Linux/Kali Linux only."
[[ -f "$ROOT_DIR/docker-compose.yml" ]] || die "Run this script from a complete repository checkout."

if ! command -v git >/dev/null 2>&1; then
  die "Git is required to download the repository. Install it with: sudo apt update && sudo apt install -y git"
fi

if ! command -v docker >/dev/null 2>&1; then
  warn "Docker is not installed."
  if ! command -v apt-get >/dev/null 2>&1; then
    die "Automatic dependency setup currently supports apt-based Kali/Debian systems only."
  fi
  printf "Install Docker Engine and Compose using the system package manager? [y/N] "
  read -r answer
  case "$answer" in
    y|Y|yes|YES)
      command -v sudo >/dev/null 2>&1 || [[ "$EUID" -eq 0 ]] || die "Install sudo or rerun with an account that can administer packages."
      if [[ "$EUID" -eq 0 ]]; then SUDO=(); else SUDO=(sudo); fi
      "${SUDO[@]}" apt-get update
      "${SUDO[@]}" apt-get install -y docker.io docker-compose curl
      "${SUDO[@]}" systemctl enable --now docker
      ok "Docker packages installed."
      ;;
    *)
      die "Docker is required. Install it, then rerun ./install.sh."
      ;;
  esac
fi

if docker info >/dev/null 2>&1; then
  DOCKER=(docker)
elif command -v sudo >/dev/null 2>&1 && sudo -n docker info >/dev/null 2>&1; then
  DOCKER=(sudo docker)
else
  warn "The current account cannot access Docker; checking whether sudo is available."
  if command -v sudo >/dev/null 2>&1; then
    DOCKER=(sudo docker)
    "${DOCKER[@]}" info >/dev/null || die "Docker is installed but unavailable. Check that the Docker service is running."
  else
    die "Docker is installed but inaccessible. Start the Docker service and check permissions."
  fi
fi

if "${DOCKER[@]}" compose version >/dev/null 2>&1; then
  COMPOSE=( "${DOCKER[@]}" compose )
elif command -v docker-compose >/dev/null 2>&1; then
  if "${DOCKER[@]}" ps >/dev/null 2>&1; then
    COMPOSE=(docker-compose)
    if [[ "${DOCKER[0]}" == "sudo" ]]; then COMPOSE=(sudo docker-compose); fi
  else
    die "Docker Compose was found but cannot access Docker."
  fi
else
  die "Docker Compose is missing. Install docker-compose or the Docker Compose plugin, then rerun this installer."
fi

ok "Docker and Compose are available."

# Use a dedicated project name so this lab does not manage unrelated containers.
export COMPOSE_PROJECT_NAME="dkcissp-web-lab"

# Validate Compose before starting anything.
"${COMPOSE[@]}" -f "$ROOT_DIR/docker-compose.yml" config >/dev/null
ok "Lab configuration validated."

info "Starting the local DKCISSP Web Application Security Lab..."
"$ROOT_DIR/lab.sh" start --compose-command "${COMPOSE[*]}"
