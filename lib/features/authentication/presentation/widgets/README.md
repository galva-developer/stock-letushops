# Widgets de Autenticación

Este directorio contiene los widgets reutilizables para el sistema de autenticación de Stock LetuShops, diseñados siguiendo los principios de Clean Architecture y la paleta de colores rojo-blanco-negro.

## 📁 Estructura de Archivos

```
widgets/
├── custom_text_field.dart     # Campo de texto personalizado
├── auth_button.dart           # Botón de autenticación
├── logo_widget.dart           # Logo de la aplicación
├── form_validators.dart       # Validadores de formularios
└── README.md                  # Esta documentación
```

## 🎨 Widgets Implementados

### 1. CustomTextField
**Archivo**: `custom_text_field.dart`

Campo de texto personalizado con diseño consistente y funcionalidades avanzadas.

#### Características:
- ✅ Diseño profesional con bordes redondeados
- ✅ Soporte para validación con mensajes de error
- ✅ Iconos prefijo y sufijo opcionales
- ✅ Modo de contraseña con toggle de visibilidad
- ✅ Estados de error, focus y disabled
- ✅ Animaciones suaves en las transiciones

#### Uso Básico:
```dart
CustomTextField(
  hintText: 'Ingresa tu email',
  labelText: 'Correo electrónico',
  controller: emailController,
  validator: FormValidators.email,
  prefixIcon: Icons.email_outlined,
  keyboardType: TextInputType.emailAddress,
)
```

#### Extensiones Predefinidas:
```dart
// Campo de email
CustomTextField.email(
  controller: emailController,
  validator: FormValidators.email,
)

// Campo de contraseña
CustomTextField.password(
  controller: passwordController,
  validator: FormValidators.password,
)

// Campo de nombre
CustomTextField.name(
  controller: nameController,
  validator: FormValidators.fullName,
)
```

### 2. AuthButton
**Archivo**: `auth_button.dart`

Botón personalizado con múltiples variantes y estados para autenticación.

#### Características:
- ✅ Múltiples variantes (primary, secondary, outlined, text)
- ✅ Estados de loading con indicador de progreso
- ✅ Soporte para iconos y diferentes tamaños
- ✅ Animaciones suaves en hover y press
- ✅ Diseño responsive y accesible
- ✅ Ripple effect personalizado

#### Variantes Disponibles:
```dart
// Botón principal (rojo)
AuthButton(
  text: 'Iniciar Sesión',
  onPressed: () => handleLogin(),
  variant: AuthButtonVariant.primary,
)

// Botón secundario (gris)
AuthButton(
  text: 'Cancelar',
  onPressed: () => handleCancel(),
  variant: AuthButtonVariant.secondary,
)

// Botón con borde
AuthButton(
  text: 'Registro',
  onPressed: () => handleRegister(),
  variant: AuthButtonVariant.outlined,
)

// Botón de solo texto
AuthButton(
  text: 'Olvidé mi contraseña',
  onPressed: () => handleForgotPassword(),
  variant: AuthButtonVariant.text,
)
```

#### Tamaños Disponibles:
- `AuthButtonSize.small` - 40px altura
- `AuthButtonSize.medium` - 48px altura  
- `AuthButtonSize.large` - 56px altura (ancho completo)

#### Extensiones Predefinidas:
```dart
// Botón de login
AuthButton.login(
  onPressed: handleLogin,
  isLoading: isLoading,
)

// Botón de registro
AuthButton.register(
  onPressed: handleRegister,
  isLoading: isLoading,
)

// Botón de Google
AuthButton.google(
  onPressed: handleGoogleSignIn,
)
```

### 3. LogoWidget
**Archivo**: `logo_widget.dart`

Widget del logo de LetuShops con múltiples variantes y animaciones.

#### Características:
- ✅ Múltiples variantes (completo, solo icono, horizontal)
- ✅ Diferentes tamaños predefinidos
- ✅ Animaciones opcionales (fade, scale, bounce)
- ✅ Adaptación automática al tema
- ✅ Versión responsiva para diferentes pantallas
- ✅ Soporte para modo claro y oscuro

#### Variantes Disponibles:
```dart
// Logo completo
LogoWidget(
  variant: LogoVariant.complete,
  size: LogoSize.large,
  animation: LogoAnimation.scale,
)

// Solo icono
LogoWidget(
  variant: LogoVariant.iconOnly,
  size: LogoSize.medium,
)

// Versión horizontal
LogoWidget(
  variant: LogoVariant.horizontal,
  size: LogoSize.small,
)
```

#### Animaciones Disponibles:
- `LogoAnimation.none` - Sin animación
- `LogoAnimation.fade` - Fade in suave
- `LogoAnimation.scale` - Scale in con fade
- `LogoAnimation.bounce` - Bounce effect elástico
- `LogoAnimation.slide` - Slide from top

#### Extensiones Predefinidas:
```dart
// Para splash screen
LogoWidget.splash()

// Para app bar
LogoWidget.appBar()

// Para formularios de auth
LogoWidget.auth()

// Solo icono
LogoWidget.icon(size: LogoSize.small)
```

### 4. FormValidators
**Archivo**: `form_validators.dart`

Sistema completo de validación de formularios con mensajes en español.

