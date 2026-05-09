# DevFast Manager

Sistema de gestión integral para DevFast - Control de proyectos, infraestructura, finanzas y equipo.

## Stack Tecnológico

- **Backend**: Node.js + Fastify + TypeScript + Prisma
- **Frontend**: React + Vite + TypeScript + Tailwind CSS
- **Base de datos**: SQLite (configurado) - puede cambiarse a MySQL/PostgreSQL
- **Gráficos**: Recharts

## Estructura del Proyecto

```
DevFast Manager/
├── backend/          # API REST
│   ├── src/
│   │   ├── routes/   # Endpoints de API
│   │   ├── services/ # Lógica de negocio
│   │   ├── db.ts     # Conexión a Prisma
│   │   └── index.ts  # Servidor principal
│   ├── prisma/       # Schema de base de datos
│   └── package.json
├── frontend/         # Aplicación React
│   ├── src/
│   │   ├── api/     # Cliente API
│   │   ├── components/  # Componentes UI
│   │   ├── pages/    # Páginas
│   │   ├── hooks/   # Custom hooks
│   │   └── App.tsx  # App principal
│   └── package.json
├── deploy.sh         # Script de despliegue
├── Documentation/     # Documentación
│   ├── es/           # Español
│   └── en/           # English
└── README.md
```

## Documentación

### 🇪🇸 Español
- [Inicio Rápido](./Documentation/es/01-inicio-rapido.md) - Primeros pasos
- [Guía de Usuario](./Documentation/es/02-guia-usuario.md) - Uso del sistema
- [Configuración](./Documentation/es/03-configuracion.md) - Variables de entorno
- [Desarrollo](./Documentation/es/04-desarrollo.md) - Para desarrolladores
- [API](./Documentation/es/05-api.md) - Endpoints
- [Arquitectura](./Documentation/es/06-arquitectura.md) - Detalles técnicos

### 🇬🇧 English
- [Quick Start](./Documentation/en/01-quick-start.md) - First steps
- [User Guide](./Documentation/en/02-user-guide.md) - System usage
- [Configuration](./Documentation/en/03-configuration.md) - Environment variables
- [Development](./Documentation/en/04-development.md) - For developers
- [API](./Documentation/en/05-api.md) - Endpoints
- [Architecture](./Documentation/en/06-architecture.md) - Technical details

## Instalación

### Producción rápida con Docker Compose

```bash
cp .env.example .env
cp backend/.env.example backend/.env
cp frontend/.env.example frontend/.env
# Edita backend/.env: JWT_SECRET y SMTP_* son obligatorios en producción
docker compose up -d --build
```

Acceso por defecto:

```text
http://localhost:8080
http://<hostname-tailscale>:8080
```

Ver detalles en [DEPLOYMENT.md](./DEPLOYMENT.md).

### Desarrollo

Backend:

```bash
cd backend
cp .env.example .env
npm install
npx prisma generate
npx prisma db push
npm run dev         # puerto 3001 por defecto
```

Frontend:

```bash
cd frontend
cp .env.example .env
npm install
npm run dev         # puerto 5173
```

El frontend usa API relativa por defecto en producción. Para desarrollo con servidores separados puedes definir `VITE_API_URL=http://localhost:3001`.

## Características

### Dashboard
- Resumen de ingresos/gastos/beneficios
- Proyectos activos y métricas
- Alertas (VPS sin proyecto, bugs críticos, tareas vencidas)
- Tasas de cambio USD/USDT/CUP desde El Toque (auto-actualización cada 24h)
- Modo oscuro mejorado con alertas visuales

### Proyectos
- CRUD de proyectos
- Estados: ACTIVE, PAUSED, ABANDONED, EXPERIMENTAL, RENTABLE
- Miembros y responsables múltiples
- Métricas de usuarios (totales, activos, pagados, referidos, gratis, colaboración)
- URLs públicas

### Infraestructura
- Servidores VPS con proveedor, costo, specs
- Items de infraestructura (dominios, DBs, SSL, etc.)
- Vinculación a proyectos con porcentaje de costo
- Proveedores
- Resumen de costos mensuales

### Finanzas
- Transacciones de ingresos y gastos
- Monedas: USD, EUR, CUP, USDT, MLC
- Tasas de cambio configurables manualmente
- Fetch automático de tasas desde eltoque.com
- Impacto por variación de moneda
- Resumen por proyecto

### Tareas y Bugs
- Kanban de tareas por estado y prioridad
- Bugs con severidad (critical, high, medium, low)
- Filtros por proyecto
- Resumen general por proyecto
- Muestra creador y asignado con avatar y enlace a perfil

### Equipo
- Miembros del equipo
- Roles configurables (admin, founder, cofounder, marketing, developer, etc.)
- Proyectos asignados por miembro
- Perfil público con enlaces a redes sociales
- Cambio de roles desde la interfaz

### Chat Interno
- Canales: Empresa, Cofundadores, y privados
- WebSocket con fallback HTTP
- Mensajes persistentes en base de datos
- Muestra avatar y nombre con enlace al perfil

### Perfil de Usuario
- Nombre, bio, avatar
- Color personalizado
- Enlaces: GitHub, Facebook, LinkedIn, Website personal
- Perfil público visible desde Equipo, Chat y Tareas

### Configuración de Empresa
- Nombre de empresa (personalizable,代替 DevFast)
- Objetivo del manager
- Logo URL
- Disponible en UI: `/settings`

