// lib/presentation/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToLogin;

  const SplashScreen({
    super.key,
    required this.onNavigateToHome,
    required this.onNavigateToLogin,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticatedState) {
          widget.onNavigateToHome();
        } else if (state is AuthUnauthenticatedState) {
          widget.onNavigateToLogin();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.flutter_dash,
                size: 80,
                color: AppColors.surface,
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Clean Architecture App',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.surface,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.surface),
              ),
            ],
          ),
        ),
      ),
    );
  }
}