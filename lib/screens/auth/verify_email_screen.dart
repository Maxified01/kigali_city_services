import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kigali_city_services/providers/auth_provider.dart';

class VerifyEmailScreen extends ConsumerWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_unread, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'A verification email has been sent to your email address. '
                'Please verify and then click the button below.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await authService.reloadUser();
                  // Use context.mounted to check if widget is still in tree
                  if (!context.mounted) return;
                  if (authService.isEmailVerified) {
                    // No navigation needed – auth state will rebuild and show MainScreen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email verified! Welcome.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Email not verified yet. Check your inbox.')),
                    );
                  }
                },
                child: const Text('I have verified'),
              ),
              TextButton(
                onPressed: () async {
                  await authService.signOut();
                  // No need to navigate; auth state will show login screen
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}