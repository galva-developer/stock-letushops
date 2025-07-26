# 📱 Stock LetuShops

**Aplicación móvil inteligente para la gestión de inventario de LETUSHOPS**

Una aplicación Flutter revolucionaria que optimiza la gestión de stock mediante el reconocimiento automático de productos a través de fotografías, integrando inteligencia artificial para extraer características y almacenarlas en una base de datos NoSQL en Firebase.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)

## 🚀 Características Principales

### 📸 Gestión de Stock Inteligente
- **Fotografía Automática**: Captura productos con la cámara del dispositivo
- **Reconocimiento IA**: Extracción automática de características del producto
- **Carga Rápida**: Proceso optimizado de menos de 30 segundos por producto
- **Sincronización en Tiempo Real**: Actualización instantánea del inventario

### 🔥 Tecnologías Implementadas
- **Frontend**: Flutter (Dart) - Multiplataforma (iOS/Android)
- **Backend**: Firebase (Firestore NoSQL Database)
- **Almacenamiento**: Firebase Storage para imágenes
- **IA/ML**: Integración con servicios de reconocimiento de imágenes
- **Autenticación**: Firebase Authentication

### 📊 Funcionalidades del Sistema
- ✅ Gestión completa de inventario
- ✅ Búsqueda avanzada y filtros
- ✅ Reportes de stock en tiempo real
- ✅ Alertas de stock bajo
- ✅ Historial de movimientos
- ✅ Interfaz intuitiva y responsiva

## 🏗️ Arquitectura del Proyecto

```
📦 Stock LetuShops
├── 📱 Frontend (Flutter)
│   ├── 📸 Módulo de Cámara
│   ├── 🧠 Procesamiento IA
│   ├── 📋 Gestión de Inventario
│   └── 👤 Autenticación
├── ☁️ Backend (Firebase)
│   ├── 🔥 Firestore Database
│   ├── 📦 Storage
│   └── 🔐 Authentication
└── 🤖 Servicios IA
    ├── 👁️ Reconocimiento de Imágenes
    ├── 📝 Extracción de Texto (OCR)
    └── 🏷️ Clasificación de Productos
```

## 🛠️ Instalación y Configuración

### Prerrequisitos
```bash
# Flutter SDK (versión >= 3.7.2)
flutter --version

# Dart SDK incluido con Flutter
dart --version
```

### Configuración del Proyecto

1. **Clonar el repositorio**
```bash
git clone https://github.com/galva-developer/stock_letu_shops.git
cd stock_letu_shops
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Firebase**
```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Configurar FlutterFire
dart pub global activate flutterfire_cli
flutterfire configure
```

4. **Ejecutar la aplicación**
```bash
# Para Android
flutter run

# Para iOS
flutter run -d ios

# Para Web (desarrollo)
flutter run -d chrome
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── core/                     # Funcionalidades centrales
│   ├── constants/           # Constantes globales
│   ├── utils/              # Utilidades y helpers
│   └── services/           # Servicios base
├── features/               # Características principales
│   ├── authentication/    # Módulo de autenticación
│   ├── camera/            # Módulo de cámara e IA
│   ├── inventory/         # Gestión de inventario
│   ├── products/          # Gestión de productos
│   └── reports/           # Reportes y estadísticas
├── shared/                # Componentes compartidos
│   ├── widgets/           # Widgets reutilizables
│   ├── models/            # Modelos de datos
│   └── providers/         # Gestores de estado
└── config/                # Configuraciones
    ├── routes/            # Rutas de navegación
    ├── themes/            # Temas y estilos
    └── firebase/          # Configuración Firebase
```

## 🔧 Configuración de Firebase

### 1. Firestore Database
```javascript
// Estructura de la base de datos
products: {
  productId: {
    name: string,
    description: string,
    category: string,
    price: number,
    stock: number,
    images: [string],
    characteristics: {
      brand: string,
      model: string,
      color: string,
      size: string,
      // ... más características extraídas por IA
    },
    createdAt: timestamp,
    updatedAt: timestamp
  }
}
```

### 2. Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /products/{productId}/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 3. Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 🤖 Integración de IA

### Servicios de Reconocimiento
- **Google ML Kit**: Reconocimiento de texto (OCR)
- **TensorFlow Lite**: Clasificación de productos
- **Cloud Vision API**: Análisis avanzado de imágenes

### Flujo de Procesamiento
1. 📸 **Captura** → Usuario toma foto del producto
2. 🔍 **Análisis** → IA extrae características visibles
3. 📝 **OCR** → Extracción de texto de etiquetas/códigos
4. 🏷️ **Clasificación** → Identificación de categoría de producto
5. 💾 **Almacenamiento** → Guardado automático en Firestore

## 📱 Capturas de Pantalla

| Pantalla Principal | Cámara IA | Gestión de Stock |
|:--:|:--:|:--:|
| ![Home](assets/screenshots/home.png) | ![Camera](assets/screenshots/camera.png) | ![Stock](assets/screenshots/stock.png) |

## 🚀 Roadmap

### Versión 1.0 (Actual)
- [x] Autenticación de usuarios
- [x] Cámara básica y captura
- [x] Base de datos Firebase
- [ ] Integración IA básica
- [ ] CRUD de productos

### Versión 1.1 (Próxima)
- [ ] Reconocimiento avanzado de productos
- [ ] Reportes detallados
- [ ] Exportación de datos
- [ ] Modo offline

### Versión 2.0 (Futuro)
- [ ] Análisis predictivo de stock
- [ ] Integración con sistemas ERP
- [ ] API para terceros
- [ ] Dashboard web administrativo

## 👥 Contribución

1. Fork el proyecto
2. Crea tu feature branch (`git checkout -b feature/amazing-feature`)
3. Commit tus cambios (`git commit -m 'Add amazing feature'`)
4. Push al branch (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📧 Contacto

**Desarrollador**: Galva Developer  
**Email**: [alvaro.gonzales.dev@gmail.com]  
**GitHub**: [@galva-developer](https://github.com/galva-developer)
**GitHub**: [@alvaro-developer](https://github.com/alvaro-developer)

## 🙏 Agradecimientos

- Equipo de LETUSHOPS por la confianza en el proyecto
- Comunidad Flutter por las increíbles herramientas
- Firebase por la infraestructura en la nube
- Contributors y testers del proyecto

---

<div align="center">
  <h3>🛒 Hecho con ❤️ para LETUSHOPS</h3>
  <p>Revolucionando la gestión de inventario con tecnología de vanguardia</p>
</div>
