import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

/// Pantalla de recuperación de contraseña
///
/// Permite a los usuarios solicitar un restablecimiento de contraseña
/// enviando un email con instrucciones para crear una nueva contraseña.
///
/// Características:
/// - Formulario simple con validación de email
/// - Confirmación visual del envío
/// - Manejo de errores
/// - Diseño consistente con la aplicación
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recuperar Contraseña',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Mostrar mensajes de error/éxito
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleStateMessages(authProvider.state);
          });

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? size.width * 0.2 : 24.0,
                vertical: 20.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      size.height - MediaQuery.of(context).padding.top - 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Header
                    _buildHeader(),

                    const SizedBox(height: 40),

                    // Contenido principal
                    _emailSent
                        ? _buildSuccessContent()
                        : _buildFormContent(authProvider),

                    const SizedBox(height: 32),

                    // Botón de acción
                    _emailSent
                        ? _buildBackToLoginButton()
                        : _buildSendEmailButton(authProvider),

                    const SizedBox(height: 24),

                    // Enlaces adicionales
                    if (!_emailSent) _buildAdditionalLinks(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construye el header
  Widget _buildHeader() {
    return Column(
      children: [
        // Ícono
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                _emailSent
                    ? Colors.green.withOpacity(0.1)
                    : const Color(0xFFD32F2F).withOpacity(0.1),
          ),
          child: Icon(
            _emailSent
                ? Icons.mark_email_read_outlined
                : Icons.lock_reset_outlined,
            size: 40,
            color: _emailSent ? Colors.green : const Color(0xFFD32F2F),
          ),
        ),

        const SizedBox(height: 24),

        // Título
        Text(
          _emailSent ? '¡Email Enviado!' : 'Recuperar Contraseña',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 12),

        // Subtítulo
        Text(
          _emailSent
              ? 'Te hemos enviado las instrucciones para restablecer tu contraseña'
              : 'Ingresa tu email y te enviaremos instrucciones para restablecer tu contraseña',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Construye el contenido del formulario
  Widget _buildFormContent(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Instrucciones adicionales
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Recibirás un email con un enlace para crear una nueva contraseña.',
                    style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Campo de email
          _buildEmailField(authProvider.isLoading),
        ],
      ),
    );
  }

  /// Construye el contenido de éxito
  Widget _buildSuccessContent() {
    return Column(
      children: [
        // Ilustración de éxito
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            children: [
              Icon(Icons.email_outlined, size: 64, color: Colors.green[600]),
              const SizedBox(height: 16),
              Text(
                'Revisa tu bandeja de entrada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'También revisa tu carpeta de spam por si acaso',
                style: TextStyle(fontSize: 14, color: Colors.green[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Email enviado a
        if (_emailController.text.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.email, color: Colors.grey[600], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email enviado a:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _emailController.text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Construye el campo de email
  Widget _buildEmailField(bool isLoading) {
    return TextFormField(
      controller: _emailController,
      enabled: !isLoading,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleSendEmail(),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Ingresa tu email registrado',
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFD32F2F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El email es requerido';
        }
        if (!RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        ).hasMatch(value.trim())) {
          return 'Ingresa un email válido';
        }
        return null;
      },
    );
  }

  /// Construye el botón de enviar email
  Widget _buildSendEmailButton(AuthProvider authProvider) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: authProvider.isLoading ? null : _handleSendEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD32F2F),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
          elevation: 2,
          shadowColor: const Color(0xFFD32F2F).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            authProvider.isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Text(
                  'Enviar Instrucciones',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
      ),
    );
  }

  /// Construye el botón de volver al login
  Widget _buildBackToLoginButton() {
    return Column(
      children: [
        // Botón principal
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: const Color(0xFFD32F2F).withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Volver al Inicio de Sesión',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Botón secundario para reenviar
        TextButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          child: const Text(
            '¿No recibiste el email? Enviar de nuevo',
            style: TextStyle(
              color: Color(0xFFD32F2F),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Construye enlaces adicionales
  Widget _buildAdditionalLinks() {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'o',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),

        const SizedBox(height: 16),

        // Enlace para volver al login
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Recordaste tu contraseña? ',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Inicia Sesión',
                style: TextStyle(
                  color: Color(0xFFD32F2F),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Maneja el envío del email de recuperación
  Future<void> _handleSendEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Ocultar teclado
    FocusScope.of(context).unfocus();

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.resetPassword(
      _emailController.text.trim(),
    );

    if (success && mounted) {
      setState(() {
        _emailSent = true;
      });
    }
  }

  /// Maneja los mensajes de estado
  void _handleStateMessages(AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.userMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      // Limpiar el mensaje después de mostrarlo
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          context.read<AuthProvider>().clearMessages();
        }
      });
    } else if (state is AuthSuccess) {
      // El éxito se maneja cambiando _emailSent a true
      // No necesitamos mostrar SnackBar aquí
    }
  }
}
