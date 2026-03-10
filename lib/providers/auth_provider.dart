import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kigali_city_services/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Stream of the current Firebase user
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).user;
});

// Provider to check if user is verified
final emailVerifiedProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.reloadUser(); // refresh status
  return authService.isEmailVerified;
});