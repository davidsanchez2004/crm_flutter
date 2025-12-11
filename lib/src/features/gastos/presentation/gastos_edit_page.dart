import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/theme/app_theme.dart' as theme show AppGradients;
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_input.dart';
import '../../../shared/utils/validation_utils.dart';
import '../models/gasto.dart';
import '../providers/gastos_provider.dart';

class GastosEditPage extends HookConsumerWidget {
  final Gasto gasto;

  const GastosEditPage({
    Key? key,
    required this.gasto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descripcionController = useTextEditingController(text: gasto.descripcion);
    final categoriaController = useTextEditingController(text: gasto.categoria);
    final montoController = useTextEditingController(text: gasto.monto.toString());
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.danger,
        title: const Text(
          'Editar Gasto',
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
              AppTheme.danger.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: theme.AppGradients.danger,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Actualizar Gasto',
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

              Text(
                'Descripción',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Descripción',
                controller: descripcionController,
                hintText: 'Ej: Compra de materiales',
                validator: (value) => ValidationUtils.validateRequired(value, 'Descripción'),
              ),
              const SizedBox(height: 24),

              Text(
                'Categoría',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Categoría',
                controller: categoriaController,
                hintText: 'Ej: Materiales, Servicios',
                validator: (value) => ValidationUtils.validateRequired(value, 'Categoría'),
              ),
              const SizedBox(height: 24),

              Text(
                'Monto',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Monto',
                controller: montoController,
                hintText: '500.00',
                keyboardType: TextInputType.number,
                validator: (value) => ValidationUtils.validateRequired(value, 'Monto'),
              ),

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

              CustomButton(
                label: 'Guardar Cambios',
                isLoading: isLoading.value,
                backgroundColor: AppTheme.danger,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading.value = true;
                    errorMessage.value = null;

                    try {
                      await ref.read(actualizarGastoProvider((
                        id: gasto.id,
                        descripcion: descripcionController.text,
                        categoria: categoriaController.text,
                        monto: double.parse(montoController.text),
                        fecha: gasto.fecha,
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
