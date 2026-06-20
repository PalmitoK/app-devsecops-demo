# ─────────────────────────────────────────────────────────────────
# ETAPA 1: Build (Compilación) - Solo para construir el proyecto
# ─────────────────────────────────────────────────────────────────
FROM node:22-alpine AS builder

WORKDIR /app

# Copiar manifiestos de dependencias
COPY package*.json ./

# Instalar solo dependencias de producción de forma limpia
RUN npm ci --only=production

# Copiar el código fuente y compilar
COPY . .
RUN npm run build

# ─────────────────────────────────────────────────────────────────
# ETAPA 2: Runtime (Ejecución en producción) - IMAGEN FINAL SEGURA
# ─────────────────────────────────────────────────────────────────
FROM node:22-alpine AS runtime

# El parche de seguridad del sistema operativo Alpine
RUN apk update && apk upgrade --no-cache

# Crear un grupo y un usuario de sistema sin privilegios (no usar root)
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app

# Copiar solo el artefacto compilado y los paquetes de producción de la etapa anterior
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

# Cambiar el propietario de los archivos al usuario seguro
RUN chown -R appuser:appgroup /app

# Decirle a Docker que use el usuario sin privilegios
USER appuser

# Documentar el puerto de la aplicación
EXPOSE 3000

# Verificación de salud para monitorear el estado del contenedor
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

# Comando de ejecución
CMD ["node", "dist/index.js"]
