import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/authentication/presentation/providers/auth_provider.dart';
import '../../features/authentication/presentation/providers/auth_state.dart';

/// Guard de rutas para manejar la protección de rutas basada en autenticación
///
/// Este guard implementa la lógica de redirección automática según el estado
/// de autenticación del usuario, protegiendo rutas privadas y manejando
/// la navegación hacia las pantallas apropiadas.
///
/// Características:
/// - Protección automática de rutas privadas
/// - Redirección inteligente basada en estado de auth
/// - Manejo de rutas públicas y privadas
/// - Persistencia de destino para redirección post-login
/// - Integración con AuthProvider y AuthState
class RouteGuard {
  RouteGuard._();

  /// Lista de rutas que requieren autenticación
  static const List<String> _protectedRoutes = [
    '/home',
    '/dashboard',
    '/products',
    '/inventory',
    '/camera',
    '/reports',
    '/profile',
    '/settings',
  ];

  /// Lista de rutas que solo deben ser accesibles cuando NO está autenticado
  static const List<String> _authOnlyRoutes = [
    '/login',
    '/register',
    '/forgot-password',
  ];

  /// Lista de rutas públicas que siempre son accesibles
  static const List<String> _publicRoutes = [
    '/splash',
    '/onboarding',
    '/terms',
    '/privacy',
    '/about',
  ];

  /// Determina si una ruta requiere autenticación
  static bool isProtectedRoute(String route) {
    return _protectedRoutes.any(
      (protectedRoute) => route.startsWith(protectedRoute),
    );
  }

  /// Determina si una ruta solo debe ser accesible sin autenticación
  static bool isAuthOnlyRoute(String route) {
    return _authOnlyRoutes.any((authRoute) => route.startsWith(authRoute));
  }

  /// Determina si una ruta es pública
  static bool isPublicRoute(String route) {
    return _publicRoutes.any((publicRoute) => route.startsWith(publicRoute));
  }

  /// Función de redirección principal para GoRouter
  ///
  /// Esta función se ejecuta en cada cambio de ruta y determina
  /// si el usuario debe ser redirigido basado en su estado de autenticación.
  static String? redirect(BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentLocation = state.uri.path;
    final authState = authProvider.state;

    // Log para debugging (remover en producción)
    debugPrint(
      'RouteGuard: Evaluating route $currentLocation with auth state ${authState.runtimeType}',
    );

    return _evaluateRoute(currentLocation, authState);
  }

  /// Evalúa la ruta actual y determina la redirección necesaria
  static String? _evaluateRoute(String currentLocation, AuthState authState) {
    // Si estamos en splash, permitir siempre (se maneja internamente)
    if (currentLocation == '/splash') {
      return null;
    }

    // Manejar según el estado de autenticación
    switch (authState.runtimeType) {
      case AuthInitial:
        return _handleInitialState(currentLocation);

      case AuthLoading:
        return _handleLoadingState(currentLocation);

      case AuthAuthenticated:
        return _handleAuthenticatedState(currentLocation);

      case AuthUnauthenticated:
        return _handleUnauthenticatedState(currentLocation);

      case AuthError:
        return _handleErrorState(currentLocation);

      default:
        // Estado desconocido, ir a splash para re-evaluar
        return '/splash';
    }
  }

  /// Maneja el estado inicial (app recién iniciada)
  static String? _handleInitialState(String currentLocation) {
    // Si no estamos en splash, redirigir allí para inicializar
    if (currentLocation != '/splash') {
      return '/splash';
    }
    return null;
  }

  /// Maneja el estado de carga
  static String? _handleLoadingState(String currentLocation) {
    // Durante la carga, mantener en splash si no estamos allí
    if (currentLocation != '/splash') {
      return '/splash';
    }
    return null;
  }

  /// Maneja el estado autenticado
  static String? _handleAuthenticatedState(String currentLocation) {
    // Si está autenticado pero intenta acceder a rutas de auth-only
    if (isAuthOnlyRoute(currentLocation)) {
      return '/home'; // Redirigir al home
    }

    // Si está en splash y ya está autenticado, ir al home
    if (currentLocation == '/splash') {
      return '/home';
    }

    // Para rutas protegidas y públicas, permitir acceso
    return null;
  }

  /// Maneja el estado no autenticado
  static String? _handleUnauthenticatedState(String currentLocation) {
    // Si no está autenticado e intenta acceder a rutas protegidas
    if (isProtectedRoute(currentLocation)) {
      // Guardar destino para redirección post-login
      _saveIntendedRoute(currentLocation);
      return '/login';
    }

    // Si está en splash y no está autenticado, ir al login
    if (currentLocation == '/splash') {
      return '/login';
    }

    // Para rutas de auth-only y públicas, permitir acceso
    return null;
  }

