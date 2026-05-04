# Configuración - DevFast Manager

## Variables de Entorno

El archivo `.env` en la carpeta `backend/` contiene la configuración del sistema.

### Base de Datos

```bash
# SQLite (por defecto)
DATABASE_URL="file:./devfast.db"

# MySQL
DATABASE_URL="mysql://user:password@localhost:3306/devfast"

# PostgreSQL
DATABASE_URL="postgresql://user:password@localhost:5432/devfast"
```

### Servidor

```bash
# Puerto donde escuchará el backend
PORT=3001

# Host (0.0.0.0 para todas las interfaces)
HOST=0.0.0.0

# Clave secreta para JWT (cambia en producción!)
JWT_SECRET="tu-clave-secreta-muy-larga-y-segura"
```

### Tasas de Cambio

```bash
# URL de El Toque para obtener tasas (opcional)
EL_TOQUE_URL="https://eltoque.com/tasas-de-cambio-de-moneda-en-cuba-hoy"
```

### Correo SMTP (para OTP)

```bash
# Servidor SMTP
SMTP_HOST="smtp.gmail.com"
SMTP_PORT=587
SMTP_USER="tu-email@gmail.com"
SMTP_PASS="tu-app-password"
SMTP_FROM="tu-email@gmail.com"

# true para puerto 465, false para 587/25
SMTP_SECURE=false
```

### Entorno

```bash
# development o production
NODE_ENV=development
```

## Configurar URL del Frontend

El frontend necesita saber dónde está el backend:

```bash
# Desarrollo
VITE_API_URL=http://localhost:3001 npm run dev

# Producción con IP específica
VITE_API_URL=http://100.x.x.x:3001 npm run build
```

O edita directamente en `frontend/src/api/client.ts`:

```typescript
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001';
```

## Despliegue en VPS

### Script Automático

```bash
chmod +x deploy.sh
./deploy.sh
```

El script:
1. Detecta el sistema operativo
2. Instala Node.js si no existe
3. Instala dependencias
4. Compila proyecto
5. Configura base de datos
6. Pregunta si iniciar en background

### Manual

```bash
# Backend
cd backend
npm install
npx prisma db push
npm run build
HOST=0.0.0.0 PORT=3001 npm run start

# Frontend (en otra terminal)
cd frontend
npm install
VITE_API_URL=http://TU_IP:3001 npm run build
npm run preview -- --host --port 80
```

## Cambiar Nombre de Empresa

1. Ve a la sección **Empresa** en el menú
2. Edita el nombre, objetivo y logo
3. Los cambios se aplican inmediatamente

## Configurar Tareas Programadas

El sistema actualiza tasas de cambio automáticamente cada 24 horas al iniciar el servidor. No requiere configuración adicional.

## Seguridad

1. **JWT_SECRET**: Cambia la clave por defecto
2. **SMTP**: Usa una contraseña de aplicación (no tu contraseña real de Gmail)
3. **Firewall**: Si usas VPS, configura reglas de firewall para limitar acceso

## Puertos Comunes

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| Backend API | 3001 | API REST |
| Frontend Dev | 5173 | Servidor desarrollo |
| Frontend Prod | 4173 | Servidor preview |
| Nginx (custom) | 80 | Producción con nginx |

## Troubleshooting

### Error de conexión a base de datos
```bash
npx prisma db push
```

### Puerto ocupado
```bash
lsof -i :3001
kill -9 PID
```

### CORS error
Asegúrate de que el backend está escuchando en `0.0.0.0` y que el frontend tiene la URL correcta en `VITE_API_URL`.

### OTP no llega al correo
Verifica la configuración SMTP. El código también se muestra en la consola del servidor si `NODE_ENV=development`.