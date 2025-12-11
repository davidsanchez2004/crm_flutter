import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/theme/app_theme.dart' as theme show AppGradients;
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_input.dart';
import '../../../shared/utils/validation_utils.dart';
import '../providers/productos_provider.dart';
import '../services/productos_service.dart';

class ProductosFormPage extends HookConsumerWidget {
  const ProductosFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nombreController = useTextEditingController();
    final precioCostoController = useTextEditingController();
    final precioVentaController = useTextEditingController();
    final stockActualController = useTextEditingController();
    final stockMinimoController = useTextEditingController();
    final descripcionController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.success,
        title: const Text(
          'Nuevo Producto',
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
              AppTheme.success.withValues(alpha: 0.05),
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
                  gradient: theme.AppGradients.success,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Registrar Producto',
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
              CustomInput(
                label: 'Nombre del producto',
                controller: nombreController,
                hintText: 'Ej: Laptop Dell XPS...',
                validator: (value) => ValidationUtils.validateRequired(value, 'Nombre'),
              ),
              const SizedBox(height: 24),

              // Precio de Costo
              CustomInput(
                label: 'Precio de costo',
                controller: precioCostoController,
                keyboardType: TextInputType.number,
                hintText: '0.00',
                validator: (value) => ValidationUtils.validatePositiveNumber(value, 'Precio de costo'),
              ),
              const SizedBox(height: 24),

              // Precio de Venta
              CustomInput(
                label: 'Precio de venta',
                controller: precioVentaController,
                keyboardType: TextInputType.number,
                hintText: '0.00',
                validator: (value) => ValidationUtils.validatePositiveNumber(value, 'Precio de venta'),
              ),
              const SizedBox(height: 24),

              // Stock actual
              CustomInput(
                label: 'Stock actual',
                controller: stockActualController,
                keyboardType: const TextInputType.numberWithOptions(signed: false),
                hintText: '0',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stock actual es requerido';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Stock debe ser un número';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Stock mínimo
              CustomInput(
                label: 'Stock mínimo para alertas',
                controller: stockMinimoController,
                keyboardType: const TextInputType.numberWithOptions(signed: false),
                hintText: '10',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stock mínimo es requerido';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Stock mínimo debe ser un número';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Descripción input
              CustomInput(
                label: 'Descripción del producto',
                controller: descripcionController,
                hintText: 'Detalles del producto...',
                maxLines: 4,
                minLines: 2,
                validator: (value) => ValidationUtils.validateRequired(value, 'Descripción'),
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
                label: 'Guardar producto',
                isLoading: isLoading.value,
                backgroundColor: AppTheme.success,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading.value = true;
                    errorMessage.value = null;

                    try {
                      final productosService = ref.read(productosServiceProvider);
                      await productosService.crearProducto(
                        nombre: nombreController.text,
                        precioCosto: double.parse(precioCostoController.text),
                        precioVenta: double.parse(precioVentaController.text),
                        stockActual: double.parse(stockActualController.text),
                        stockMinimo: double.parse(stockMinimoController.text),
                        descripcion: descripcionController.text,
                      );

                      // Invalidar el provider para refrescar la lista
                      ref.invalidate(productosListProvider);

                      if (context.mounted) {
                        context.pop();
                      }
                    } catch (e) {
                      errorMessage.value = 'Error: ${e.toString()}';
                      print('Error creando producto: $e');
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
