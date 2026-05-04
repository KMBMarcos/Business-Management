# Guía de Desarrollo - DevFast Manager

## Estructura del Proyecto

```
DevFast Manager/
├── backend/
│   ├── src/
│   │   ├── routes/        # Endpoints de API
│   │   │   ├── auth.ts    # Autenticación y usuarios
│   │   │   ├── projects.ts # Gestión de proyectos
│   │   │   ├── vps.ts     # Infraestructura
│   │   │   ├── finance.ts # Transacciones
│   │   │   ├── tasks.ts   # Tareas y bugs
│   │   │   ├── dashboard.ts # Dashboard y métricas
│   │   │   ├── chat.ts    # Chat interno
│   │   │   ├── activity.ts # Registro de actividad
│   │   │   └── settings.ts # Configuración empresa
│   │   ├── services/      # Lógica de negocio
│   │   │   ├── bootstrap.ts # Roles y settings base
│   │   │   ├── email.ts   # Envío de correos
│   │   │   ├── exchangeRates.ts # Tasas de cambio
│   │   │   └── activity.ts # Logging
│   │   ├── db.ts          # Cliente Prisma
│   │   ├── index.ts       # Servidor Fastify
│   │   └── types/         # Tipos TypeScript
│   ├── prisma/
│   │   └── schema.prisma  # Modelo de datos
│   └── package.json
│
├── frontend/
│   ├── src/
│   │   ├── api/
│   │   │   └── client.ts  # Cliente HTTP
│   │   ├── components/
│   │   │   └── Layout.tsx # Layout principal
│   │   ├── pages/         # Páginas React
│   │   ├── hooks/         # Hooks personalizados
│   │   │   ├── useAuth.tsx  # Autenticación
│   │   │   ├── useData.tsx  # React Query
│   │   │   └── useCompany.tsx # Datos empresa
│   │   └── utils/
│   │       └── userVisuals.tsx # Avatares y colores
│   └── package.json
│
└── Documentation/
    ├── es/  # Documentación en español
    └── en/  # Documentación en inglés
```

## Comandos de Desarrollo

### Backend

```bash
cd backend

# Desarrollo con hot-reload
npm run dev

# Compilar TypeScript
npm run build

# Iniciar producción
npm run start

# Generar cliente Prisma
npx prisma generate

# Sincronizar base de datos
npx prisma db push
```

### Frontend

```bash
cd frontend

# Desarrollo
npm run dev

# Build producción
npm run build

# Preview producción
npm run preview
```

## Agregar Nueva Ruta API

1. Crea el archivo en `backend/src/routes/`
2. Registra en `backend/src/index.ts`:

```typescript
import nuevaRuta from './routes/nuevaRuta.js'

await fastify.register(nuevaRuta, { prefix: '/api/nueva' })
```

## Agregar Nueva Página Frontend

1. Crea el componente en `frontend/src/pages/`
2. Registra la ruta en `frontend/src/App.tsx`:

```typescript
import NuevaPagina from './pages/NuevaPagina'

<Route path="/nueva" element={<NuevaPagina />} />
```

## Base de Datos

### Schema Prisma

Edita `backend/prisma/schema.prisma` para modificar modelos:

```prisma
model NuevoModelo {
  id        Int      @id @default(autoincrement())
  campo     String
  relacion  Relacion @relation(...)
}
```

Luego:
```bash
npx prisma db push
npx prisma generate
```

### Consultas Prisma

```typescript
// Encontrar uno
const user = await prisma.user.findUnique({ where: { id: 1 } })

// Crear
const nuevo = await prisma.user.create({
  data: { name: 'Nuevo', email: '...' }
})

// Actualizar
await prisma.user.update({
  where: { id: 1 },
  data: { name: 'Actualizado' }
})

// Eliminar
await prisma.user.delete({ where: { id: 1 } })
```

## Estilos

El frontend usa Tailwind CSS. Las clases de modo oscuro se configuran en `frontend/src/index.css`.

### Colores del Sistema

```css
/* Modo claro */
.bg-gray-50
.bg-white
.text-gray-800

/* Modo oscuro (override) */
.dark .bg-gray-50 { background-color: #0f172a; }
.dark .text-gray-800 { color: #e5e7eb; }
```

## Testing

```bash
# Backend - verificar compilación
npm run build

# Frontend - verificar build
cd frontend
npm run build

# Linting
npm run lint
```

## Agregar Dependencia

### Backend
```bash
cd backend
npm install nombre-paquete
```

### Frontend
```bash
cd frontend
npm install nombre-paquete
```

## Variables de Entorno para Desarrollo

```bash
# Backend
DATABASE_URL="file:./devfast.db"
JWT_SECRET="dev-secret"
PORT=3001

# Frontend
VITE_API_URL=http://localhost:3001
```

## Debugging

### Ver logs del servidor
Los logs de Fastify aparecen en la terminal. Para más detalle, el nivel de log puede modificarse en `backend/src/index.ts`.

### Inspecturar red
Usa las herramientas de desarrollo del navegador (F12 > Network) para ver las peticiones API.

### Base de datos
```bash
# Abrir shell de Prisma
npx prisma studio
```

## Convenciones de Código

- TypeScript strict mode
- Nombres de archivos en kebab-case (projects.ts, user-profile.tsx)
- Componentes React en PascalCase (ProjectManager.tsx)
- Hooks con prefijo "use" (useAuth.tsx)
- Rutas API en kebab-case (/api/my-resource)