#### Características:
- ✅ Validación de email con regex compliant
- ✅ Validación de contraseñas con criterios de seguridad
- ✅ Validación de nombres con caracteres especiales
- ✅ Validación de confirmación de contraseña
- ✅ Mensajes de error descriptivos
- ✅ Validaciones combinadas
- ✅ Utilidades adicionales

#### Validadores Disponibles:
```dart
// Validadores básicos
FormValidators.required(value, fieldName: 'Email')
FormValidators.email(value)
FormValidators.password(value, requireStrong: true)
FormValidators.confirmPassword(value, originalPassword)
FormValidators.fullName(value)
FormValidators.phone(value, required: false)

// Validadores de longitud
FormValidators.minLength(value, 8, fieldName: 'Contraseña')
FormValidators.maxLength(value, 50, fieldName: 'Nombre')

// Validaciones combinadas
FormValidators.combine([
  FormValidators.required,
  FormValidators.email,
])
```

#### Extensiones Simplificadas:
```dart
// Para formularios específicos
ValidatorExtensions.loginEmail
ValidatorExtensions.loginPassword
ValidatorExtensions.registerEmail
ValidatorExtensions.registerPassword
ValidatorExtensions.registerName
ValidatorExtensions.confirmPasswordValidator(originalPassword)
```

#### Utilidades Adicionales:
```dart
// Evaluación de fortaleza de contraseña
int strength = FormValidationUtils.getPasswordStrength(password);
Color color = FormValidationUtils.getPasswordStrengthColor(strength);
String text = FormValidationUtils.getPasswordStrengthText(strength);

// Formateo de teléfono
String formatted = FormValidationUtils.formatPhoneNumber(phone);
String masked = FormValidationUtils.applyPhoneMask(input);
```

## 🎨 Paleta de Colores

Los widgets siguen la paleta de colores oficial de Stock LetuShops:

- **Primario**: `Colors.red.shade700` (#C53030)
- **Secundario**: `Colors.grey.shade100` (#F7FAFC)
- **Texto**: `Colors.black87` (#1A202C)
- **Error**: `Colors.red.shade600` (#E53E3E)
- **Fondo**: `Colors.grey.shade50` (#FAFAFA)

## 📱 Responsive Design

Todos los widgets están diseñados para ser responsivos:

- **Móvil**: Optimizado para pantallas pequeñas
- **Tablet**: Tamaños intermedios adaptativos
- **Desktop**: Versiones expandidas cuando sea apropio

## ♿ Accesibilidad

Los widgets incluyen características de accesibilidad:

- Labels semánticos para lectores de pantalla
- Contraste de colores adecuado
- Tamaños de toque mínimos (44px)
- Navegación por teclado
- Estados de focus visibles

## 🧪 Testing

Para probar estos widgets:

```dart
// Ejemplo de test para CustomTextField
testWidgets('CustomTextField debe mostrar error de validación', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomTextField(
          hintText: 'Email',
          validator: FormValidators.email,
        ),
      ),
    ),
  );
  
  await tester.enterText(find.byType(CustomTextField), 'email_invalido');
  await tester.pump();
  
  expect(find.text('Ingresa un correo electrónico válido'), findsOneWidget);
});
```

## 🔧 Personalización

### Temas Personalizados
```dart
// Personalizar colores del CustomTextField
CustomTextField(
  // ... otros parámetros
  decoration: InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue), // Color personalizado
    ),
  ),
)
```

### Extensiones Personalizadas
```dart
extension MyCustomValidators on FormValidators {
  static String? customBusinessRule(String? value) {
    // Lógica de validación personalizada
    if (value?.contains('forbidden') == true) {
      return 'Este valor no está permitido';
    }
    return null;
  }
}
```

## 📚 Ejemplos de Uso Completo

### Formulario de Login
```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          LogoWidget.auth(),
          
          const SizedBox(height: 32),
          
          CustomTextField.email(
            controller: _emailController,
            validator: ValidatorExtensions.loginEmail,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField.password(
            controller: _passwordController,
            validator: ValidatorExtensions.loginPassword,
          ),
          
          const SizedBox(height: 24),
          
          AuthButton.login(
            onPressed: _isLoading ? null : _handleLogin,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
  
  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      try {
        // Lógica de login
        await authProvider.login(
          _emailController.text,
          _passwordController.text,
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
```

## 🔄 Estado de Implementación

- [x] **2.6.1** CustomTextField - ✅ Implementado
- [x] **2.6.2** AuthButton - ✅ Implementado  
- [x] **2.6.3** LogoWidget - ✅ Implementado
- [x] **2.6.4** FormValidators - ✅ Implementado

## 🚀 Próximos Pasos

Una vez completados estos widgets, se pueden utilizar para:

1. **Refactorizar páginas existentes** - Reemplazar widgets básicos por estos personalizados
2. **Implementar nuevas pantallas** - Usar estos widgets como base
3. **Crear tests unitarios** - Probar cada widget individualmente
4. **Optimizar performance** - Memoizar widgets cuando sea necesario

---

Los widgets de autenticación están listos para ser utilizados en toda la aplicación, proporcionando una experiencia de usuario consistente y profesional siguiendo los principios de Clean Architecture.
