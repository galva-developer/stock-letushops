import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

/// Pantalla de registro de usuarios
///
/// Permite a nuevos usuarios crear una cuenta en la aplicación.
/// Incluye validaciones completas, confirmación de contraseña
/// y términos de servicio.
///
/// Características:
/// - Formulario completo con validaciones
/// - Confirmación de contraseña
/// - Aceptación de términos y condiciones
/// - Diseño responsive
/// - Integración con AuthProvider
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          'Crear Cuenta',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _buildHeader(),

                  const SizedBox(height: 32),

                  // Formulario de registro
                  _buildRegisterForm(authProvider),

                  const SizedBox(height: 24),

                  // Términos y condiciones
                  _buildTermsCheckbox(),

                  const SizedBox(height: 24),

                  // Botón de registro
                  _buildRegisterButton(authProvider),

                  const SizedBox(height: 32),

                  // Divider
                  _buildDivider(),

                  const SizedBox(height: 24),

                  // Enlace para login
                  _buildLoginLink(),

                  const SizedBox(height: 40),
                ],
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
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD32F2F).withOpacity(0.1),
          ),
          child: const Icon(
            Icons.person_add_outlined,
            size: 30,
            color: Color(0xFFD32F2F),
          ),
        ),

        const SizedBox(height: 16),

        // Título
        const Text(
          'Únete a Stock LetuShops',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 8),

        // Subtítulo
        Text(
          'Crea tu cuenta y comienza a gestionar tu inventario',
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

  /// Construye el formulario de registro
  Widget _buildRegisterForm(AuthProvider authProvider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo de nombre
          _buildNameField(authProvider.isLoading),

          const SizedBox(height: 20),

          // Campo de email
          _buildEmailField(authProvider.isLoading),

          const SizedBox(height: 20),

          // Campo de contraseña
          _buildPasswordField(authProvider.isLoading),

          const SizedBox(height: 20),

          // Campo de confirmación de contraseña
          _buildConfirmPasswordField(authProvider.isLoading),
        ],
      ),
    );
  }

  /// Construye el campo de nombre
  Widget _buildNameField(bool isLoading) {
    return TextFormField(
      controller: _nameController,
      enabled: !isLoading,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Nombre completo',
        hintText: 'Ingresa tu nombre completo',
        prefixIcon: const Icon(Icons.person_outlined, color: Color(0xFFD32F2F)),
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
          return 'El nombre es requerido';
        }
        if (value.trim().length < 2) {
          return 'El nombre debe tener al menos 2 caracteres';
        }
        return null;
      },
    );
  }

  /// Construye el campo de email
  Widget _buildEmailField(bool isLoading) {
    return TextFormField(
      controller: _emailController,
      enabled: !isLoading,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Ingresa tu email',
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

  /// Construye el campo de contraseña
  Widget _buildPasswordField(bool isLoading) {
    return TextFormField(
      controller: _passwordController,
      enabled: !isLoading,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: 'Mínimo 6 caracteres',
        prefixIcon: const Icon(Icons.lock_outlined, color: Color(0xFFD32F2F)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
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
        if (value == null || value.isEmpty) {
          return 'La contraseña es requerida';
        }
        if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }

  /// Construye el campo de confirmación de contraseña
  Widget _buildConfirmPasswordField(bool isLoading) {
    return TextFormField(
      controller: _confirmPasswordController,
      enabled: !isLoading,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleRegister(),
      decoration: InputDecoration(
        labelText: 'Confirmar contraseña',
        hintText: 'Confirma tu contraseña',
        prefixIcon: const Icon(Icons.lock_outlined, color: Color(0xFFD32F2F)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
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
        if (value == null || value.isEmpty) {
          return 'Confirma tu contraseña';
        }
        if (value != _passwordController.text) {
          return 'Las contraseñas no coinciden';
        }
        return null;
      },
    );
  }

  /// Construye el checkbox de términos y condiciones
  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: const Color(0xFFD32F2F),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
                children: [
                  const TextSpan(text: 'Acepto los '),
                  TextSpan(
                    text: 'Términos y Condiciones',
                    style: TextStyle(
                      color: const Color(0xFFD32F2F),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    // TODO: Agregar navegación a términos y condiciones
                  ),
                  const TextSpan(text: ' y la '),
                  TextSpan(
                    text: 'Política de Privacidad',
                    style: TextStyle(
                      color: const Color(0xFFD32F2F),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                    // TODO: Agregar navegación a política de privacidad
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Construye el botón de registro
  Widget _buildRegisterButton(AuthProvider authProvider) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed:
            authProvider.isLoading || !_acceptTerms ? null : _handleRegister,
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
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
      ),
    );
  }

  /// Construye el divider
  Widget _buildDivider() {
    return Row(
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
    );
  }

  /// Construye el enlace para login
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes una cuenta? ',
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
    );
  }

  /// Maneja el proceso de registro
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes aceptar los términos y condiciones'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Ocultar teclado
    FocusScope.of(context).unfocus();

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
    );

    if (success && mounted) {
      // Navegación se maneja automáticamente por el AuthProvider
      Navigator.pushReplacementNamed(context, '/home');
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}
