import 'package:flutter/material.dart';
import '../config/themes/app_theme.dart';

/// 🎨 EJEMPLO DE USO DEL SISTEMA DE TEMAS
/// Demuestra cómo implementar el tema en la aplicación principal

class ThemeDemo extends StatelessWidget {
  const ThemeDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock LetuShops',

      // 🎨 CONFIGURACIÓN DE TEMAS
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Respeta la configuración del sistema
      // 📱 CONFIGURACIÓN RESPONSIVE
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0, // Evita escalado automático no deseado
          ),
          child: child ?? const SizedBox(),
        );
      },

      home: const ThemeDemoScreen(),
    );
  }
}

/// 📱 PANTALLA DE DEMOSTRACIÓN DEL TEMA
class ThemeDemoScreen extends StatelessWidget {
  const ThemeDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Tema LetuShops'),
        actions: [
          IconButton(
            icon: Icon(
              AppTheme.isDarkMode(context) ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              // Aquí iría la lógica para cambiar el tema
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Cambio de tema - implementar con provider/bloc',
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: AppTheme.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📝 TIPOGRAFÍAS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipografías',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Headline Large',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Title Large',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Body Large - Este es un texto de ejemplo para mostrar el estilo body large.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Body Medium - Texto de tamaño medio para contenido general.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Body Small - Texto pequeño para información secundaria.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔴 BOTONES
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Botones',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Elevated'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('Outlined'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(onPressed: () {}, child: const Text('Text')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Botón Completo'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📝 INPUTS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Campos de Entrada',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Nombre de usuario',
                        hintText: 'Ingrese su usuario',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Ingrese su contraseña',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(Icons.visibility),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🎨 COLORES
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paleta de Colores',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ColorChip(
                          color: AppTheme.getPrimaryColor(context),
                          label: 'Primary',
                        ),
                        _ColorChip(
                          color: Theme.of(context).colorScheme.secondary,
                          label: 'Secondary',
                        ),
                        _ColorChip(
                          color: AppTheme.getBackgroundColor(context),
                          label: 'Background',
                        ),
                        _ColorChip(
                          color: Theme.of(context).colorScheme.surface,
                          label: 'Surface',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📊 INFORMACIÓN DEL TEMA
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información del Tema',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                      'Modo:',
                      AppTheme.isDarkMode(context) ? 'Oscuro' : 'Claro',
                    ),
                    _InfoRow('Material 3:', 'Habilitado'),
                    _InfoRow('Responsive:', 'Activo'),
                    _InfoRow(
                      'Color Principal:',
                      AppTheme.getPrimaryColor(context).toString(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Demo Diálogo'),
                  content: const Text(
                    'Este es un ejemplo de diálogo usando el tema.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// 🎨 CHIP DE COLOR PARA DEMOSTRACIÓN
class _ColorChip extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _getContrastColor(color),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getContrastColor(Color color) {
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}

/// 📋 FILA DE INFORMACIÓN
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
