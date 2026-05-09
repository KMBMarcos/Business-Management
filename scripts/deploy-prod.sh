#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required. Install Docker/Podman Compose first." >&2
  exit 1
fi

[ -f .env ] || cp .env.example .env
[ -f backend/.env ] || cp backend/.env.example backend/.env
[ -f frontend/.env ] || cp frontend/.env.example frontend/.env

echo "Review backend/.env before production start: JWT_SECRET and SMTP_* are required."
docker compose up -d --build

echo "DevFast Manager is starting. Default URL: http://localhost:${WEB_PORT:-8080}"
