import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../services/backup_service.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return BackupService(client: supabase);
});

final crearBackupProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  final userId = supabase.auth.currentUser!.id;
  final service = ref.watch(backupServiceProvider);
  
  final backup = await service.crearBackupCompleto(userId);
  await service.guardarBackupEnStorage(userId, backup);
  
  return backup;
});

final obtenerBackupsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  final userId = supabase.auth.currentUser!.id;
  final service = ref.watch(backupServiceProvider);
  
  final backups = await service.obtenerBackupsGuardados(userId);
  return backups;
});

final descargarBackupProvider =
    FutureProvider.family<String, int>((ref, backupId) async {
  final service = ref.watch(backupServiceProvider);
  return service.descargarBackup(backupId);
});

final eliminarBackupProvider =
    FutureProvider.family<void, int>((ref, backupId) async {
  final service = ref.watch(backupServiceProvider);
  await service.eliminarBackup(backupId);
  ref.invalidate(obtenerBackupsProvider);
});
