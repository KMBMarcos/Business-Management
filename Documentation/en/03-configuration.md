# Configuration - DevFast Manager

## Environment Variables

The `.env` file in the `backend/` folder contains the system configuration.

### Database

```bash
# SQLite (default)
DATABASE_URL="file:./devfast.db"

# MySQL
DATABASE_URL="mysql://user:password@localhost:3306/devfast"

# PostgreSQL
DATABASE_URL="postgresql://user:password@localhost:5432/devfast"
```

### Server

```bash
# Port where backend will listen
PORT=3001

# Host (0.0.0.0 for all interfaces)
HOST=0.0.0.0

# JWT secret (change in production!)
JWT_SECRET="your-very-long-and-secure-secret-key"
```

### Exchange Rates

```bash
# El Toque URL for fetching rates (optional)
EL_TOQUE_URL="https://eltoque.com/tasas-de-cambio-de-moneda-en-cuba-hoy"
```

### SMTP Mail (for OTP)

```bash
# SMTP server
SMTP_HOST="smtp.gmail.com"
SMTP_PORT=587
SMTP_USER="your-email@gmail.com"
SMTP_PASS="your-app-password"
SMTP_FROM="your-email@gmail.com"

# true for port 465, false for 587/25
SMTP_SECURE=false
```

### Environment

```bash
# development or production
NODE_ENV=development
```

## Frontend URL Configuration

The frontend needs to know where the backend is:

```bash
# Development
VITE_API_URL=http://localhost:3001 npm run dev

# Production with specific IP
VITE_API_URL=http://100.x.x.x:3001 npm run build
```

Or edit directly in `frontend/src/api/client.ts`:

```typescript
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001';
```

## VPS Deployment

### Automatic Script

```bash
chmod +x deploy.sh
./deploy.sh
```

The script:
1. Detects operating system
2. Installs Node.js if needed
3. Installs dependencies
4. Builds project
5. Configures database
6. Asks if you want to start in background

### Manual

```bash
# Backend
cd backend
npm install
npx prisma db push
npm run build
HOST=0.0.0.0 PORT=3001 npm run start

# Frontend (in another terminal)
cd frontend
npm install
VITE_API_URL=http://YOUR_IP:3001 npm run build
npm run preview -- --host --port 80
```

## Change Company Name

1. Go to the **Company** section in the menu
2. Edit name, objective and logo
3. Changes apply immediately

## Scheduled Tasks

The system automatically updates exchange rates every 24 hours when the server starts. No additional configuration required.

## Security

1. **JWT_SECRET**: Change the default key
2. **SMTP**: Use an app password (not your real Gmail password)
3. **Firewall**: If using VPS, configure firewall rules to limit access

## Common Ports

| Service | Port | Description |
|----------|--------|-------------|
| Backend API | 3001 | REST API |
| Frontend Dev | 5173 | Development server |
| Frontend Prod | 4173 | Preview server |
| Nginx (custom) | 80 | Production with nginx |

## Troubleshooting

### Database connection error
```bash
npx prisma db push
```

### Port in use
```bash
lsof -i :3001
kill -9 PID
```

### CORS error
Make sure the backend is listening on `0.0.0.0` and the frontend has the correct URL in `VITE_API_URL`.

### OTP doesn't reach email
Verify SMTP configuration. The code is also shown in the server console if `NODE_ENV=development`.