  /// Maneja el estado de error
  static String? _handleErrorState(String currentLocation) {
    // En caso de error, tratar como no autenticado
    if (isProtectedRoute(currentLocation)) {
      _saveIntendedRoute(currentLocation);
      return '/login';
    }

    // Si está en splash, ir al login para que el usuario reintente
    if (currentLocation == '/splash') {
      return '/login';
    }

    return null;
  }

  /// Guarda la ruta destinada para redirección post-login
  static void _saveIntendedRoute(String route) {
    // Implementar guardado en SharedPreferences o similar
    // Por ahora, se puede usar una variable estática simple
    _intendedRoute = route;
    debugPrint('RouteGuard: Saved intended route: $route');
  }

  /// Variable para almacenar la ruta destinada
  static String? _intendedRoute;

  /// Obtiene y limpia la ruta destinada para redirección post-login
  static String? getAndClearIntendedRoute() {
    final route = _intendedRoute;
    _intendedRoute = null;
    return route;
  }

  /// Verifica si el usuario actual puede acceder a una ruta específica
  static bool canAccessRoute(String route, AuthState authState) {
    // Rutas públicas son siempre accesibles
    if (isPublicRoute(route)) {
      return true;
    }

    // Rutas protegidas requieren autenticación
    if (isProtectedRoute(route)) {
      return authState is AuthAuthenticated;
    }

    // Rutas de auth-only requieren NO estar autenticado
    if (isAuthOnlyRoute(route)) {
      return authState is! AuthAuthenticated;
    }

    // Por defecto, permitir acceso
    return true;
  }

  /// Maneja la navegación post-login
  static void handlePostLoginNavigation(BuildContext context) {
    final intendedRoute = getAndClearIntendedRoute();

    if (intendedRoute != null && intendedRoute != '/splash') {
      // Navegar a la ruta destinada
      context.go(intendedRoute);
      debugPrint('RouteGuard: Navigating to intended route: $intendedRoute');
    } else {
      // Navegar al home por defecto
      context.go('/home');
      debugPrint('RouteGuard: Navigating to home (default)');
    }
  }

  /// Maneja la navegación post-logout
  static void handlePostLogoutNavigation(BuildContext context) {
    // Limpiar cualquier ruta destinada guardada
    _intendedRoute = null;

    // Navegar al login
    context.go('/login');
    debugPrint('RouteGuard: Navigating to login after logout');
  }

  /// Obtiene la ruta inicial basada en el estado de autenticación
  static String getInitialRoute(AuthState authState) {
    switch (authState.runtimeType) {
      case AuthAuthenticated:
        return '/home';
      case AuthUnauthenticated:
        return '/login';
      default:
        return '/splash';
    }
  }
}

/// Extensión para facilitar el uso del RouteGuard con GoRouter
extension RouteGuardExtension on GoRouter {
  /// Navega a una ruta verificando permisos
  static void navigateWithGuard(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final authState = authProvider.state;

    if (RouteGuard.canAccessRoute(route, authState)) {
      context.go(route, extra: extra);
    } else {
      // Si no puede acceder, manejar redirección
      final redirectRoute = RouteGuard._evaluateRoute(route, authState);
      if (redirectRoute != null) {
        context.go(redirectRoute);
      }
    }
  }
}

/// Widget de ruta protegida que verifica autenticación antes de mostrar contenido
class ProtectedRoute extends StatelessWidget {
  const ProtectedRoute({super.key, required this.child, this.fallback});

  /// Widget hijo que se muestra si el usuario está autenticado
  final Widget child;

  /// Widget alternativo que se muestra si no está autenticado
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final authState = authProvider.state;

        // Si está autenticado, mostrar el contenido
        if (authState is AuthAuthenticated) {
          return child;
        }

        // Si está cargando, mostrar indicador
        if (authState is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si no está autenticado, mostrar fallback o redirigir
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}

/// Mixin para páginas que requieren autenticación
mixin RequiresAuth on StatefulWidget {
  /// Verifica si el usuario está autenticado al inicializar la página
  void checkAuthenticationStatus(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.state is! AuthAuthenticated) {
        // Si no está autenticado, navegar al login
        RouteGuard.handlePostLogoutNavigation(context);
      }
    });
  }
}

/// Clase para manejar transiciones de ruta personalizadas
class RouteTransitions {
  RouteTransitions._();

  /// Transición de slide desde la derecha (para navegación hacia adelante)
  static CustomTransitionPage<void> slideFromRight<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Transición de fade para cambios sutiles
  static CustomTransitionPage<void> fade<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
