#!/bin/bash

set -e

echo "=========================================="
echo "🚀 DevFast Manager - Script de Despliegue"
echo "=========================================="

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Funciones
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detectar sistema operativo
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    else
        echo "unknown"
    fi
}

# Instalar Node.js si no existe
install_node() {
    log_info "Instalando Node.js..."
    OS=$(detect_os)
    
    case $OS in
        ubuntu|debian)
            curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
            apt-get install -y nodejs
            ;;
        fedora|rhel|centos)
            curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
            yum install -y nodejs
            ;;
        alpine)
            apk add nodejs npm
            ;;
        *)
            log_error "Sistema operativo no soportado: $OS"
            exit 1
            ;;
    esac
    
    log_info "Node.js $(node -v) instalado correctamente"
}

# Instalar dependencias del backend
install_backend_deps() {
    log_info "Instalando dependencias del backend..."
    cd backend
    npm install
    cd ..
}

# Instalar dependencias del frontend
install_frontend_deps() {
    log_info "Instalando dependencias del frontend..."
    cd frontend
    npm install
    cd ..
}

# Compilar proyecto
build_project() {
    log_info "Compilando backend..."
    cd backend
    npm run build
    cd ..
    
    log_info "Compilando frontend..."
    cd frontend
    npm run build
    cd ..
}

# Sincronizar base de datos
setup_database() {
    log_info "Sincronizando base de datos..."
    cd backend
    npx prisma db push
    cd ..
}

# Obtener IP pública
get_ip() {
    curl -s -4 ifconfig.me || curl -s -4 icanhazip.com || hostname -I | awk '{print $1}'
}

# Obtener URL de Tailscale
get_tailscale_ip() {
    if command -v tailscale &> /dev/null; then
        tailscale ip -4 2>/dev/null || echo ""
    else
        echo ""
    fi
}

# MAIN
log_info "Iniciando despliegue..."

# Verificar Node.js
if ! command -v node &> /dev/null; then
    log_warn "Node.js no encontrado"
    install_node
fi

# Instalar dependencias
if [ ! -d "backend/node_modules" ]; then
    install_backend_deps
fi

if [ ! -d "frontend/node_modules" ]; then
    install_frontend_deps
fi

# Compilar proyecto
build_project

# Setup base de datos
setup_database

# Obtener IPs
PUBLIC_IP=$(get_ip)
TAILSCALE_IP=$(get_tailscale_ip)

echo ""
echo "=========================================="
echo -e "${GREEN}✅ Despliegue completado!${NC}"
echo "=========================================="
echo ""
echo -e "IP Pública: ${YELLOW}$PUBLIC_IP${NC}"
if [ -n "$TAILSCALE_IP" ]; then
    echo -e "IP Tailscale: ${YELLOW}$TAILSCALE_IP${NC}"
fi
echo ""
echo "Acceso:"
echo -e "  - Backend API: http://$PUBLIC_IP:3001"
echo -e "  - Frontend Web: http://$PUBLIC_IP:5173"
if [ -n "$TAILSCALE_IP" ]; then
    echo -e "  - Backend (Tailscale): http://$TAILSCALE_IP:3001"
    echo -e "  - Frontend (Tailscale): http://$TAILSCALE_IP:5173"
fi
echo ""
echo "Para iniciar manualmente:"
echo "  Backend: cd backend && npm run dev"
echo "  Frontend: cd frontend && npm run dev"
echo ""
echo "Presiona Ctrl+C para salir o ejecuta en background:"
echo "  nohup npm run dev &"
echo "=========================================="

# Preguntar si ejecutar en background
read -p "¿Ejecutar servidor en background? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    log_info "Iniciando servidor en background..."
    cd backend
    nohup npm run dev > /tmp/devfast.log 2>&1 &
    echo $! > /tmp/devfast.pid
    cd ..
    sleep 3
    log_info "Servidor iniciado con PID $(cat /tmp/devfast.pid)"
    log_info "Ver logs: tail -f /tmp/devfast.log"
fi