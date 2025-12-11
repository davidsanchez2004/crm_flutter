import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/theme/app_theme.dart' as theme show AppGradients;
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_input.dart';
import '../../../shared/utils/validation_utils.dart';
import '../models/producto.dart';
import '../providers/productos_provider.dart';
import '../services/productos_service.dart';

class ProductosEditPage extends HookConsumerWidget {
  final Producto producto;

  const ProductosEditPage({
    Key? key,
    required this.producto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nombreController = useTextEditingController(text: producto.nombre);
    final descripcionController = useTextEditingController(text: producto.descripcion);
    final precioCostoController = useTextEditingController(text: producto.precioCosto.toString());
    final precioVentaController = useTextEditingController(text: producto.precioVenta.toString());
    final stockActualController = useTextEditingController(text: producto.stockActual.toString());
    final stockMinimoController = useTextEditingController(text: producto.stockMinimo.toString());
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.success,
        title: const Text(
          'Editar Producto',
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
              Container(
                decoration: BoxDecoration(
                  gradient: theme.AppGradients.success,
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
                      'Actualizar Producto',
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
                'Nombre',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Nombre del producto',
                controller: nombreController,
                hintText: 'Ej: Laptop Dell XPS',
                validator: (value) => ValidationUtils.validateRequired(value, 'Nombre'),
              ),
              const SizedBox(height: 24),

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
                hintText: 'Características del producto',
                maxLines: 3,
                minLines: 2,
                validator: (value) => ValidationUtils.validateRequired(value, 'Descripción'),
              ),
              const SizedBox(height: 24),

              Text(
                'Precio de Costo',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Precio de costo',
                controller: precioCostoController,
                hintText: '1000.00',
                keyboardType: TextInputType.number,
                validator: (value) => ValidationUtils.validateRequired(value, 'Precio de costo'),
              ),
              const SizedBox(height: 24),

              Text(
                'Precio de Venta',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Precio de venta',
                controller: precioVentaController,
                hintText: '1500.00',
                keyboardType: TextInputType.number,
                validator: (value) => ValidationUtils.validateRequired(value, 'Precio de venta'),
              ),
              const SizedBox(height: 24),

              Text(
                'Stock Actual',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Cantidad en stock',
                controller: stockActualController,
                hintText: '50',
                keyboardType: TextInputType.number,
                validator: (value) => ValidationUtils.validateRequired(value, 'Stock actual'),
              ),
              const SizedBox(height: 24),

              Text(
                'Stock Mínimo',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Stock mínimo para alertas',
                controller: stockMinimoController,
                hintText: '10',
                keyboardType: TextInputType.number,
                validator: (value) => ValidationUtils.validateRequired(value, 'Stock mínimo'),
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
                backgroundColor: AppTheme.success,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading.value = true;
                    errorMessage.value = null;

                    try {
                      final productosService = ref.read(productosServiceProvider);
                      await productosService.actualizarProducto(
                        id: producto.id,
                        nombre: nombreController.text,
                        descripcion: descripcionController.text,
                        precioCosto: double.parse(precioCostoController.text),
                        precioVenta: double.parse(precioVentaController.text),
                        stockActual: double.parse(stockActualController.text),
                        stockMinimo: double.parse(stockMinimoController.text),
                      );

                      ref.invalidate(productosListProvider);

                      if (context.mounted) {
                        context.pop();
                      }
                    } catch (e) {
                      errorMessage.value = 'Error: ${e.toString()}';
                      print('Error actualizando producto: $e');
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
