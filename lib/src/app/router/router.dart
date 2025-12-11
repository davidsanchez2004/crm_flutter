import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/ventas/presentation/ventas_list_page.dart';
import '../../features/ventas/presentation/ventas_form_page.dart';
import '../../features/gastos/presentation/gastos_list_page.dart';
import '../../features/gastos/presentation/gastos_form_page.dart';
import '../../features/productos/presentation/productos_list_page.dart';
import '../../features/productos/presentation/productos_form_page.dart';
import '../../features/resumen/presentation/resumen_page.dart';
import '../../features/resumen/presentation/reportes_page.dart';
import '../../features/resumen/presentation/exportar_page.dart';
import '../../features/clientes/presentation/clientes_list_page.dart';
import '../../features/clientes/presentation/clientes_form_page.dart';
import '../../features/notas/presentation/notas_form_page.dart';
import '../../features/notificaciones/presentation/notificaciones_page.dart';
import '../../features/backup/presentation/backup_page.dart';
import '../../features/configuracion/presentation/configuracion_page.dart';
import '../../features/configuracion/presentation/perfil_page.dart';
import '../../shared/providers/supabase_provider.dart';
final goRouterProvider = Provider<GoRouter>((ref) {
  final supabase = ref.watch(supabaseProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuth = supabase.auth.currentSession != null;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isAuth && !isLoggingIn) {
        return '/login';
      }

      if (isAuth && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const ResumenPage(),
      ),
      GoRoute(
        path: '/reportes',
        name: 'reportes',
        builder: (context, state) => const ReportesPage(),
      ),
      GoRoute(
        path: '/exportar',
        name: 'exportar',
        builder: (context, state) => const ExportarPage(),
      ),
      GoRoute(
        path: '/ventas',
        name: 'ventas',
        builder: (context, state) => const VentasListPage(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'ventas-add',
            builder: (context, state) => const VentasFormPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/gastos',
        name: 'gastos',
        builder: (context, state) => const GastosListPage(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'gastos-add',
            builder: (context, state) => const GastosFormPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/productos',
        name: 'productos',
        builder: (context, state) => const ProductosListPage(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'productos-add',
            builder: (context, state) => const ProductosFormPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/clientes',
        name: 'clientes',
        builder: (context, state) => const ClientesListPage(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'clientes-add',
            builder: (context, state) => const ClientesFormPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/notas/add',
        name: 'notas-add',
        builder: (context, state) => const NotasFormPage(),
      ),
      GoRoute(
        path: '/notificaciones',
        name: 'notificaciones',
        builder: (context, state) => const NotificacionesPage(),
      ),
      GoRoute(
        path: '/backup',
        name: 'backup',
        builder: (context, state) => const BackupPage(),
      ),
      GoRoute(
        path: '/configuracion',
        name: 'configuracion',
        builder: (context, state) => const ConfiguracionPage(),
      ),
      GoRoute(
        path: '/perfil',
        name: 'perfil',
        builder: (context, state) => const PerfilPage(),
      ),
    ],
  );
});

