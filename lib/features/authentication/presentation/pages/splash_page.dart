import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

/// Pantalla de inicio (splash) de la aplicación
///
/// Esta pantalla se muestra al iniciar la aplicación mientras
/// se verifica el estado de autenticación del usuario.
///
/// Características:
/// - Logo animado de la aplicación
/// - Indicador de carga
/// - Transición automática según estado de autenticación
/// - Paleta de colores rojo-blanco-negro
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    // Controlador para animación del logo
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Controlador para animación de fade
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animación de escala del logo
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Animación de rotación sutil del logo
    _logoRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Animación de fade para el texto
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  void _startAnimations() {
    _logoController.forward();

    // Iniciar fade animation después de un delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Escuchar cambios de estado para navegación automática
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleStateChange(authProvider.state);
          });

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFF5F5F5)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo animado
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value * 0.1, // Rotación sutil
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFD32F2F), // Rojo principal
                                  Color(0xFFB71C1C), // Rojo oscuro
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFD32F2F,
                                  ).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.inventory_2_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Nombre de la aplicación con animación de fade
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          children: [
                            // Título principal
                            const Text(
                              'Stock LetuShops',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121), // Negro principal
                                letterSpacing: 1.2,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Subtítulo
                            Text(
                              'Gestión Inteligente de Inventario',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  // Indicador de carga
                  _buildLoadingIndicator(authProvider.state),

                  const SizedBox(height: 20),

                  // Mensaje de estado
                  _buildStatusMessage(authProvider.state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construye el indicador de carga según el estado
  Widget _buildLoadingIndicator(AuthState state) {
    if (state is AuthLoading || state is AuthInitial) {
      return const SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD32F2F)),
        ),
      );
    }

    return const SizedBox(height: 32);
  }

  /// Construye el mensaje de estado
  Widget _buildStatusMessage(AuthState state) {
    String message = 'Inicializando...';
    Color color = Colors.grey[600]!;

    if (state is AuthLoading) {
      message = state.message ?? 'Cargando...';
      color = Colors.grey[600]!;
    } else if (state is AuthError) {
      message = 'Error al inicializar';
      color = const Color(0xFFD32F2F);
    } else if (state is AuthAuthenticated) {
      message = 'Bienvenido de vuelta';
      color = const Color(0xFF4CAF50);
    } else if (state is AuthUnauthenticated) {
      message = 'Redirigiendo...';
      color = Colors.grey[600]!;
    }

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  /// Maneja los cambios de estado para navegación automática
  void _handleStateChange(AuthState state) {
    // Esperar un mínimo de tiempo en splash (para la animación)
    if (_logoController.isCompleted) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          if (state is AuthAuthenticated) {
            // Usuario autenticado, ir a pantalla principal
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthUnauthenticated) {
            // Usuario no autenticado, ir a login
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is AuthError) {
            // Error crítico, ir a login después de un delay
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            });
          }
        }
      });
    }
  }
}
