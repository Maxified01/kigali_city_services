import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
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
        primarySwatch: Colors.blue, // fallback, but we'll override
        primaryColor: const Color(0xFF00A1DE), // Rwanda blue
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00A1DE), // blue
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFAD201), // yellow
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A1DE), // blue
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF00A1DE),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00A1DE), width: 2),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF00A1DE),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          primary: const Color(0xFF00A1DE),
          secondary: const Color(0xFFFAD201),
        ),
      ),
      home: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authStateProvider);
          return authState.when(
            data: (user) {
              if (user == null) return const LoginScreen();
              return FutureBuilder<bool>(
                future: ref.read(authServiceProvider).isEmailVerified
                    ? Future.value(true)
                    : ref.read(authServiceProvider).reloadUser().then(
                          (_) => ref.read(authServiceProvider).isEmailVerified,
                        ),
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
        '/verify': (context) => const VerifyEmailScreen(),
      },
    );
  }
}
