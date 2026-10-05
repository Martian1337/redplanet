#!/usr/bin/env bash
# RedPlanet one-line installer (image-based).
#
#   curl -sSL https://redplanet.martiandefense.org/install.sh | sudo bash
#   curl -sSL https://redplanet.martiandefense.org/install.sh | sudo RANGE=full-appsec bash
#
# Runs a published RedPlanet controller image, which brings the chosen range up
# on your host via the Docker socket. Nothing is cloned; only Docker is used.
#
#   RANGE=labs|web-pentest|full-appsec|netsec|cloud|k8s|blue|all   (default: labs)
#   RP_ACTION=up|down                                              (default: up)
#   RP_ONLY=all|portal|labs|web|devsecops|netsec|cloud|k8s|blue    (combined image only)
#   LISTEN_IP=127.0.0.1                                            (default; set 0.0.0.0 on an isolated lab net)
set -euo pipefail

REPO="martiandefense/redplanet"
RANGE="${RANGE:-labs}"
ACTION="${RP_ACTION:-up}"
LISTEN_IP="${LISTEN_IP:-127.0.0.1}"

say(){ printf '\033[1;32m[redplanet]\033[0m %s\n' "$*"; }
die(){ printf '\033[1;31m[redplanet]\033[0m %s\n' "$*" >&2; exit 1; }

if ! command -v docker >/dev/null 2>&1; then
  say "Docker not found - installing via get.docker.com ..."
  curl -fsSL https://get.docker.com | sh || die "Docker install failed. See https://docs.docker.com/engine/install/"
fi

docker info >/dev/null 2>&1 || die "Docker is installed but the daemon is not reachable. Start it (e.g. 'sudo systemctl start docker') and re-run."

say "range=${RANGE} action=${ACTION} listen_ip=${LISTEN_IP}"
exec docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e RP_ACTION="${ACTION}" \
  ${RP_ONLY:+-e RP_ONLY="${RP_ONLY}"} \
  -e LISTEN_IP="${LISTEN_IP}" \
  "${REPO}:${RANGE}"
