import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class LoginRegisterScreen extends StatefulWidget {
  final VoidCallback onNavigateToHome;

  const LoginRegisterScreen({
    super.key,
    required this.onNavigateToHome,
  });

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isLoginMode = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginMode ? 'Login' : 'Register'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is AuthAuthenticatedState) {
            widget.onNavigateToHome();
          }
        },
        child: ListView(
          padding: EdgeInsets.all(
            Responsive.getScaledValue(context, AppSpacing.lg),
          ),
          children: [
            SizedBox(height: AppSpacing.xl),
            Text(
              isLoginMode ? 'Welcome Back' : 'Create Account',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is AuthLoadingState ? null : _handleSubmit,
                  child: Text(
                    state is AuthLoadingState
                        ? 'Loading...'
                        : (isLoginMode ? 'Login' : 'Register'),
                  ),
                );
              },
            ),
            SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () {
                setState(() => isLoginMode = !isLoginMode);
              },
              child: Text(
                isLoginMode ? 'Create new account' : 'Already have account?',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (isLoginMode) {
      context.read<AuthBloc>().add(
        AuthLoginEvent(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
    } else {
      context.read<AuthBloc>().add(
        AuthRegisterEvent(
          name: 'User',
          email: emailController.text,
          password: passwordController.text,
        ),
      );
    }
  }
}