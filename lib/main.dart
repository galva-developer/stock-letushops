import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Importaciones de configuración
import 'config/themes/app_theme.dart';
import 'config/routes/app_routes.dart';
import 'firebase_options.dart';

// Importaciones de servicios
import 'core/services/session_persistence_service.dart';

// Importaciones de providers
import 'features/authentication/presentation/providers/auth_provider.dart';

// Importaciones de dependencias de auth
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/data/datasources/firebase_auth_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializar servicio de persistencia de sesión
  await SessionPersistenceService.instance.initialize();

  runApp(const StockLetuShopsApp());
}

class StockLetuShopsApp extends StatelessWidget {
  const StockLetuShopsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Configuración del AuthProvider usando el factory
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            // Crear dependencias
            final datasource = FirebaseAuthDataSource();
            final repository = AuthRepositoryImpl(datasource);

            // Crear provider usando factory
            return AuthProviderFactory.create(authRepository: repository);
          },
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp.router(
            title: 'Stock LetuShops',
            debugShowCheckedModeBanner: false,

            // Configuración de tema
            theme: AppTheme.lightTheme,
            // darkTheme: AppTheme.darkTheme, // Para futuras implementaciones
            // themeMode: ThemeMode.system, // Respeta la configuración del sistema

            // Configuración de rutas con GoRouter
            routerConfig: AppRoutes.router,
          );
        },
      ),
    );
  }
}
