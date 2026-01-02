// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToSearch;
  final Function(String userId) onNavigateToProfile;
  final VoidCallback onNavigateToLogin;

  const HomeScreen({
    super.key,
    required this.onNavigateToSearch,
    required this.onNavigateToProfile,
    required this.onNavigateToLogin,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeInitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: widget.onNavigateToSearch,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => widget.onNavigateToProfile('1'),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const HomeRefreshEvent());
              },
              child: ListView(
                padding: EdgeInsets.all(
                  Responsive.getScaledValue(context, AppSpacing.md),
                ),
                children: [
                  _buildFeatureCard(
                    context,
                    'BLoC State Management',
                    'Centralized state with BLoC pattern',
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildFeatureCard(
                    context,
                    'Centralized Navigation',
                    'All navigation in one place',
                    onTap: () => widget.onNavigateToProfile('user123'),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildFeatureCard(
                    context,
                    'Search Feature',
                    'Navigate to search screen',
                    onTap: widget.onNavigateToSearch,
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildFeatureCard(
                    context,
                    'Dependency Injection',
                    'GetIt service locator',
                  ),
                  SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthLogoutEvent());
                      Future.delayed(const Duration(milliseconds: 500), () {
                        widget.onNavigateToLogin();
                      });
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ],
              ),
            );
          } else if (state is HomeErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context,
      String title,
      String description, {
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(
            Responsive.getScaledValue(context, AppSpacing.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}