# CoppelEmprende

Aplicación móvil y web para la gestión y seguimiento de microempresarios por parte de los colaboradores de Coppel.

## Descripción

CoppelEmprende es una plataforma destinada a facilitar el registro, seguimiento y gestión de microempresarios por parte de los colaboradores de Coppel. La aplicación permite:

- Autenticación de colaboradores
- Registro de microempresarios
- Seguimiento del progreso de los microempresarios
- Sistema de puntos y recompensas

## Tecnologías

- **Flutter**: Framework de UI para desarrollo multiplataforma
- **Dart**: Lenguaje de programación
- **Supabase**: Backend as a Service para autenticación y base de datos
- **Material Design**: Guía de diseño para la interfaz de usuario

## Requisitos

- Flutter SDK (versión 3.7.2 o superior)
- Dart SDK (versión 3.7.2 o superior)
- Cuenta en Supabase
- Editor de código (recomendado: VS Code o Android Studio)

## Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/winouwu/coppel_emprende.git
   cd coppelemprende
   ```

2. Instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Configura tu proyecto de Supabase:
   - Crea un proyecto en [Supabase](https://supabase.io/)
   - Copia las credenciales de tu proyecto (URL y clave anónima)
   - Crea un archivo `lib/core/constants/supabase_constants.dart` con las siguientes constantes:
     ```dart
     import 'package:supabase_flutter/supabase_flutter.dart';

     ```

4. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## Estructura del Proyecto

```
lib/
├── core/               # Componentes principales
│   ├── constants/      # Constantes de la aplicación
│   ├── supabase/       # Cliente y configuración de Supabase
│   └── theme/          # Tema de la aplicación
├── features/           # Características principales
│   ├── auth/           # Autenticación
│   ├── collaborators/  # Gestión de colaboradores
│   ├── microempresarios/ # Gestión de microempresarios
│   ├── registros/      # Registros de microempresarios
│   └── ...
├── home/               # Pantalla principal
├── routes/             # Configuración de rutas
└── main.dart           # Punto de entrada de la aplicación
```

## Características Principales

### Autenticación
- Inicio de sesión para colaboradores
- Verificación de tipo de usuario

### Colaboradores
- Vista de listado de colaboradores
- Filtrado y búsqueda
- Métricas de desempeño (registros, puntos)

### Microempresarios
- Registro de nuevos microempresarios
- Seguimiento de progreso
- Gestión de lecciones completadas y webinars



## Contribución

Para contribuir al proyecto:

1. Crea un fork del repositorio
2. Crea una rama para tu característica (`git checkout -b feature/amazing-feature`)
3. Realiza tus cambios y haz commit (`git commit -m 'Add some amazing feature'`)
4. Haz push a la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request


