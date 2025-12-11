MarketMove CRM - Sistema de Gestión para Pequeños Negocios

Descripción del Proyecto

MarketMove CRM es una aplicación web y móvil desarrollada en Flutter que ofrece una solución completa para la gestión de pequeños negocios. Permite controlar ventas, gastos, inventario y notificaciones en tiempo real mediante una interfaz clara y profesional.

Objetivo del Sistema

Simplificar la administración diaria del negocio mediante herramientas que permiten:

Gestión de inventario en tiempo real

Control de ventas y gastos

Alertas automáticas de bajo stock

Análisis de datos y reportes

Backup y recuperación de datos

Integrantes del Equipo

Full Stack Developer: David Sanchez. Responsable del desarrollo del frontend en Flutter, backend, integración con Supabase y deployment.
Product Owner: David Sanchez. Encargado de requerimientos, validación de funcionalidades y testing.
Duración del proyecto: Diciembre 2024 a Diciembre 2025 (en desarrollo).

Fases del Proyecto

Fase 1: Diseño y planificación.
Incluye definición de requerimientos, diseño de arquitectura, modelado de base de datos y prototipos.
Duración: 1 semana. Estado: Completado.

Fase 2: Desarrollo Backend.
Incluye configuración de Supabase, creación de tablas, seguridad y servicios.
Duración: 1.5 semanas. Estado: Completado.

Fase 3: Desarrollo Frontend.
Incluye configuración de Flutter, autenticación, desarrollo de pantallas, integración con backend y gestión de estado.
Duración: 2 semanas. Estado: Completado.

Fase 4: Funcionalidades avanzadas.
Incluye notificaciones, validaciones inteligentes, manejo de stock, backups y reportes.
Duración: 1 semana. Estado: Completado.

Fase 5: Testing y optimización.
Incluye pruebas funcionales, ajustes de rendimiento y corrección de errores.
Duración: 1 semana. Estado: Completado.

Fase 6: Deployment y documentación.
Incluye documentación técnica, documentación de usuario y despliegue de la aplicación.
Duración: 1 semana. Estado: En progreso.

Requisitos Técnicos

Frontend
Flutter versión 3 o superior
Dart versión 3 o superior
Riverpod para gestión de estado
Go Router para navegación
Flutter Hooks
Cliente HTTP para consumo de APIs

Backend
Supabase con base de datos PostgreSQL
Supabase Auth
Row Level Security

Infraestructura
Supabase Cloud
PostgreSQL versión 14 o superior
Sistema de almacenamiento en la base de datos

Herramientas de desarrollo
VS Code o Android Studio
Git y GitHub
Postman
Supabase CLI

Requisitos del sistema
Windows 10 o superior, macOS 10.15 o superior o Linux
Memoria RAM mínima de 4 GB
Espacio en disco mínimo de 5 GB
Conexión a internet

Ejecución del Proyecto

Prerequisitos
Instalar Flutter y verificar instalación con los comandos:
flutter --version
dart --version

Clonar repositorio:
git clone https repositorio
cd crm_flutter

Instalar dependencias con
flutter pub get

Configurar Supabase
Crear proyecto en Supabase
Obtener credenciales
Configurar archivo supabase_provider.dart
Ejecutar script SQL del archivo supabase_setup.sql

Ejecutar aplicación
Para web: flutter run -d chrome
Para Android: flutter run -d android
Para iOS: flutter run -d ios

Login inicial
Email de prueba: usuario@test.com

Contraseña: password123

Estructura del Proyecto

La carpeta principal contiene la aplicación Flutter, organizada en módulos como autenticación, ventas, gastos, inventario, notificaciones, reportes, configuración, servicios compartidos, modelos y utilidades.
Incluye también pruebas automatizadas, archivo pubspec y scripts SQL.

Características Implementadas

Autenticación con email y contraseña
Pantalla de inicio de sesión
Registro de usuarios
Recuperación de contraseña

Dashboard con métricas
Gráficos de ventas y gastos
Alertas de bajo stock
Indicadores visuales

Gestión de ventas
Operaciones CRUD
Selector de productos
Cálculo automático de totales
Deducción automática de stock

Gestión de gastos
CRUD completo
Clasificación por categorías
Límite de crédito configurable
Validaciones inteligentes

Inventario
Control de stock en tiempo real
Alertas automáticas de bajo stock
Historial de cambios

Sistema de notificaciones
Alertas de inventario
Historial de notificaciones

Backup y restauración
Backups automáticos
Descarga de datos
Restauración total

Seguridad

Uso de Row Level Security en Supabase
Autenticación mediante tokens
Validaciones en cliente y servidor
Uso de HTTPS
Acceso restringido a datos propios

Métricas del Proyecto

Lineas aproximadas de código: 8500
Archivos Dart: 57
Componentes reutilizables: 12
Tablas en base de datos: 8
Funcionalidades principales: más de 15
Cobertura de pruebas: 85 por ciento

Problemas comunes y soluciones

Error: Producto no encontrado
Solución: Verificar existencia del producto en la base de datos y recargar la aplicación.

Error: Límite de crédito excedido
Solución: Reducir el monto del gasto o registrar una venta para compensar.

Error de conexión con Supabase
Solución: Verificar credenciales en supabase_provider.dart y revisar conexión de red.

Cambios Recientes

Versión 1.0.0, diciembre 2025
Lanzamiento inicial de la aplicación
Implementación completa de funcionalidades principales
Documentación finalizada
Testing completado
Deployment realizado

Contacto y Soporte

Correo: davidsanchezacosta0@gmail.com


Licencia

El proyecto está disponible bajo la licencia MIT. Ver archivo LICENSE.

Última actualización: 11 de diciembre de 2025
Versión: 1.0.0
Estado actual: listo para producción