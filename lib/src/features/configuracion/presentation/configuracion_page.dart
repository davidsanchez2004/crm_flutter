import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/theme/app_theme.dart' as theme show AppGradients;
import '../../auth/providers/auth_provider.dart';

class ConfiguracionPage extends HookConsumerWidget {
  const ConfiguracionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primary,
        title: const Text(
          'Configuración',
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
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Sección de Notificaciones
            Text(
              'Notificaciones',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _SettingCard(
              icon: Icons.notifications_active,
              title: 'Ver Notificaciones',
              subtitle: 'Acceso a todas tus notificaciones',
              color: AppTheme.warning,
              onTap: () => context.push('/notificaciones'),
            ),
            const SizedBox(height: 24),

            // Sección de Respaldo
            Text(
              'Respaldo y Seguridad',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _SettingCard(
              icon: Icons.backup,
              title: 'Respaldo de Datos',
              subtitle: 'Crear y gestionar copias de seguridad',
              color: AppTheme.info,
              onTap: () => context.push('/backup'),
            ),
            const SizedBox(height: 24),

            // Sección de Cuenta
            Text(
              'Cuenta',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _SettingCard(
              icon: Icons.person,
              title: 'Perfil',
              subtitle: 'Ver información de tu cuenta',
              color: AppTheme.primary,
              onTap: () => context.push('/perfil'),
            ),
            const SizedBox(height: 12),

            _SettingCard(
              icon: Icons.security,
              title: 'Seguridad',
              subtitle: 'Cambiar contraseña y autenticación',
              color: AppTheme.danger,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Seguridad - Próximamente'),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Sección de Aplicación
            Text(
              'Aplicación',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _SettingCard(
              icon: Icons.info_outline,
              title: 'Acerca de',
              subtitle: 'Versión 1.0.0 - Diciembre 2024',
              color: AppTheme.info,
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'CRM Flutter',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2024 Todos los derechos reservados',
                );
              },
            ),
            const SizedBox(height: 24),

            // Botón de Logout
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.danger.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Cerrar Sesión'),
                        content: const Text(
                          '¿Estás seguro de que deseas cerrar sesión?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await ref.read(authServiceProvider).logout();
                              if (context.mounted) {
                                context.go('/login');
                              }
                            },
                            child: const Text('Cerrar Sesión'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.danger,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: theme.AppGradients.danger,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.chevron_right,
          color: color,
        ),
      ),
    );
  }
}
