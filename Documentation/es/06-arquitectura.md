# Arquitectura Técnica - DevFast Manager

## Visión General

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
│                    Base de Datos                            │
│                    SQLite / MySQL / PostgreSQL              │
└─────────────────────────────────────────────────────────────┘
```

## Backend

### Stack Tecnológico
- **Runtime**: Node.js 20.x
- **Framework**: Fastify 4.x
- **Lenguaje**: TypeScript strict
- **ORM**: Prisma 5.x
- **Auth**: JWT + bcrypt
- **WebSocket**: @fastify/websocket

### Estructura de Archivos

```
backend/src/
├── index.ts          # Entry point, configuración de Fastify
├── db.ts             # Cliente Prisma singleton
├── routes/           # Controladores/endpoints
│   ├── auth.ts       # Autenticación, usuarios, roles
│   ├── projects.ts   # CRUD proyectos
│   ├── vps.ts        # Infraestructura VPS
│   ├── finance.ts    # Transacciones financieras
│   ├── tasks.ts      # Tareas y bugs
│   ├── dashboard.ts  # Métricas y alertas
│   ├── chat.ts       # Chat WebSocket y HTTP
│   ├── activity.ts   # Registro de actividad
│   └── settings.ts   # Configuración empresa
├── services/         # Lógica de negocio
│   ├── bootstrap.ts  # Roles y settings iniciales
│   ├── email.ts      # Envío SMTP
│   ├── exchangeRates.ts # Fetch de tasas El Toque
│   └── activity.ts   # Helper de logging
└── types/            # TypeScript declarations
    └── fastify.d.ts  # Extensiones de tipos Fastify
```

### Flujo de una Solicitud

1. **Solicitud HTTP** llega a Fastify
2. **CORS** se valida (plugin @fastify/cors)
3. **JWT** se verifica (si endpoint autenticado)
4. **Route handler** ejecuta validación Zod
5. **Servicio** procesa lógica (Prisma)
6. **Respuesta** se envía al cliente

### Autenticación

```typescript
// Decorador authenticate
fastify.decorate('authenticate', async function(request, reply) {
  try {
    await request.jwtVerify()
  } catch (err) {
    reply.status(401).send({ error: 'Unauthorized' })
  }
})

// Uso en rutas
fastify.get('/ruta-protegida', { preHandler: [fastify.authenticate] }, handler)
```

### Base de Datos

**Modelos principales:**

- **User**: Usuarios del sistema
- **Role**: Roles (admin, member, etc.)
- **Project**: Proyectos
- **ProjectMember**: Relación usuario-proyecto
- **VpsServer**: Servidores VPS
- **InfrastructureItem**: Recursos de infraestructura
- **FinancialTransaction**: Transacciones financieras
- **Task / Bug**: Tareas y bugs
- **ChatChannel / ChatMessage**: Chat interno
- **ActivityLog**: Registro de actividad
- **Settings**: Configuración clave-valor
- **EmailOtp**: Códigos OTP

### Servicios

**bootstrap.ts**: Se ejecuta al iniciar el servidor.
- Crea roles base si no existen
- Crea settings de empresa por defecto
- No es idempotente (usa upsert)

**email.ts**: Envío de correos.
- Soporta SMTP con STARTTLS
- Fallback a consola en desarrollo
- Implementación manual (sin librería externa)

**exchangeRates.ts**: Fetch de tasas.
- Parsea HTML de eltoque.com
- Actualiza base de datos
- Scheduler cada 24h (setInterval)

## Frontend

### Stack Tecnológico
- **Framework**: React 19
- **Build**: Vite 8
- **Estilos**: Tailwind CSS 3.4
- **Estado**: React Query + Context
- **Gráficos**: Recharts
- **Iconos**: Lucide React
- **Router**: React Router DOM 7

### Estructura de Archivos

```
frontend/src/
├── App.tsx            # Router principal
├── main.tsx           # Entry point React
├── api/
│   └── client.ts      # Cliente HTTP con fetch
├── components/
│   └── Layout.tsx     # Layout con sidebar
├── pages/             # Componentes de página
│   ├── Login.tsx      # Login / Registro
│   ├── Dashboard.tsx  # Dashboard principal
│   ├── Projects.tsx   # Lista proyectos
│   ├── ProjectManager.tsx # Manager individual
│   ├── Infrastructure.tsx # VPS e infraestructura
│   ├── Finances.tsx   # Transacciones
│   ├── Tasks.tsx      # Tareas y bugs
│   ├── Team.tsx       # Miembros del equipo
│   ├── Chat.tsx       # Chat interno
│   ├── Notifications.tsx # Actividad
│   ├── Profile.tsx    # Mi perfil
│   ├── Settings.tsx   # Config empresa
│   └── UserProfile.tsx # Perfil público
├── hooks/
│   ├── useAuth.tsx    # Context auth
│   ├── useData.tsx    # Provider React Query
│   └── useCompany.tsx # Hook company settings
└── utils/
    └── userVisuals.tsx # Avatar, color, iniciales
