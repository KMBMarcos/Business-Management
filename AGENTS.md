# DevFast Manager - Agent Guide

## Project Structure
- **Monorepo** with two sibling packages: `backend/` and `frontend/`
- Backend: Fastify 4 + TypeScript + Prisma 5 + SQLite (default DB)
- Frontend: React 19 + Vite 8 + Tailwind 3.4 + React Router 7 + React Query + Recharts
- Branch: `stable`; two remotes: `origin`, `upstream`

## Commands

### Backend (`backend/`)
| Command | What it does |
|---|---|
| `npm run dev` | `tsx watch src/index.ts` — hot-reload dev server on port 3001 |
| `npm run build` | `tsc` — compiles to `dist/` |
| `npm run start` | `node dist/index.js` — production |
| `npx prisma generate` | Generate Prisma client after schema change |
| `npx prisma db push` | Push schema to DB (no migration files created) |
| `npx prisma studio` | Open Prisma Studio GUI |

### Frontend (`frontend/`)
| Command | What it does |
|---|---|
| `npm run dev` | Vite dev server on port 5173 |
| `npm run build` | `tsc -b && vite build` — typecheck + bundle |
| `npm run lint` | ESLint on `src/` |
| `npm run preview` | Serve production build locally |

### Order for changes: `lint -> build` (both frontend only — backend has no linter)

## Code Conventions
- **Files**: kebab-case for routes/services (`auth.ts`, `exchangeRates.ts`), PascalCase for components (`ProjectManager.tsx`)
- **Hooks**: `use` prefix (`useAuth`, `useCompany`)
- **Frontend TypeScript strict**: `verbatimModuleSyntax: true` → use `import type` for type-only imports. `erasableSyntaxOnly: true` → no enums, no `namespace`, no `constructor parameter properties`
- **Backend TypeScript**: `noImplicitAny: false`, `strictFunctionTypes: false` — less strict within `strict: true`
- **API routes** registered in `backend/src/index.ts` with `/api/` prefix
- **Frontend routes** defined in `frontend/src/App.tsx` inside `<PrivateRoute>` wrapper
- UI labels are in Spanish, dates formatted with `es-ES` locale

## Architecture
- **Backend entry**: `backend/src/index.ts` — Fastify server with CORS, JWT, WebSocket plugins
- **Prisma client singleton**: `backend/src/db.ts` — decorates Fastify instance as `fastify.prisma`
- **Auth**: decorator `fastify.authenticate` (JWT verify) — used as `preHandler` on protected routes
- **Auth flow**: request OTP → email (console fallback if SMTP unconfigured) → register with OTP. First user becomes admin
- **Frontend auth**: JWT stored in `localStorage` key `token`, managed by `ApiClient` class in `frontend/src/api/client.ts`
- **Data fetching**: custom fetch-based `ApiClient` (no axios) + React Query wrapper in `frontend/src/hooks/useData.tsx` (staleTime 30s, refetchOnWindowFocus false, retry 1)
- **Chat**: WebSocket at `ws://host/api/chat/ws?token=...` with HTTP fallback
- **Exchange rates**: Auto-fetch from eltoque.com every 24h via `scheduleElToqueRates`
- **Bootstrap**: On startup, creates base roles + company settings (idempotent via upsert)
- **Dark mode**: CSS class toggle on `<html>` element, persisted in localStorage key `theme`

## Testing
- No test suite exists — listed as pending. Verification = `npm run build` passing.

## Database
- Prisma schema at `backend/prisma/schema.prisma`
- Use `prisma db push` (not `migrate`) — no migration files in repo
- SQLite by default; switch to MySQL/PostgreSQL by changing provider + `DATABASE_URL`

## Environment
- **Backend**: `.env` file with `DATABASE_URL`, `JWT_SECRET`, `PORT`, `HOST`, `SMTP_*`, `NODE_ENV`, `EL_TOQUE_URL`
- **Frontend**: `VITE_API_URL=http://localhost:3001` — set at build/dev time
- **No CI/CD** in repo — deploy via `deploy.sh` which installs Node.js, deps, builds, `db push`, and starts server

## Quirks
- No `.gitignore` in repo — git includes all files
- No pre-commit hooks, no formatter config (no Prettier)
- Backend has no ESLint — only frontend does
- Only 2 commits in history — treat as initial codebase drop
- `postcss.config.js` uses `tailwindcss` plugin (Tailwind v3) even though `@tailwindcss/postcss` v4 is in devDeps — match existing pattern
