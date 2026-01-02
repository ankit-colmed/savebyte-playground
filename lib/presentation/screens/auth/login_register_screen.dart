// lib/presentation/screens/auth/login_register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/extensions/string_extensions.dart';
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
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late TextEditingController _confirmPasswordController;

  bool _isLoginMode = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _emailError;
  String? _passwordError;
  String? _nameError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Login' : 'Register'),
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            _showErrorSnackBar(context, state.message);
          }
          if (state is AuthAuthenticatedState) {
            // Use post-frame callback to safely navigate
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onNavigateToHome();
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
              Responsive.getScaledValue(context, AppSpacing.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.lg),
                _buildHeader(),
                SizedBox(height: AppSpacing.xl),
                _buildForm(),
                SizedBox(height: AppSpacing.lg),
                _buildSubmitButton(context),
                SizedBox(height: AppSpacing.md),
                _buildToggleAuthMode(),
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Icon(
            _isLoginMode ? Icons.login : Icons.person_add,
            size: 64,
            color: AppColors.primary,
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            _isLoginMode ? 'Welcome Back' : 'Create Account',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            _isLoginMode
                ? 'Login to your account'
                : 'Create a new account to get started',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        if (!_isLoginMode) ...[
          _buildNameField(),
          SizedBox(height: AppSpacing.md),
        ],
        _buildEmailField(),
        SizedBox(height: AppSpacing.md),
        _buildPasswordField(),
        SizedBox(height: AppSpacing.md),
        if (!_isLoginMode) ...[
          _buildConfirmPasswordField(),
          SizedBox(height: AppSpacing.md),
        ],
        if (_isLoginMode) _buildForgotPasswordButton(),
      ],
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: const Icon(Icons.person),
        errorText: _nameError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      onChanged: (_) {
        setState(() => _nameError = null);
      },
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email),
        errorText: _emailError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      onChanged: (_) {
        setState(() => _emailError = null);
      },
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.primary,
          ),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
        errorText: _passwordError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      onChanged: (_) {
        setState(() => _passwordError = null);
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Confirm your password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.primary,
          ),
          onPressed: () {
            setState(() =>
            _obscureConfirmPassword = !_obscureConfirmPassword);
          },
        ),
        errorText: _confirmPasswordError,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      onChanged: (_) {
        setState(() => _confirmPasswordError = null);
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          _showSnackBar(context, 'Password reset feature coming soon');
        },
        child: const Text('Forgot password?'),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _isLoginMode ? widget.onNavigateToHome : _handleSubmit, //isLoading ? null : _handleSubmit,
            icon: isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Icon(_isLoginMode ? Icons.login : Icons.person_add),
            label: Text(
              isLoading
                  ? (_isLoginMode ? 'Logging in...' : 'Creating account...')
                  : (_isLoginMode ? 'Login' : 'Register'),
              style: const TextTheme(
                labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ).labelLarge,
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleAuthMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLoginMode ? "Don't have an account? " : 'Already have an account? ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            _clearForm();
            setState(() => _isLoginMode = !_isLoginMode);
          },
          child: Text(
            _isLoginMode ? 'Register' : 'Login',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    if (!_validateForm()) {
      return;
    }

    if (_isLoginMode) {
      context.read<AuthBloc>().add(
        AuthLoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    } else {
      context.read<AuthBloc>().add(
        AuthRegisterEvent(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  bool _validateForm() {
    bool isValid = true;

    // Validate name for register mode
    if (!_isLoginMode) {
      if (_nameController.text.trim().isEmpty) {
        setState(() => _nameError = 'Name is required');
        isValid = false;
      } else if (_nameController.text.trim().length < 3) {
        setState(() => _nameError = 'Name must be at least 3 characters');
        isValid = false;
      }
    }

    // Validate email
    if (_emailController.text.trim().isEmpty) {
      setState(() => _emailError = 'Email is required');
      isValid = false;
    } else if (!_emailController.text.trim().isValidEmail) {
      setState(() => _emailError = 'Enter a valid email');
      isValid = false;
    }

    // Validate password
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      isValid = false;
    } else if (!_passwordController.text.isValidPassword) {
      setState(() =>
      _passwordError = 'Password must be at least 6 characters');
      isValid = false;
    }

    // Validate confirm password for register mode
    if (!_isLoginMode) {
      if (_confirmPasswordController.text.isEmpty) {
        setState(() => _confirmPasswordError = 'Please confirm your password');
        isValid = false;
      } else if (_passwordController.text !=
          _confirmPasswordController.text) {
        setState(() => _confirmPasswordError = 'Passwords do not match');
        isValid = false;
      }
    }

    return isValid;
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    _confirmPasswordController.clear();
    _emailError = null;
    _passwordError = null;
    _nameError = null;
    _confirmPasswordError = null;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            SizedBox(width: AppSpacing.md),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}