### Registro con OTP
- Solicita código OTP por correo antes de registrar
- SMTP configurable via variables de entorno
- Fallback a consola en desarrollo
- 6 dígitos, validez 10 minutos

### Modo Oscuro
- Toggle en header
- Persistencia en localStorage
- CSS optimizado para alertas, colores y scrollbars
- Responsive diseño móvil

### Reportes
- Gráfico de ingresos/gastos (12 meses)
- Distribución de beneficios por proyecto
- Top 5 proyectos rentables
- Proyectos en pérdida
- Comparativa completa

## Configuración

### Variables de entorno (backend/.env)

```bash
# Base de datos
DATABASE_URL="file:./devfast.db"

# Autenticación
JWT_SECRET="tu-secret-muy-seguro"

# Servidor
PORT=3001
HOST=0.0.0.0

# Tasas de cambio
EL_TOQUE_URL="https://eltoque.com/tasas-de-cambio-de-moneda-en-cuba-hoy"

# SMTP para OTP (Gmail example)
SMTP_HOST="smtp.gmail.com"
SMTP_PORT=587
SMTP_USER="tu-email@gmail.com"
SMTP_PASS="tu-app-password"
SMTP_FROM="tu-email@gmail.com"

# Entorno
NODE_ENV=production
```

### Configurar URL del frontend

```bash
VITE_API_URL=http://TU_IP:3001 npm run dev
```

### Cambiar a MySQL/PostgreSQL

1. Cambiar el provider en `backend/prisma/schema.prisma`
2. Actualizar DATABASE_URL
3. Ejecutar `npx prisma db push`

## Uso

1. Inicia el backend: `cd backend && npm run dev`
2. Inicia el frontend: `cd frontend && npm run dev`
3. Abre http://localhost:5173
4. Regístrate (recibirás código OTP por correo o consola)
5. Comienza a agregar proyectos, VPS, transacciones, etc.

## Despliegue en VPS

1. Sube el archivo `DevFast-Manager.tar.gz` a tu VPS
2. Descomprime: `tar -xzvf DevFast-Manager.tar.gz`
3. Ejecuta: `chmod +x deploy.sh && ./deploy.sh`

El script detectará el SO, instalará Node.js si falta, dependencias, compilará yArrancará el servidor.

## API Endpoints

### Autenticación
- `POST /api/auth/request-otp` - Solicitar código OTP
- `POST /api/auth/register` - Registro con OTP
- `POST /api/auth/login` - Login
- `GET /api/auth/me` - Usuario actual
- `PUT /api/auth/me` - Actualizar perfil
- `GET /api/auth/users` - Lista usuarios
- `GET /api/auth/users/:id` - Perfil público de usuario
- `GET /api/auth/roles` - Lista roles
- `PUT /api/auth/users/:id/role` - Cambiar rol

### Proyectos
- `GET /api/projects` - Lista proyectos
- `POST /api/projects` - Crear proyecto
- `PUT /api/projects/:id` - Actualizar proyecto
- `DELETE /api/projects/:id` - Eliminar proyecto
- `GET /api/projects/:id` - Ver proyecto
- `POST /api/projects/:id/metrics` - Agregar métricas

### Infraestructura
- `GET /api/vps/providers` - Lista proveedores
- `GET /api/vps/servers` - Lista servidores
- `POST /api/vps/servers` - Crear servidor
- `GET /api/vps/items` - Lista items
- `POST /api/vps/items` - Crear item
- `GET /api/vps/costs` - Resumen de costos

### Finanzas
- `GET /api/finance/transactions` - Transacciones
- `POST /api/finance/transactions` - Crear transacción
- `GET /api/finance/summary` - Resumen financiero
- `GET /api/finance/rates/latest` - Tasas actuales

### Tareas y Bugs
- `GET /api/tasks/tasks` - Lista tareas
- `POST /api/tasks/tasks` - Crear tarea
- `GET /api/tasks/bugs` - Lista bugs
- `POST /api/tasks/bugs` - Crear bug
- `GET /api/tasks/overview` - Resumen

### Dashboard
- `GET /api/dashboard` - Overview general
- `GET /api/dashboard/alerts` - Alertas
- `GET /api/dashboard/charts/income-expense` - Gráfico ingresos/gastos

### Chat
- `GET /api/chat/channels` - Canales del usuario
- `GET /api/chat/channels/:id/messages` - Mensajes
- `POST /api/chat/channels/:id/messages` - Enviar mensaje
- `POST /api/chat/private` - Crear canal privado
- WebSocket: `ws://host/api/chat/ws?token=...`

### Configuración
- `GET /api/settings/company` - Ver configuración de empresa
- `PUT /api/settings/company` - Actualizar empresa

## Estado del Proyecto

✅ Completado:
- Autenticación JWT con bcrypt
- Roles base y permisos
- CRUD completo de proyectos
- Gestión de infraestructura (VPS, items)
- Finanzas con conversión de monedas
- Tareas y bugs con creadores/asignados
- Dashboard con métricas
- Reportes gráficos
- Chat interno con WebSocket
- Perfiles de usuario extendidos
- Perfiles públicos enlazados desde equipo/chat/tareas
- Configuración de empresa personalizable
- Registro con OTP por correo
- Modo oscuro global
- Diseño responsive móvil
- Integración con El Toque (tasas automáticas cada 24h)

⏳ Pendiente:
- Importación CSV
- Notificaciones push
- Más integraciones de monitoreo
- Tests automatizados
