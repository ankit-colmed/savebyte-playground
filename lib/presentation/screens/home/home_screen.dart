import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/utils/responsive.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
            onPressed: () => AppNavigation.goToSearch(context),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => AppNavigation.goToProfile(context, '1'),
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
                padding: EdgeInsets.all(Responsive.getScaledValue(context, AppSpacing.md)),
                children: [
                  _buildFeatureCard(context, 'BLoC State Management'),
                  SizedBox(height: AppSpacing.md),
                  _buildFeatureCard(context, 'Type-Safe Navigation'),
                  SizedBox(height: AppSpacing.md),
                  _buildFeatureCard(context, 'Offline Sync'),
                  SizedBox(height: AppSpacing.md),
                  _buildFeatureCard(context, 'Dependency Injection'),
                  SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthLogoutEvent());
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

  Widget _buildFeatureCard(BuildContext context, String title) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(Responsive.getScaledValue(context, AppSpacing.md)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Feature implementation example',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}