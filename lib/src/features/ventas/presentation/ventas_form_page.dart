import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/theme/app_theme.dart' as theme show AppGradients;
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_input.dart';
import '../../../shared/utils/validation_utils.dart';
import '../providers/ventas_provider.dart';
import '../services/ventas_service.dart';
import '../../productos/providers/productos_provider.dart';
import '../../productos/models/producto.dart';

class VentasFormPage extends HookConsumerWidget {
  const VentasFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final montoController = useTextEditingController();
    final descripcionController = useTextEditingController();
    final cantidadController = useTextEditingController();
    final fechaSeleccionada = useState<DateTime>(DateTime.now());
    final productoSeleccionadoId = useState<int?>(null);
    final productoSeleccionadoNombre = useState<String?>('');
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final productosAsync = ref.watch(productosListProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.info,
        title: const Text(
          'Registrar Venta',
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
              // Header card
              Container(
                decoration: BoxDecoration(
                  gradient: theme.AppGradients.info,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Nueva Venta',
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
              
              // Producto selector
              Text(
                'Producto',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              productosAsync.when(
                data: (productos) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Selecciona un producto'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: productos.length,
                            itemBuilder: (context, index) {
                              final producto = productos[index];
                              return ListTile(
                                title: Text(producto.nombre),
                                subtitle: Text('\$${producto.precioVenta.toStringAsFixed(2)}'),
                                onTap: () {
                                  productoSeleccionadoId.value = producto.id;
                                  productoSeleccionadoNombre.value = producto.nombre;
                                  cantidadController.text = '1';
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    if (ctx.mounted) Navigator.of(ctx).pop();
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.lightBorder),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            productoSeleccionadoNombre.value?.isEmpty ?? true
                                ? 'Selecciona un producto'
                                : productoSeleccionadoNombre.value!,
                            style: TextStyle(
                              color: (productoSeleccionadoNombre.value?.isEmpty ?? true)
                                  ? Colors.grey[600]
                                  : AppTheme.dark,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: AppTheme.info),
                      ],
                    ),
                  ),
                ),
                loading: () => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.lightBorder),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const CircularProgressIndicator(),
                ),
                error: (error, stack) => Container(
                  decoration: BoxDecoration(
                    color: AppTheme.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.danger),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Error cargando productos: $error',
                    style: TextStyle(color: AppTheme.danger),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Cantidad input
              Text(
                'Cantidad',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Cantidad a vender',
                controller: cantidadController,
                keyboardType: TextInputType.number,
                hintText: '1',
                validator: (value) => ValidationUtils.validatePositiveNumber(value, 'Cantidad'),
                onChanged: (value) {
                  // Recalcular monto cuando cambia cantidad
                  if (productoSeleccionadoId.value != null && value.isNotEmpty) {
                    final cantidad = double.tryParse(value) ?? 0;
                    productosAsync.whenData((productos) {
                      final producto = productos.firstWhere((p) => p.id == productoSeleccionadoId.value);
                      final nuevoMonto = cantidad * producto.precioVenta;
                      montoController.text = nuevoMonto.toStringAsFixed(2);
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Precio display (readonly)
              if (productoSeleccionadoId.value != null) ...[
                Text(
                  'Precio',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                productosAsync.when(
                  data: (productos) {
                    final producto = productos.firstWhere((p) => p.id == productoSeleccionadoId.value);
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.lightBorder),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unitario: \$${producto.precioVenta.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total: \$${(double.tryParse(cantidadController.text) ?? 0) * producto.precioVenta}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.info,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.lightBorder),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const CircularProgressIndicator(),
                  ),
                  error: (err, stack) => Container(
                    decoration: BoxDecoration(
                      color: AppTheme.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.danger),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: $err', style: TextStyle(color: AppTheme.danger)),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Descripción input
              Text(
                'Descripción',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              CustomInput(
                label: 'Detalles de la venta',
                controller: descripcionController,
                hintText: 'Ej: Venta de productos electrónicos...',
                maxLines: 4,
                minLines: 2,
                validator: (value) => ValidationUtils.validateRequired(value, 'Descripción'),
              ),
              const SizedBox(height: 24),

              // Fecha picker
              Text(
                'Fecha',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.dark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.lightBorder),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.calendar_today,
                      color: AppTheme.info,
                    ),
                  ),
                  title: Text(
                    '${fechaSeleccionada.value.day}/${fechaSeleccionada.value.month}/${fechaSeleccionada.value.year}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.dark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppTheme.info,
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: fechaSeleccionada.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      fechaSeleccionada.value = picked;
                    }
                  },
                ),
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
                label: 'Guardar venta',
                isLoading: isLoading.value,
                backgroundColor: AppTheme.info,
                onPressed: () async {
                  if (formKey.currentState!.validate() && productoSeleccionadoId.value != null) {
                    isLoading.value = true;
                    errorMessage.value = null;

                    try {
                      // Validaciones
                      if (cantidadController.text.isEmpty) {
                        throw Exception('La cantidad no puede estar vacía');
                      }
                      
                      final ventasService = ref.read(ventasServiceProvider);
                      final productos = await ref.read(productosListProvider.future);
                      final producto = productos.firstWhere((p) => p.id == productoSeleccionadoId.value);
                      
                      final cantidadStr = cantidadController.text.trim();
                      final cantidad = int.parse(cantidadStr);
                      
                      if (cantidad <= 0) {
                        throw Exception('La cantidad debe ser mayor a 0');
                      }
                      
                      final monto = producto.precioVenta * cantidad;
                      final desc = descripcionController.text.trim();
                      
                      await ventasService.crearVenta(
                        monto: monto,
                        descripcion: desc.isEmpty ? 'Sin descripción' : desc,
                        fecha: fechaSeleccionada.value,
                        productoId: productoSeleccionadoId.value!,
                        cantidad: cantidad,
                      );

                      if (context.mounted) {
                        context.pop();
                      }
                    } catch (e) {
                      errorMessage.value = e.toString();
                    } finally {
                      isLoading.value = false;
                    }
                  } else if (productoSeleccionadoId.value == null) {
                    errorMessage.value = 'Por favor selecciona un producto';
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
