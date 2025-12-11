import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/theme/app_theme.dart' as theme show AppGradients;
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_input.dart';
import '../../../shared/utils/validation_utils.dart';
import '../providers/clientes_provider.dart';

class ClientesFormPage extends HookConsumerWidget {
  const ClientesFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nombreController = useTextEditingController();
    final emailController = useTextEditingController();
    final telefonoController = useTextEditingController();
    final direccionController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primary,
        title: const Text(
          'Nuevo Cliente',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primary.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Header card
              Container(
                decoration: BoxDecoration(
                  gradient: theme.AppGradients.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.person_add,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Registrar Cliente',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Nombre input
              Text(
                'Nombre',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Nombre del cliente',
                controller: nombreController,
                hintText: 'Ej: Juan Pérez...',
                validator: (value) => ValidationUtils.validateRequired(value, 'Nombre'),
              ),
              const SizedBox(height: 24),

              // Email input
              Text(
                'Email',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Email del cliente',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'cliente@example.com',
                validator: (value) => ValidationUtils.validateEmail(value),
              ),
              const SizedBox(height: 24),

              // Teléfono input
              Text(
                'Teléfono',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Teléfono del cliente',
                controller: telefonoController,
                keyboardType: TextInputType.phone,
                hintText: '+1 (555) 123-4567',
                validator: (value) => ValidationUtils.validateRequired(value, 'Teléfono'),
              ),
              const SizedBox(height: 24),

              // Dirección input
              Text(
                'Dirección',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Dirección del cliente',
                controller: direccionController,
                hintText: 'Calle Principal 123, Ciudad...',
                maxLines: 3,
                minLines: 2,
                validator: (value) => ValidationUtils.validateRequired(value, 'Dirección'),
              ),

              // Error message
              if (errorMessage.value != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.danger),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppTheme.danger),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          errorMessage.value!,
                          style: TextStyle(color: AppTheme.danger),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Submit button
              CustomButton(
                label: 'Guardar cliente',
                isLoading: isLoading.value,
                backgroundColor: AppTheme.primary,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading.value = true;
                    errorMessage.value = null;

                    try {
                      await ref.read(crearClienteProvider((
                        nombre: nombreController.text,
                        email: emailController.text,
                        telefono: telefonoController.text,
                        direccion: direccionController.text,
                      )).future);

                      if (context.mounted) {
                        context.pop();
                      }
                    } catch (e) {
                      errorMessage.value = e.toString();
                    } finally {
                      isLoading.value = false;
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
