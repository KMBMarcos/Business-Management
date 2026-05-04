# DevFast Manager - Inicio Rápido

## Requisitos Previos

- **Node.js** 20.x o superior
- **npm** 9.x o superior

## Instalación en 5 Minutos

### 1. Clonar el proyecto

```bash
git clone https://github.com/tu-usuario/DevFast-Manager.git
cd DevFast-Manager
```

### 2. Instalar dependencias

```bash
# Backend
cd backend
npm install

# Frontend (en otra terminal)
cd ../frontend
npm install
```

### 3. Configurar base de datos

```bash
cd backend
npx prisma db push
```

### 4. Iniciar servidores

**Terminal 1 - Backend (puerto 3001):**
```bash
cd backend
npm run dev
```

**Terminal 2 - Frontend (puerto 5173):**
```bash
cd frontend
npm run dev
```

### 5. Acceder

Abre tu navegador en: **http://localhost:5173**

## Primer Uso

1. En la página de login, haz clic en **"Registrarse"**
2. Ingresa tu email y solicita el código OTP
3. Revisa tu correo (o la consola del servidor si SMTP no está configurado)
4. Ingresa el código de 6 dígitos
5. Completa tu nombre y contraseña
6. ¡Listo! Ya puedes usar el sistema

El primer usuario registrado se convierte en **administrador**.

## Actualizar a producción

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

## Solución de Problemas

### "Cannot find module"
Vuelve a instalar las dependencias:
```bash
npm install
```

### Error de base de datos
Sincroniza el schema de Prisma:
```bash
npx prisma db push
```

### Puerto ocupado
Mata los procesos en los puertos:
```bash
kill $(lsof -t -i :3001)  # Backend
kill $(lsof -t -i :5173)  # Frontend
```

## Siguiente Paso

Ver la [Guía de Usuario](./02-guia-usuario.md) para aprender a usar todas las funciones del sistema.