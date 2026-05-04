# Documentación de API - DevFast Manager

## Autenticación

### POST /api/auth/request-otp
Solicita un código OTP para registro.

**Body:**
```json
{
  "email": "usuario@ejemplo.com"
}
```

**Respuesta:**
```json
{
  "success": true,
  "expiresAt": "2024-01-01T12:00:00.000Z",
  "devCode": "123456"  // Solo en desarrollo
}
```

---

### POST /api/auth/register
Registra un nuevo usuario.

**Body:**
```json
{
  "email": "usuario@ejemplo.com",
  "password": "contraseña123",
  "name": "Nombre Usuario",
  "otp": "123456"
}
```

**Respuesta:**
```json
{
  "user": {
    "id": 1,
    "email": "...",
    "name": "...",
    "role": "member",
    "avatar": null,
    "color": "#7C9CBF",
    "bio": null,
    "githubUrl": null,
    "facebookUrl": null,
    "linkedinUrl": null,
    "websiteUrl": null
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### POST /api/auth/login
Inicia sesión.

**Body:**
```json
{
  "email": "usuario@ejemplo.com",
  "password": "contraseña123"
}
```

**Respuesta:** Mismo formato que register.

---

### GET /api/auth/me
Obtiene el usuario actual (requiere autenticación).

**Headers:**
```
Authorization: Bearer <token>
```

---

### PUT /api/auth/me
Actualiza el perfil del usuario actual.

**Body:**
```json
{
  "name": "Nuevo Nombre",
  "bio": "Mi bio",
  "avatar": "https://...",
  "color": "#FF5733",
  "githubUrl": "https://github.com/user",
  "facebookUrl": "https://facebook.com/user",
  "linkedinUrl": "https://linkedin.com/in/user",
  "websiteUrl": "https://miweb.com"
}
```

---

### GET /api/auth/users
Lista todos los usuarios (requiere autenticación).

---

### GET /api/auth/users/:id
Obtiene perfil público de un usuario.

---

### GET /api/auth/roles
Lista todos los roles disponibles.

---

### PUT /api/auth/users/:id/role
Cambia el rol de un usuario.

**Body:**
```json
{
  "roleId": 2
}
```

---

## Proyectos

### GET /api/projects
Lista todos los proyectos.

### GET /api/projects/:id
Obtiene un proyecto específico con todos sus datos.

### POST /api/projects
Crea un nuevo proyecto.

**Body:**
```json
{
  "name": "Mi Proyecto",
  "description": "Descripción",
  "status": "ACTIVE",
  "publicUrl": "https://mi-proyecto.com"
}
```

### PUT /api/projects/:id
Actualiza un proyecto.

### DELETE /api/projects/:id
Elimina un proyecto.

### POST /api/projects/:id/metrics
Agrega métricas de usuarios.

**Body:**
```json
{
  "totalUsers": 100,
  "activeUsers": 50,
  "paidUsers": 20,
  "referralUsers": 10,
  "freeUsers": 70,
  "collaborationUsers": 5
}
```

---

## Infraestructura

### GET /api/vps/providers
Lista proveedores.

### POST /api/vps/providers
Crea proveedor.

### GET /api/vps/servers
Lista servidores VPS.

### POST /api/vps/servers
Crea servidor VPS.

### POST /api/vps/servers/:id/link
Vincula servidor a proyecto.

**Body:**
```json
{
  "projectId": 1,
  "costShare": 50
}
```

### GET /api/vps/items
Lista items de infraestructura.

### POST /api/vps/items
Crea item.

### GET /api/vps/costs
Resumen de costos mensuales.

---

## Finanzas

### GET /api/finance/transactions
Lista transacciones.

**Query params:**
- `projectId` - Filtrar por proyecto
- `type` - INCOME o EXPENSE
- `startDate` - Fecha inicio
- `endDate` - Fecha fin

### POST /api/finance/transactions
Crea transacción.

**Body:**
```json
{
  "projectId": 1,
  "type": "INCOME",
  "amount": 100.00,
  "currency": "USD",
  "description": "Pago de cliente",
  "date": "2024-01-15"
}
```

### GET /api/finance/summary
Resumen financiero general.

### GET /api/finance/rates/latest
Tasas de cambio actuales.

### POST /api/finance/rates
Agregar tasa manualmente.

**Body:**
```json
{
  "code": "EUR",
  "rate": 0.85,
  "source": "manual"
}
```

---

## Tareas y Bugs

### GET /api/tasks/tasks
Lista tareas.

**Query params:**
- `projectId`
- `status`
- `assigneeId`

### POST /api/tasks/tasks
Crea tarea.

**Body:**
```json
{
  "projectId": 1,
  "title": "Nueva tarea",
  "description": "Descripción",
  "priority": "medium",
  "status": "PENDING",
  "assigneeId": 1,
  "dueDate": "2024-01-20"
}
```

### GET /api/tasks/bugs
Lista bugs.

### POST /api/tasks/bugs
Reporta bug.

**Body:**
```json
{
  "projectId": 1,
  "title": "Bug encontrado",
  "description": "Descripción del bug",
  "severity": "high",
  "status": "OPEN"
}
```

### GET /api/tasks/overview
Resumen de tareas y bugs.

---

## Dashboard

### GET /api/dashboard
Overview general del sistema.

### GET /api/dashboard/alerts
Lista de alertas del sistema.

### GET /api/dashboard/exchange-rate/fetch
Fuerza actualización de tasas de cambio.

### GET /api/dashboard/charts/income-expense
Gráfico de ingresos/gastos.

**Query params:**
- `months` - Número de meses (default 6)

### GET /api/dashboard/charts/project-performance
Rendimiento de proyectos.

---

## Chat

### GET /api/chat/channels
Lista canales del usuario.

### GET /api/chat/channels/:id/messages
Mensajes de un canal.

### POST /api/chat/channels/:id/messages
Envía mensaje.

**Body:**
```json
{
  "content": "Hola equipo!"
}
```

### POST /api/chat/private
Crea canal privado con otro usuario.

**Body:**
```json
{
  "userId": 2
}
```

### WebSocket /api/chat/ws
Conectar al chat en tiempo real.

**URL:**
```
ws://host/api/chat/ws?token=<jwt_token>
```

**Mensajes (enviar):**
```json
{
  "type": "message",
  "channelId": 1,
  "content": "Mensaje"
}
```

**Mensajes (recibir):**
```json
{
  "type": "new_message",
  "channelId": 1,
  "message": { ... }
}
```

---

## Configuración

### GET /api/settings/company
Obtiene configuración de la empresa.

### PUT /api/settings/company
Actualiza configuración.

**Body:**
```json
{
  "companyName": "Mi Empresa",
  "companyObjective": "Objetivo del manager",
  "companyLogoUrl": "https://logo.png"
}
```

---

## Códigos de Error

| Código | Significado |
|--------|-------------|
| 400 | Solicitud inválida |
| 401 | No autorizado |
| 403 | Prohibido |
| 404 | No encontrado |
| 500 | Error del servidor |