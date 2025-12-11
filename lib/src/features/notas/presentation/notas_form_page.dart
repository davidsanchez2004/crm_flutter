import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/theme/app_theme.dart' as theme show AppGradients;
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_input.dart';
import '../../../shared/utils/validation_utils.dart';
import '../providers/notas_provider.dart';

class NotasFormPage extends HookConsumerWidget {
  final String? ventaId;
  final String? gastoId;
  final String? productoId;

  const NotasFormPage({
    Key? key,
    this.ventaId,
    this.gastoId,
    this.productoId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contenidoController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.warning,
        title: const Text(
          'Nueva Nota',
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
              AppTheme.warning.withValues(alpha: 0.05),
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
                  gradient: theme.AppGradients.warning,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.note_add,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Agregar Nota',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Registra observaciones importantes',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Contenido',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Nota',
                controller: contenidoController,
                hintText: 'Escribe tu observación aquí...',
                maxLines: 5,
                minLines: 4,
                validator: (value) => ValidationUtils.validateRequired(value, 'Contenido'),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.info.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.info),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tipo de Registro',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.dark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getTipoRegistro(),
                            style: TextStyle(
                              color: AppTheme.dark.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                label: 'Guardar Nota',
                isLoading: isLoading.value,
                backgroundColor: AppTheme.warning,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading.value = true;
                    errorMessage.value = null;

                    try {
                      await ref.read(crearNotaProvider((
                        contenido: contenidoController.text,
                        ventaId: ventaId,
                        gastoId: gastoId,
                        productoId: productoId,
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

  String _getTipoRegistro() {
    if (ventaId != null) return 'Nota asociada a una Venta';
    if (gastoId != null) return 'Nota asociada a un Gasto';
    if (productoId != null) return 'Nota asociada a un Producto';
    return 'Nota general';
  }
}
