# Guía de Usuario - DevFast Manager

## Introducción

DevFast Manager es un sistema integral de gestión que te permite administrar proyectos, infraestructura, finanzas, equipo y tareas desde una sola plataforma.

## Navegación

El menú lateral contiene:
- **Dashboard**: Vista general del sistema
- **Proyectos**: Gestión de proyectos
- **Infraestructura**: VPS, servidores y recursos
- **Finanzas**: Transacciones y métricas
- **Tareas**: Tareas y bugs
- **Equipo**: Miembros del equipo
- **Chat**: Comunicación interna
- **Notificaciones**: Actividad del sistema
- **Mi Perfil**: Configuración personal
- **Empresa**: Configuración de la organización

## Funciones Principales

### Dashboard

Muestra una vista resumida de:
- Ingresos y gastos totales
- Proyectos activos
- Servidores y costos de infraestructura
- Alertas del sistema (VPS sin proyecto, bugs críticos, tareas vencidas)
- Gráfico de tendencias financieras

### Proyectos

**Crear proyecto:**
1. Ve a Proyectos
2. Haz clic en "Nuevo Proyecto"
3. Completa: nombre, descripción, estado, URL pública
4. Asigna miembros y define responsables

**Estados de proyecto:**
- ACTIVE: En desarrollo activo
- RENTABLE: Generando ingresos
- PAUSED: En pausa temporal
- ABANDONED: Abandonado
- EXPERIMENTAL: En pruebas

### Infraestructura

**Servidores VPS:**
- Agrega servidores con IP, proveedor, costo mensual
- Vincula cada servidor a uno o más proyectos
- Define el porcentaje de costo que asume cada proyecto

**Items de infraestructura:**
- Dominios, certificados SSL, bases de datos, etc.
- Asociación a proyectos similar a los VPS

### Finanzas

**Transacciones:**
- Registra ingresos y gastos
- Selecciona la moneda (USD, EUR, CUP, USDT, MLC)
- Asocia a un proyecto específico

**Tasas de cambio:**
- Se actualizan automáticamente desde El Toque cada 24h
- También puedes agregarlas manualmente

### Tareas y Bugs

**Tareas:**
- Crear, editar, eliminar
- Asignar a miembros del equipo
- Definir prioridad (low, medium, high)
- Estados: Pendiente, En Progreso, Completada, Cancelada

**Bugs:**
- Reportar bugs con severidad (low, medium, high, critical)
- Estados: Abierto, En Progreso, Resuelto, Cerrado

### Equipo

- Ver todos los miembros del equipo
- Cambiar roles (admin, founder, cofounder, developer, etc.)
- Ver proyectos asignados a cada miembro
- Acceder al perfil público de cada usuario

### Chat

- **Canal Empresa**: Para todos los miembros
- **Canal Cofundadores**: Solo para roles de liderazgo
- **Privados**: Conversaciones entre dos personas
- Mensajes en tiempo real (WebSocket)

### Perfil Personal

Editable en "Mi Perfil":
- Nombre
- Foto de perfil (URL)
- Color personalizado
- Bio / descripción
- Enlaces: GitHub, Facebook, LinkedIn, Website

## Modo Oscuro

Haz clic en el icono de sol/luna en el header para alternar entre modo claro y oscuro. La preferencia se guarda en tu navegador.

## Configuración de Empresa

En la sección "Empresa" (solo administradores):
- Nombre de la empresa/organización
- Objetivo del manager
- Logo (URL)

Esta configuración aparece en el login, header y throughout la aplicación.

## Tips

1. **Usa las alertas**: El dashboard muestra advertencias importantes
2. **Registra transacciones**: Mantén el control financiero actualizado
3. **Vincula recursos**: Asocia VPS e infraestructura a proyectos para ver costos reales
4. **Actualiza métricas**: Registra usuarios de cada proyecto regularmente
5. **Revisa notificaciones**: Mantente al día con la actividad del equipo