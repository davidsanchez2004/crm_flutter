import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/resumen_provider.dart';
import '../../ventas/providers/ventas_provider.dart';
import '../../gastos/providers/gastos_provider.dart';
import '../../notificaciones/providers/notificaciones_provider.dart';

class ResumenPage extends HookConsumerWidget {
  const ResumenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final ventasCount = ref.watch(allVentasProvider).whenData((v) => v.length);
    final gastosCount = ref.watch(allGastosProvider).whenData((v) => v.length);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.dark,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.dark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.dark),
            onPressed: () async {
              await ref.read(authServiceProvider).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget de notificaciones de bajo stock
                _NotificacionesBajoStock(ref: ref),
                const SizedBox(height: 24),
                
                balance.when(
                  data: (balanceData) {
                    final total = balanceData?.total ?? 0;
                    final ventasTotal = balanceData?.ventasTotal ?? 0;
                    final gastosTotal = balanceData?.gastosTotal ?? 0;
                    final rentability = ventasTotal > 0
                        ? ((ventasTotal - gastosTotal) / ventasTotal * 100)
                        : 0.0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tarjeta de Balance Principal
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppTheme.border, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Saldo Total',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.textMuted,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          '\$${total.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.dark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.trending_up_rounded,
                                      color: rentability >= 0
                                          ? AppTheme.success
                                          : AppTheme.danger,
                                      size: 28,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                // Métricas secundarias
                                Row(
                                  children: [
                                    Expanded(
                                      child: _MetricaSecundaria(
                                        label: 'Ingresos',
                                        valor: ventasTotal,
                                        icono: Icons.arrow_upward_rounded,
                                        color: AppTheme.success,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _MetricaSecundaria(
                                        label: 'Gastos',
                                        valor: gastosTotal,
                                        icono: Icons.arrow_downward_rounded,
                                        color: AppTheme.danger,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _MetricaSecundaria(
                                        label: 'Margen',
                                        valor: rentability,
                                        isPercentage: true,
                                        icono: Icons.percent_rounded,
                                        color: rentability >= 0
                                            ? AppTheme.success
                                            : AppTheme.danger,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Resumen rápido
                        Text(
                          'Resumen',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.dark,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _TarjetaResumen(
                                titulo: 'Ventas',
                                icono: Icons.shopping_bag_outlined,
                                color: AppTheme.info,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TarjetaResumen(
                                titulo: 'Gastos',
                                icono: Icons.receipt_long_outlined,
                                color: AppTheme.warning,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Acciones principales
                        Text(
                          'Acciones',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.dark,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          children: [
                            _BotonAccion(
                              label: 'Nueva Venta',
                              icono: Icons.add_circle_outline_rounded,
                              color: AppTheme.info,
                              onTap: () => context.push('/ventas/add'),
                            ),
                            _BotonAccion(
                              label: 'Registrar Gasto',
                              icono: Icons.add_circle_outline_rounded,
                              color: AppTheme.warning,
                              onTap: () => context.push('/gastos/add'),
                            ),
                            _BotonAccion(
                              label: 'Productos',
                              icono: Icons.inventory_2_rounded,
                              color: AppTheme.success,
                              onTap: () => context.push('/productos'),
                            ),
                            _BotonAccion(
                              label: 'Reportes',
                              icono: Icons.bar_chart_rounded,
                              color: AppTheme.info,
                              onTap: () => context.push('/reportes'),
                            ),
                            _BotonAccion(
                              label: 'Configuración',
                              icono: Icons.settings_rounded,
                              color: AppTheme.primary,
                              onTap: () => context.push('/configuracion'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: LoadingIndicator()),
                  error: (error, stackTrace) => _ErrorCard(
                    error: error.toString(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricaSecundaria extends StatelessWidget {
  final String label;
  final double valor;
  final IconData icono;
  final Color color;
  final bool isPercentage;

  const _MetricaSecundaria({
    required this.label,
    required this.valor,
    required this.icono,
    required this.color,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icono, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          isPercentage ? '${valor.toStringAsFixed(1)}%' : '\$${valor.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.dark,
          ),
        ),
      ],
    );
  }
}

class _TarjetaResumen extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color color;

  const _TarjetaResumen({
    required this.titulo,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icono, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.dark,
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonAccion extends StatelessWidget {
  final String label;
  final IconData icono;
  final Color color;
  final VoidCallback onTap;

  const _BotonAccion({
    required this.label,
    required this.icono,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.border, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      icono,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.dark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;

  const _ErrorCard({
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.danger.withValues(alpha: 0.08),
        border: Border.all(color: AppTheme.danger, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.danger,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Error al cargar',
                  style: TextStyle(
                    color: AppTheme.danger,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  error,
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para mostrar notificaciones de bajo stock
class _NotificacionesBajoStock extends ConsumerWidget {
  final WidgetRef ref;

  const _NotificacionesBajoStock({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bajoStock = ref.watch(productosConBajoStockProvider);
    final tieneNotificaciones = ref.watch(tieneNotificacionesSinLeerProvider);

    if (bajoStock.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.warning.withValues(alpha: 0.1),
        border: Border.all(color: AppTheme.warning, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${bajoStock.length} producto(s) con stock bajo',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.dark,
                  ),
                ),
              ),
              if (tieneNotificaciones)
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.danger,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Text(
                    '!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(maxHeight: 150),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: bajoStock.length,
              itemBuilder: (context, index) {
                final producto = bajoStock[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          producto.nombre,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.dark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${producto.stockActual.toInt()} / ${producto.stockMinimo.toInt()}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}







