import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  final VoidCallback onNavigateBack;
  final VoidCallback onNavigateToHome;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.onNavigateBack,
    required this.onNavigateToHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onNavigateBack,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              child: Icon(Icons.person, size: 80),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'User ID: $userId',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Profile Information',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: onNavigateToHome,
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
