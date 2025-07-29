# Sistema de Rutas Protegidas

Esta implementación proporciona un sistema completo de rutas protegidas con autenticación automática para Stock LetuShops, utilizando GoRouter y un RouteGuard personalizado.

## 📁 Estructura de Archivos

```
config/routes/
├── route_guard.dart       # Guard de rutas con lógica de protección
├── app_routes.dart        # Configuración principal de rutas
└── README.md             # Esta documentación

core/services/
└── session_persistence_service.dart   # Servicio de persistencia de sesión
```

## 🔐 Componentes Implementados

### 1. RouteGuard (`route_guard.dart`)

Sistema inteligente de protección de rutas que maneja la navegación basada en el estado de autenticación.

#### Características:
- ✅ Protección automática de rutas privadas
- ✅ Redirección inteligente basada en estado de auth
- ✅ Manejo de rutas públicas, privadas y auth-only
- ✅ Persistencia de destino para redirección post-login
- ✅ Integración completa con AuthProvider y AuthState

#### Tipos de Rutas:
```dart
// Rutas protegidas (requieren autenticación)
static const List<String> _protectedRoutes = [
  '/home', '/dashboard', '/products', '/inventory', 
  '/camera', '/reports', '/profile', '/settings'
];

// Rutas auth-only (solo accesibles sin autenticación)
static const List<String> _authOnlyRoutes = [
  '/login', '/register', '/forgot-password'
];

// Rutas públicas (siempre accesibles)
static const List<String> _publicRoutes = [
  '/splash', '/onboarding', '/terms', '/privacy', '/about'
];
```

#### Uso Principal:
```dart
// Configuración en GoRouter
static GoRouter router = GoRouter(
  redirect: RouteGuard.redirect,  // Función de redirección global
  // ... otras configuraciones
);

// Navegación post-login
RouteGuard.handlePostLoginNavigation(context);

// Navegación post-logout
RouteGuard.handlePostLogoutNavigation(context);
```

### 2. AppRoutes (`app_routes.dart`)

Configuración completa del sistema de rutas usando GoRouter con integración de RouteGuard.

#### Características:
- ✅ GoRouter con redirección automática
- ✅ Transiciones personalizadas (fade, slide)
- ✅ Manejo de errores de navegación
- ✅ Deep linking support
- ✅ Páginas placeholder para desarrollo futuro

#### Rutas Configuradas:

**Rutas Públicas:**
- `/splash` - Pantalla inicial de carga

**Rutas de Autenticación:**
- `/login` - Inicio de sesión
- `/register` - Registro de usuario
- `/forgot-password` - Recuperación de contraseña

**Rutas Protegidas:**
- `/home` - Pantalla principal
- `/products` - Gestión de productos
- `/camera` - Cámara con IA
- `/inventory` - Control de inventario
- `/reports` - Reportes y estadísticas
- `/profile` - Perfil del usuario

#### Transiciones Disponibles:
```dart
// Fade suave para pantallas principales
RouteTransitions.fade(context, state, widget)

// Slide desde la derecha para navegación
RouteTransitions.slideFromRight(context, state, widget)
```

### 3. SessionPersistenceService (`session_persistence_service.dart`)

Servicio completo para manejar la persistencia de sesión y preferencias de usuario.

#### Características:
- ✅ Persistencia automática de estado de autenticación
- ✅ Almacenamiento de preferencias de usuario
- ✅ Gestión de tokens y datos de sesión
- ✅ Limpieza automática al cerrar sesión
- ✅ Validación de integridad de datos
- ✅ Soporte para migración de datos

#### Métodos Principales:

**Autenticación:**
```dart
// Guardar estado de login
await SessionPersistenceService.instance.saveLoginState(
  isLoggedIn: true,
  user: user,
  rememberMe: true,
);

// Verificar si está logueado
final isLoggedIn = await SessionPersistenceService.instance.isLoggedIn();

// Obtener datos del usuario
final userData = await SessionPersistenceService.instance.getUserData();
```

**Navegación:**
```dart
// Guardar ruta destinada
await service.saveIntendedRoute('/products');

// Obtener y limpiar ruta destinada
final route = await service.getAndClearIntendedRoute();
```

**Preferencias:**
```dart
// Guardar tema
await service.saveAppTheme('dark');

// Guardar idioma
await service.saveLanguageCode('es');

// Verificar primer lanzamiento
final isFirst = await service.isFirstLaunch();
```

### 4. ProtectedRoute Widget

Widget auxiliar para proteger rutas individuales.

```dart
ProtectedRoute(
  child: ProductsPage(),
  fallback: LoginPage(), // Opcional
)
```

## 🔄 Flujo de Navegación

### 1. Inicialización de la App
```
App Start → Firebase Init → Session Service Init → 
AuthProvider Init → Route Evaluation → Initial Route
```

### 2. Estados de Autenticación

**Usuario No Autenticado:**
```
Intenta acceder a /products → RouteGuard detecta → 
Guarda /products como intended route → Redirige a /login
```

**Login Exitoso:**
```
Login Success → AuthProvider actualiza estado → 
RouteGuard detecta cambio → Navega a intended route (/products) o /home
```

