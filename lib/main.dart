import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kigali_city_services/screens/auth/login_screen.dart';
import 'package:kigali_city_services/screens/auth/signup_screen.dart';
import 'package:kigali_city_services/screens/auth/verify_email_screen.dart';
import 'package:kigali_city_services/screens/home/main_screen.dart';
import 'package:kigali_city_services/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Kigali City Services',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authStateProvider);
          return authState.when(
            data: (user) {
              if (user == null) return const LoginScreen();
              // Check email verification
              return FutureBuilder<bool>(
                future: ref.read(authServiceProvider).isEmailVerified
                    ? Future.value(true)
                    : ref.read(authServiceProvider).reloadUser().then((_) =>
                        ref.read(authServiceProvider).isEmailVerified),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.data == true) {
                    return const MainScreen();
                  } else {
                    return const VerifyEmailScreen();
                  }
                },
              );
            },
            loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => Scaffold(
              body: Center(child: Text('Error: $err')),
            ),
          );
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
    );
  }
}
