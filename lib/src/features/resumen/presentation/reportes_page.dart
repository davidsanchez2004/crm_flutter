import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/theme/app_theme.dart' as theme show AppGradients;
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/utils/date_utils.dart' as utils;
import '../../ventas/providers/ventas_provider.dart';
import '../../gastos/providers/gastos_provider.dart';
import '../../productos/providers/productos_provider.dart';

class ReportesPage extends ConsumerWidget {
  const ReportesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventasAsync = ref.watch(ventasListProvider);
    final gastosAsync = ref.watch(gastosListProvider);
    final productosAsync = ref.watch(productosListProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primary,
        title: const Text(
          'Reportes y Análisis',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ventasAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (ventas) => gastosAsync.when(
          loading: () => const Center(child: LoadingIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (gastos) => productosAsync.when(
            loading: () => const Center(child: LoadingIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (productos) {
              // Calcular totales
              final totalVentas = ventas.fold<double>(
                0,
                (sum, venta) => sum + (venta.monto ?? 0),
              );
              final totalGastos = gastos.fold<double>(
                0,
                (sum, gasto) => sum + (gasto.monto ?? 0),
              );
              final ganancia = totalVentas - totalGastos;
              final productosBajoStock = productos
                  .where((p) => p.stockActual < p.stockMinimo)
                  .length;

              return Container(
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
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Tarjeta de Ganancias
                    _ReportCard(
                      title: 'Ganancias Netas',
                      value: utils.DateUtils.formatCurrency(ganancia),
                      icon: Icons.trending_up,
                      gradient: theme.AppGradients.success,
                      color: AppTheme.success,
                    ),
                    const SizedBox(height: 16),

                    // Fila 2x2 de métricas
                    Row(
                      children: [
                        Expanded(
                          child: _ReportCard(
                            title: 'Total Ventas',
                            value: utils.DateUtils.formatCurrency(totalVentas),
                            icon: Icons.shopping_cart,
                            gradient: theme.AppGradients.info,
                            color: AppTheme.info,
                            isSmall: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ReportCard(
                            title: 'Total Gastos',
                            value: utils.DateUtils.formatCurrency(totalGastos),
                            icon: Icons.payments,
                            gradient: theme.AppGradients.danger,
                            color: AppTheme.danger,
                            isSmall: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _ReportCard(
                            title: 'Total Productos',
                            value: '${productos.length}',
                            icon: Icons.inventory,
                            gradient: theme.AppGradients.warning,
                            color: AppTheme.warning,
                            isSmall: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ReportCard(
                            title: 'Stock Bajo',
                            value: '$productosBajoStock',
                            icon: Icons.warning,
                            gradient: theme.AppGradients.danger,
                            color: AppTheme.danger,
                            isSmall: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Detalles
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Detalles por Categoría',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.dark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gastos por categoría
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.danger.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gastos por Categoría',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._buildCategoryBreakdown(gastos),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCategoryBreakdown(List<dynamic> gastos) {
    final categories = <String, double>{};
    for (final gasto in gastos) {
      final categoria = gasto.categoria ?? 'Sin categoría';
      categories[categoria] = (categories[categoria] ?? 0) + (gasto.monto ?? 0);
    }

    return categories.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(entry.key),
            Text(
              utils.DateUtils.formatCurrency(entry.value),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;
  final Color color;
  final bool isSmall;

  const _ReportCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.color,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: isSmall ? 24 : 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: isSmall ? 12 : 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmall ? 18 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