**Logout:**
```
Logout → AuthProvider limpia estado → 
SessionPersistenceService limpia datos → Redirige a /login
```

### 3. Casos Especiales

**Acceso a Rutas Auth-Only (logueado):**
```
Usuario logueado intenta /login → RouteGuard redirige a /home
```

**Error de Autenticación:**
```
Error en auth → AuthProvider maneja error → 
RouteGuard redirige a /login → Muestra mensaje de error
```

## 🛠️ Integración en Main.dart

```dart
class StockLetuShopsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            final datasource = FirebaseAuthDataSource();
            final repository = AuthRepositoryImpl(datasource);
            return AuthProviderFactory.create(authRepository: repository);
          },
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp.router(
            title: 'Stock LetuShops',
            routerConfig: AppRoutes.router,  // ← Configuración de rutas
          );
        },
      ),
    );
  }
}
```

## 🔧 Configuración Avanzada

### Personalizar Rutas Protegidas
```dart
// Agregar nueva ruta protegida
static const List<String> _protectedRoutes = [
  '/home', '/products', '/nueva-ruta'  // ← Agregar aquí
];
```

### Configurar Transiciones Personalizadas
```dart
// En app_routes.dart
GoRoute(
  path: '/mi-ruta',
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: MiWidget(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Transición personalizada
      return SlideTransition(
        position: animation.drive(
          Tween(begin: Offset(0, 1), end: Offset.zero),
        ),
        child: child,
      );
    },
  ),
),
```

### Manejar Deeplinks
```dart
// El sistema maneja automáticamente deeplinks
// Si el usuario no está autenticado y accede a:
// https://app.com/products/123
// → Se guarda como intended route
// → Redirige a login
// → Post-login navega a /products/123
```

## 📱 Uso en Páginas

### Verificar Autenticación
```dart
class MiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated) {
          return LoginPrompt();
        }
        
        return MiContenido();
      },
    );
  }
}
```

### Navegación Programática
```dart
// Navegar con verificación automática
AppRoutes.navigateTo(context, '/products');

// Navegación directa (usa GoRouter)
context.go('/home');

// Navegación con reemplazo
context.pushReplacement('/login');
```

## 🧪 Testing

### Testear RouteGuard
```dart
testWidgets('RouteGuard redirige usuario no autenticado', (tester) async {
  final mockAuthProvider = MockAuthProvider();
  when(mockAuthProvider.state).thenReturn(AuthUnauthenticated());
  
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: mockAuthProvider,
      child: MaterialApp.router(
        routerConfig: AppRoutes.router,
      ),
    ),
  );
  
  // Navegar a ruta protegida
  GoRouter.of(tester.element(find.byType(MaterialApp))).go('/products');
  await tester.pumpAndSettle();
  
  // Verificar redirección a login
  expect(find.byType(LoginPage), findsOneWidget);
});
```

## 🔒 Seguridad

### Validaciones Implementadas
- ✅ Verificación de estado de autenticación en cada cambio de ruta
- ✅ Limpieza automática de datos sensibles al logout
- ✅ Validación de integridad de datos persistidos
- ✅ Manejo seguro de tokens y credenciales
- ✅ Protección contra acceso no autorizado

### Mejores Prácticas
- Nunca almacenar contraseñas en SharedPreferences
- Limpiar datos sensibles al detectar inconsistencias
- Validar permisos antes de cada navegación
- Usar HTTPS para todas las comunicaciones
- Implementar timeouts de sesión cuando sea necesario

## 📊 Monitoreo y Debugging

### Logs Disponibles
```dart
// Activar logs detallados en desarrollo
static GoRouter router = GoRouter(
  debugLogDiagnostics: true,  // ← Logs de GoRouter
  // ...
);

// RouteGuard incluye logs automáticos:
debugPrint('RouteGuard: Evaluating route $currentLocation');
debugPrint('RouteGuard: Saved intended route: $route');
```

### Herramientas de Debug
- GoRouter Inspector (Flutter DevTools)
- Provider Inspector para AuthState
- SessionPersistenceService.getStorageStats()
- Firebase Auth Debug Console

## 🚀 Estado de Implementación

- [x] **2.7.1** RouteGuard completo con lógica de protección
- [x] **2.7.2** Redirección automática según estado de autenticación  
- [x] **2.7.3** Persistencia de sesión con SessionPersistenceService

## 🔄 Próximos Pasos

Con el sistema de rutas protegidas completado, la aplicación está lista para:

1. **Desarrollo de Features** - Implementar las páginas placeholder
2. **UI Components** - Crear widgets compartidos y temas
3. **Gestión de Productos** - CRUD completo con Firebase
4. **Cámara e IA** - Integración con ML Kit
5. **Inventario** - Sistema de control de stock
6. **Reportes** - Dashboard analítico

El sistema de autenticación está **100% funcional** con:
- ✅ Login/Register/Logout
- ✅ Persistencia de sesión  
- ✅ Rutas protegidas
- ✅ Redirección inteligente
- ✅ Gestión de estado robusta

---

**El núcleo de autenticación de Stock LetuShops está completo y listo para el desarrollo de features principales.**
