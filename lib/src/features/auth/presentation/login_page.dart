import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/utils/validation_utils.dart';
import '../providers/auth_provider.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: isMobile
              ? _MobileLogin(
                  emailController: emailController,
                  passwordController: passwordController,
                  formKey: formKey,
                  isLoading: isLoading,
                  errorMessage: errorMessage,
                  ref: ref,
                  context: context,
                )
              : _DesktopLogin(
                  emailController: emailController,
                  passwordController: passwordController,
                  formKey: formKey,
                  isLoading: isLoading,
                  errorMessage: errorMessage,
                  ref: ref,
                  context: context,
                ),
        ),
      ),
    );
  }
}

// Login para Desktop - Con imagen al lado
class _DesktopLogin extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final ValueNotifier<bool> isLoading;
  final ValueNotifier<String?> errorMessage;
  final WidgetRef ref;
  final BuildContext context;

  const _DesktopLogin({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.isLoading,
    required this.errorMessage,
    required this.ref,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Lado izquierdo: Branding e imagen
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primary,
                  AppTheme.primary.withValues(alpha: 0.85),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'MarketMove',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Gestiona tu negocio de forma inteligente y eficiente',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.95),
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                // Features
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _FeatureItem(
                        icon: Icons.show_chart_rounded,
                        label: 'Análisis',
                        color: Colors.white,
                      ),
                      _FeatureItem(
                        icon: Icons.inventory_2_rounded,
                        label: 'Inventario',
                        color: Colors.white,
                      ),
                      _FeatureItem(
                        icon: Icons.people_rounded,
                        label: 'Clientes',
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Lado derecho: Formulario
        Expanded(
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
              children: [
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bienvenido',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.dark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Inicia sesión en tu cuenta para continuar',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                _InputField(
                  label: 'Email',
                  hint: 'tu@email.com',
                  icon: Icons.email_outlined,
                  controller: emailController,
                  validator: ValidationUtils.validateEmail,
                ),
                const SizedBox(height: 28),
                _InputField(
                  label: 'Contraseña',
                  hint: '••••••••',
                  icon: Icons.lock_outlined,
                  controller: passwordController,
                  obscureText: true,
                  validator: ValidationUtils.validatePassword,
                ),
                if (errorMessage.value != null) ...[
                  const SizedBox(height: 20),
                  _ErrorContainer(error: errorMessage.value!),
                ],
                const SizedBox(height: 36),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading.value
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              isLoading.value = true;
                              errorMessage.value = null;

                              try {
                                await ref.read(loginProvider((
                                  email: emailController.text,
                                  password: passwordController.text,
                                )).future);

                                if (context.mounted) {
                                  context.go('/home');
                                }
                              } catch (e) {
                                errorMessage.value = e.toString();
                              } finally {
                                isLoading.value = false;
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: '¿No tienes cuenta? ',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'Crea una ahora',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context.go('/register'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Login para Mobile - Versión simplificada
class _MobileLogin extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final ValueNotifier<bool> isLoading;
  final ValueNotifier<String?> errorMessage;
  final WidgetRef ref;
  final BuildContext context;

  const _MobileLogin({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.isLoading,
    required this.errorMessage,
    required this.ref,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 40),
          // Header
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              size: 44,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Bienvenido',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppTheme.dark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inicia sesión en tu cuenta',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 40),
          _InputField(
            label: 'Email',
            hint: 'tu@email.com',
            icon: Icons.email_outlined,
            controller: emailController,
            validator: ValidationUtils.validateEmail,
          ),
          const SizedBox(height: 24),
          _InputField(
            label: 'Contraseña',
            hint: '••••••••',
            icon: Icons.lock_outlined,
            controller: passwordController,
            obscureText: true,
            validator: ValidationUtils.validatePassword,
          ),
          if (errorMessage.value != null) ...[
            const SizedBox(height: 20),
            _ErrorContainer(error: errorMessage.value!),
          ],
          const SizedBox(height: 32),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading.value
                  ? null
                  : () async {
                      if (formKey.currentState!.validate()) {
                        isLoading.value = true;
                        errorMessage.value = null;

                        try {
                          await ref.read(loginProvider((
                            email: emailController.text,
                            password: passwordController.text,
                          )).future);

                          if (context.mounted) {
                            context.go('/home');
                          }
                        } catch (e) {
                          errorMessage.value = e.toString();
                        } finally {
                          isLoading.value = false;
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: RichText(
              text: TextSpan(
                text: '¿No tienes cuenta? ',
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: 'Crea una',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => context.go('/register'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// Componentes reutilizables
class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final FormFieldValidator<String?>? validator;
  final bool obscureText;

  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.dark,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.danger, width: 1),
            ),
            hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
            prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 20),
          ),
          style: const TextStyle(fontSize: 14, color: AppTheme.dark, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ErrorContainer extends StatelessWidget {
  final String error;

  const _ErrorContainer({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.danger, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppTheme.danger,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: AppTheme.danger,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureItem({
    required this.icon,
    required this.label,
    this.color = AppTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

