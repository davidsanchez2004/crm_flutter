import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/utils/date_utils.dart' as date_utils;
import '../providers/notificaciones_provider.dart';

class NotificacionesPage extends ConsumerWidget {
  const NotificacionesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificacionesAsync = ref.watch(notificacionesListProvider);
    final noLeidasAsync = ref.watch(notificacionesNoLeidasProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.warning,
        title: const Text(
          'Notificaciones',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          noLeidasAsync.whenData((noLeidas) {
            return noLeidas.isNotEmpty
                ? TextButton(
                    onPressed: () async {
                      await ref.read(marcarTodasComoLeidasProvider.future);
                    },
                    child: const Text(
                      'Marcar todas como leídas',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : const SizedBox();
          }).when(
            data: (widget) => widget,
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      body: notificacionesAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppTheme.danger,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar notificaciones',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        data: (notificaciones) {
          if (notificaciones.isEmpty) {
            return EmptyState(
              title: 'Sin notificaciones',
              subtitle: 'No tienes notificaciones en este momento',
              icon: Icons.notifications_none,
              actionLabel: 'Volver',
              actionIcon: Icons.arrow_back,
              onActionPressed: () => Navigator.pop(context),
            );
          }

          return Container(
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
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                final notificacion = notificaciones[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: _NotificacionCard(
                    notificacion: notificacion,
                    onDismiss: () async {
                      await ref.read(
                        eliminarNotificacionProvider(notificacion.id).future,
                      );
                    },
                    onTap: () async {
                      if (!notificacion.leida) {
                        await ref.read(
                          marcarComoLeidaProvider(notificacion.id).future,
                        );
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _NotificacionCard extends StatelessWidget {
  final dynamic notificacion;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  const _NotificacionCard({
    required this.notificacion,
    required this.onDismiss,
    required this.onTap,
  });

  Color _getColorByTipo(String tipo) {
    switch (tipo) {
      case 'success':
        return AppTheme.success;
      case 'warning':
        return AppTheme.warning;
      case 'error':
        return AppTheme.danger;
      case 'info':
      default:
        return AppTheme.info;
    }
  }

  IconData _getIconByTipo(String tipo) {
    switch (tipo) {
      case 'success':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'info':
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorByTipo(notificacion.tipo);
    final icon = _getIconByTipo(notificacion.tipo);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: color, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notificacion.titulo,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notificacion.leida)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notificacion.mensaje,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date_utils.DateUtils.formatDate(notificacion.fechaCreacion),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onDismiss,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
