import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
            Text('User ID: $userId', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: AppSpacing.md),
            Text('Profile Information', style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
