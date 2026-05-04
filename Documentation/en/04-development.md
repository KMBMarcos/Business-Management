# Development Guide - DevFast Manager

## Project Structure

```
DevFast Manager/
├── backend/
│   ├── src/
│   │   ├── routes/        # API endpoints
│   │   │   ├── auth.ts    # Authentication and users
│   │   │   ├── projects.ts # Project management
│   │   │   ├── vps.ts     # Infrastructure
│   │   │   ├── finance.ts # Transactions
│   │   │   ├── tasks.ts   # Tasks and bugs
│   │   │   ├── dashboard.ts # Dashboard and metrics
│   │   │   ├── chat.ts    # Internal chat
│   │   │   ├── activity.ts # Activity logging
│   │   │   └── settings.ts # Company settings
│   │   ├── services/      # Business logic
│   │   │   ├── bootstrap.ts # Base roles and settings
│   │   │   ├── email.ts   # Mail sending
│   │   │   ├── exchangeRates.ts # Exchange rates
│   │   │   └── activity.ts # Logging helper
│   │   ├── db.ts          # Prisma client
│   │   ├── index.ts       # Fastify server
│   │   └── types/         # TypeScript types
│   ├── prisma/
│   │   └── schema.prisma  # Data model
│   └── package.json
│
├── frontend/
│   ├── src/
│   │   ├── api/
│   │   │   └── client.ts  # HTTP client
│   │   ├── components/
│   │   │   └── Layout.tsx # Main layout
│   │   ├── pages/         # React pages
│   │   ├── hooks/         # Custom hooks
│   │   │   ├── useAuth.tsx  # Authentication
│   │   │   ├── useData.tsx  # React Query
│   │   │   └── useCompany.tsx # Company data
│   │   └── utils/
│   │       └── userVisuals.tsx # Avatars and colors
│   └── package.json
│
└── Documentation/
    ├── es/  # Spanish documentation
    └── en/  # English documentation
```

## Development Commands

### Backend

```bash
cd backend

# Development with hot-reload
npm run dev

# Compile TypeScript
npm run build

# Start production
npm run start

# Generate Prisma client
npx prisma generate

# Sync database
npx prisma db push
```

### Frontend

```bash
cd frontend

# Development
npm run dev

# Production build
npm run build

# Production preview
npm run preview
```

## Adding New API Route

1. Create file in `backend/src/routes/`
2. Register in `backend/src/index.ts`:

```typescript
import newRoute from './routes/newRoute.js'

await fastify.register(newRoute, { prefix: '/api/new' })
```

## Adding New Frontend Page

1. Create component in `frontend/src/pages/`
2. Register route in `frontend/src/App.tsx`:

```typescript
import NewPage from './pages/NewPage'

<Route path="/new" element={<NewPage />} />
```

## Database

### Prisma Schema

Edit `backend/prisma/schema.prisma` to modify models:

```prisma
model NewModel {
  id        Int      @id @default(autoincrement())
  field     String
  relation  Relation @relation(...)
}
```

Then:
```bash
npx prisma db push
npx prisma generate
```

### Prisma Queries

```typescript
// Find one
const user = await prisma.user.findUnique({ where: { id: 1 } })

// Create
const newOne = await prisma.user.create({
  data: { name: 'New', email: '...' }
})

// Update
await prisma.user.update({
  where: { id: 1 },
  data: { name: 'Updated' }
})

// Delete
await prisma.user.delete({ where: { id: 1 } })
```

## Styles

The frontend uses Tailwind CSS. Dark mode classes are configured in `frontend/src/index.css`.

### System Colors

```css
/* Light mode */
.bg-gray-50
.bg-white
.text-gray-800

/* Dark mode (override) */
.dark .bg-gray-50 { background-color: #0f172a; }
.dark .text-gray-800 { color: #e5e7eb; }
```

## Testing

```bash
# Backend - verify compilation
npm run build

# Frontend - verify build
cd frontend
npm run build

# Linting
npm run lint
```

## Adding Dependency

### Backend
```bash
cd backend
npm install package-name
```

### Frontend
```bash
cd frontend
npm install package-name
```

## Environment Variables for Development

```bash
# Backend
DATABASE_URL="file:./devfast.db"
JWT_SECRET="dev-secret"
PORT=3001

# Frontend
VITE_API_URL=http://localhost:3001
```

## Debugging

### View server logs
Fastify logs appear in the terminal. For more detail, log level can be modified in `backend/src/index.ts`.

### Network inspection
Use browser developer tools (F12 > Network) to see API requests.

### Database
```bash
# Open Prisma studio
npx prisma studio
```

## Code Conventions

- TypeScript strict mode
- File names in kebab-case (projects.ts, user-profile.tsx)
- React components in PascalCase (ProjectManager.tsx)
- Hooks with "use" prefix (useAuth.tsx)
- API routes in kebab-case (/api/my-resource)