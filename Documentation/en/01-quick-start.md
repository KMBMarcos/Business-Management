# DevFast Manager - Quick Start

## Prerequisites

- **Node.js** 20.x or higher
- **npm** 9.x or higher

## Installation in 5 Minutes

### 1. Clone the project

```bash
git clone https://github.com/your-user/DevFast-Manager.git
cd DevFast-Manager
```

### 2. Install dependencies

```bash
# Backend
cd backend
npm install

# Frontend (in another terminal)
cd ../frontend
npm install
```

### 3. Setup database

```bash
cd backend
npx prisma db push
```

### 4. Start servers

**Terminal 1 - Backend (port 3001):**
```bash
cd backend
npm run dev
```

**Terminal 2 - Frontend (port 5173):**
```bash
cd frontend
npm run dev
```

### 5. Access

Open your browser: **http://localhost:5173**

## First Use

1. On the login page, click **"Register"**
2. Enter your email and request the OTP code
3. Check your email (or server console if SMTP not configured)
4. Enter the 6-digit code
5. Complete your name and password
6. Done! You can now use the system

The first registered user becomes **administrator**.

## Update to Production

### Backend

```bash
cd backend
npm run build
npm run start
```

### Frontend

```bash
cd frontend
npm run build
npm run preview
```

## Troubleshooting

### "Cannot find module"
Reinstall dependencies:
```bash
npm install
```

### Database error
Sync Prisma schema:
```bash
npx prisma db push
```

### Port in use
Kill processes on ports:
```bash
kill $(lsof -t -i :3001)  # Backend
kill $(lsof -t -i :5173)  # Frontend
```

## Next Step

See the [User Guide](./02-user-guide.md) to learn how to use all system features.