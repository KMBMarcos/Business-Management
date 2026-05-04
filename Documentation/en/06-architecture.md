# Technical Architecture - DevFast Manager

## Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         Frontend                            │
│              React + Vite + Tailwind + Recharts            │
└─────────────────────┬───────────────────────────────────────┘
                      │ HTTP / WebSocket
┌─────────────────────▼───────────────────────────────────────┐
│                         Backend                             │
│           Fastify + TypeScript + Prisma + JWT              │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                    Database                                │
│                    SQLite / MySQL / PostgreSQL              │
└─────────────────────────────────────────────────────────────┘
```

## Backend

### Technology Stack
- **Runtime**: Node.js 20.x
- **Framework**: Fastify 4.x
- **Language**: TypeScript strict
- **ORM**: Prisma 5.x
- **Auth**: JWT + bcrypt
- **WebSocket**: @fastify/websocket

### File Structure

```
backend/src/
├── index.ts          # Entry point, Fastify configuration
├── db.ts             # Prisma client singleton
├── routes/           # Controllers/endpoints
│   ├── auth.ts       # Authentication, users, roles
│   ├── projects.ts   # Project CRUD
│   ├── vps.ts        # VPS infrastructure
│   ├── finance.ts    # Financial transactions
│   ├── tasks.ts      # Tasks and bugs
│   ├── dashboard.ts  # Metrics and alerts
│   ├── chat.ts       # Chat WebSocket and HTTP
│   ├── activity.ts   # Activity logging
│   └── settings.ts   # Company settings
├── services/         # Business logic
│   ├── bootstrap.ts  # Initial roles and settings
│   ├── email.ts      # SMTP sending
│   ├── exchangeRates.ts # El Toque rate fetching
│   └── activity.ts   # Logging helper
└── types/            # TypeScript declarations
    └── fastify.d.ts  # Fastify type extensions
```

### Request Flow

1. **HTTP request** arrives at Fastify
2. **CORS** is validated (@fastify/cors plugin)
3. **JWT** is verified (if authenticated endpoint)
4. **Route handler** executes Zod validation
5. **Service** processes logic (Prisma)
6. **Response** is sent to client

### Authentication

```typescript
// Authenticate decorator
fastify.decorate('authenticate', async function(request, reply) {
  try {
    await request.jwtVerify()
  } catch (err) {
    reply.status(401).send({ error: 'Unauthorized' })
  }
})

// Use in routes
fastify.get('/protected-route', { preHandler: [fastify.authenticate] }, handler)
```

### Database

**Main models:**

- **User**: System users
- **Role**: Roles (admin, member, etc.)
- **Project**: Projects
- **ProjectMember**: User-project relationship
- **VpsServer**: VPS servers
- **InfrastructureItem**: Infrastructure resources
- **FinancialTransaction**: Financial transactions
- **Task / Bug**: Tasks and bugs
- **ChatChannel / ChatMessage**: Internal chat
- **ActivityLog**: Activity register
- **Settings**: Key-value configuration
- **EmailOtp**: OTP codes

### Services

**bootstrap.ts**: Runs on server startup.
- Creates base roles if they don't exist
- Creates default company settings
- Not idempotent (uses upsert)

**email.ts**: Email sending.
- Supports SMTP with STARTTLS
- Console fallback in development
- Custom implementation (no external library)

**exchangeRates.ts**: Rate fetching.
- Parses HTML from eltoque.com
- Updates database
- Scheduler every 24h (setInterval)

## Frontend

### Technology Stack
- **Framework**: React 19
- **Build**: Vite 8
- **Styles**: Tailwind CSS 3.4
- **State**: React Query + Context
- **Charts**: Recharts
- **Icons**: Lucide React
- **Router**: React Router DOM 7

### File Structure

```
frontend/src/
├── App.tsx            # Main router
├── main.tsx           # React entry point
├── api/
│   └── client.ts      # HTTP client with fetch
├── components/
│   └── Layout.tsx     # Layout with sidebar
├── pages/             # Page components
│   ├── Login.tsx      # Login / Register
│   ├── Dashboard.tsx  # Main dashboard
│   ├── Projects.tsx   # Project list
│   ├── ProjectManager.tsx # Individual manager
│   ├── Infrastructure.tsx # VPS and infrastructure
│   ├── Finances.tsx   # Transactions
│   ├── Tasks.tsx      # Tasks and bugs
│   ├── Team.tsx       # Team members
│   ├── Chat.tsx       # Internal chat
│   ├── Notifications.tsx # Activity
│   ├── Profile.tsx    # My profile
│   ├── Settings.tsx   # Company config
│   └── UserProfile.tsx # Public profile
├── hooks/
│   ├── useAuth.tsx    # Auth context
│   ├── useData.tsx    # React Query provider
│   └── useCompany.tsx # Company settings hook
└── utils/
    └── userVisuals.tsx # Avatar, color, initials
```

### API Client

```typescript
// API_URL configurable via environment variable
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001'

// Class with convenient methods
class ApiClient {
  async request<T>(endpoint, options) { ... }
  get<T>(endpoint) { ... }
  post<T>(endpoint, data) { ... }
  put<T>(endpoint, data) { ... }
  delete<T>(endpoint) { ... }
}
```

### Authentication

- JWT token stored in localStorage
- Token included in header `Authorization: Bearer <token>`
- useAuth hook manages login/logout/profile

### Dark Mode

Implemented with CSS overrides in `index.css`:

```css
.dark body { background: #0f172a; }
.dark .bg-white { background-color: #111827 !important; }
/* etc */
```

Toggle in Layout uses `document.documentElement.classList.toggle('dark', value)` + localStorage.

### WebSocket (Chat)

```typescript
// Connection
const socket = new WebSocket(`ws://host/api/chat/ws?token=${token}`)

// Events
socket.onmessage = (event) => {
  const payload = JSON.parse(event.data)
  if (payload.type === 'new_message') { ... }
}
```

Fallback to HTTP if WebSocket not available.

## Deployment

### Development
- Backend: `npm run dev` (tsx watch)
- Frontend: `npm run dev` (Vite)

### Production

**Backend:**
```bash
npm run build  # compile TypeScript
npm run start  # node dist/index.js
```

**Frontend:**
```bash
npm run build  # generates dist/
npm run preview # serves dist/
```

### Environment Variables for Production

**Backend:**
- `DATABASE_URL` - Connection string
- `JWT_SECRET` - JWT signing key
- `PORT` / `HOST` - Server binding
- `SMTP_*` - Mail configuration
- `NODE_ENV` - production/development

**Frontend:**
- `VITE_API_URL` - Backend URL

### VPS with Tailscale

1. Upload files
2. Run `deploy.sh` or manually
3. Configure firewall:
   ```bash
   ufw allow from 100.64.0.0/10 to any port 3001
   ```
4. Access via Tailscale IP

## Security

- Passwords hashed with bcrypt (10 rounds)
- JWT with expiration
- Configurable CORS
- Input validation with Zod
- SQL injection prevented by Prisma (ORM)
- Rate limiting not implemented (pending)

## Performance

- SQLite database for development
- React Query with 30s staleTime
- Frontend ~750KB compressed JS
- WebSocket for real-time chat

## Pending / Improvements

- Automated tests
- Rate limiting
- Push notifications
- CSV import
- Migration to MySQL/PostgreSQL for production
- File upload (currently only URLs)
- More interactive dashboard
- Historical metrics