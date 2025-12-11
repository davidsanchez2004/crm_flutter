import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/theme/app_theme.dart' as theme show AppGradients;
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_input.dart';
import '../../../shared/utils/validation_utils.dart';
import '../models/venta.dart';
import '../providers/ventas_provider.dart';

class VentasEditPage extends HookConsumerWidget {
  final Venta venta;

  const VentasEditPage({
    Key? key,
    required this.venta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descripcionController = useTextEditingController(text: venta.descripcion);
    final montoController = useTextEditingController(text: venta.monto.toString());
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.info,
        title: const Text(
          'Editar Venta',
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
              AppTheme.info.withValues(alpha: 0.05),
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
                  gradient: theme.AppGradients.info,
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
                      'Actualizar Venta',
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
                hintText: 'Ej: Venta de producto X',
                validator: (value) => ValidationUtils.validateRequired(value, 'Descripción'),
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
                hintText: '100.00',
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
                backgroundColor: AppTheme.info,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading.value = true;
                    errorMessage.value = null;

                    try {
                      await ref.read(actualizarVentaProvider((
                        id: venta.id,
                        descripcion: descripcionController.text,
                        monto: double.parse(montoController.text),
                        fecha: venta.fecha,
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
