# DevFast Manager Deployment

This project can run in two modes:

- Development: Vite + Fastify running separately.
- Production: Docker Compose with an Nginx frontend reverse-proxy and a Node/Fastify backend.

## Development

Backend:

```bash
cd backend
cp .env.example .env
# For local dev you can keep NODE_ENV unset or set NODE_ENV=development.
npm install
npx prisma db push
npm run dev
```

Frontend:

```bash
cd frontend
cp .env.example .env
# Optional when running split dev servers:
# VITE_API_URL=http://localhost:3001
npm install
npm run dev
```

In development, OTP codes are printed only when SMTP is not configured and `NODE_ENV` is not `production`.

## Production with Docker Compose

1. Copy environment templates:

```bash
cp .env.example .env
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
```

2. Edit `backend/.env`:

```env
NODE_ENV=production
HOST=0.0.0.0
PORT=3002
DATABASE_URL=file:/data/devfast.db
JWT_SECRET=<long-random-secret>
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_STARTTLS=true
SMTP_USER=<gmail-address>
SMTP_PASS=<gmail-app-password>
SMTP_FROM=<gmail-address>
```

Production mode requires SMTP. If SMTP is missing, the OTP endpoint fails instead of leaking dev OTP codes.

3. Start:

```bash
docker compose up -d --build
```

4. Open:

```text
http://localhost:8080
http://<tailscale-hostname>:8080
http://<tailscale-hostname>.<tailnet>.ts.net:8080
```

The frontend uses relative `/api/...` URLs by default, so the same build works from localhost, LAN, and Tailscale MagicDNS.

## Tailscale Notes

No public ports are needed. Bind the web container to `WEB_PORT` and access it over the tailnet:

```env
WEB_PORT=8080
```

If a client also uses WireGuard full-tunnel, make sure the Tailscale CGNAT range goes through `tailscale0`, not the WireGuard tunnel:

```bash
ip route get 100.64.0.1
```

The route should use `tailscale0`. If it uses `wg0`, add a more specific route for `100.64.0.0/10` via `tailscale0` in that client's routing table.

## Healthcheck

Backend:

```bash
curl http://localhost:8080/api/health
```

Docker Compose also uses `/api/health` for backend readiness before exposing the frontend.