```

### Cliente API

```typescript
// API_URL configurable por variable de entorno
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001'

// Clase con métodos convenientes
class ApiClient {
  async request<T>(endpoint, options) { ... }
  get<T>(endpoint) { ... }
  post<T>(endpoint, data) { ... }
  put<T>(endpoint, data) { ... }
  delete<T>(endpoint) { ... }
}
```

### Autenticación

- Token JWT almacenado en localStorage
- Token se incluye en header `Authorization: Bearer <token>`
- useAuth hook gestiona login/logout/profile

### Modo Oscuro

Implementado con CSS overrides en `index.css`:

```css
.dark body { background: #0f172a; }
.dark .bg-white { background-color: #111827 !important; }
/* etc */
```

Toggle en Layout usa `document.documentElement.classList.toggle('dark', value)` + localStorage.

### WebSocket (Chat)

```typescript
// Conexión
const socket = new WebSocket(`ws://host/api/chat/ws?token=${token}`)

// Eventos
socket.onmessage = (event) => {
  const payload = JSON.parse(event.data)
  if (payload.type === 'new_message') { ... }
}
```

Fallback a HTTP si WebSocket no disponible.

## Despliegue

### Desarrollo
- Backend: `npm run dev` (tsx watch)
- Frontend: `npm run dev` (Vite)

### Producción

**Backend:**
```bash
npm run build  # compila TypeScript
npm run start  # node dist/index.js
```

**Frontend:**
```bash
npm run build  # genera dist/
npm run preview # sirve dist/
```

### Variables de Entorno para Producción

**Backend:**
- `DATABASE_URL` - Connection string
- `JWT_SECRET` - Clave firma JWT
- `PORT` / `HOST` - Bind servidor
- `SMTP_*` - Configuración correo
- `NODE_ENV` - production/development

**Frontend:**
- `VITE_API_URL` - URL del backend

### VPS con Tailscale

1. Subir archivos
2. Ejecutar `deploy.sh` o manualmente
3. Configurar firewall:
   ```bash
   ufw allow from 100.64.0.0/10 to any port 3001
   ```
4. Acceder por IP Tailscale

## Seguridad

- Contraseñas hasheadas con bcrypt (10 rounds)
- JWT con expiración
- CORS configurable
- Validación de inputs con Zod
- SQL injection previene Prisma (ORM)
- Rate limiting no implementado (pendiente)

## Performance

- Base de datos SQLite para desarrollo
- React Query con staleTime de 30s
- Frontend ~750KB JS comprimido
- WebSocket para chat en tiempo real

## Pendientes / Mejoras

- Tests automatizados
- Rate limiting
- Notificaciones push
- Importación CSV
- Migración a MySQL/PostgreSQL para producción
- Upload de archivos (actualmente solo URLs)
- Dashboard más interactivo
- Métricas históricas