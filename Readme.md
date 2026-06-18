# Protocolos cerveceros

## Desarrollo de una API REST para gestionar protocolos cerveceros

### Desarrollado por Javier Urbina


### Descripción

Este proyecto consta de una API REST que permite gestionar protocolos cerveceros. La API está implementada en Node.js y utiliza Express.js para manejar las peticiones HTTP.

### Funcionalidades

- Listado de protocolos cerveceros
- Creación de protocolos cerveceros
- Actualización de protocolos cerveceros
- Eliminación de protocolos cerveceros

### Tecnologías utilizadas

- Node.js
- Express.js
- PostgreSQL

### Instalación

1. Clonar el repositorio
2. Instalar dependencias: `npm install`
3. Configurar variables de entorno en el archivo `.env`
4. Iniciar el servidor: `npm run dev`

### Uso

La API se puede acceder a través de las siguientes rutas:

- GET /api/protocolos: Listado de protocolos cerveceros
- POST /api/protocolos: Creación de protocolos cerveceros
- PUT /api/protocolos/:id: Actualización de protocolos cerveceros
- DELETE /api/protocolos/:id: Eliminación de protocolos cerveceros

### Licencia

MIT
