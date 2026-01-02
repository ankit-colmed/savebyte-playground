import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';

class SearchScreen extends StatefulWidget {
  final Function(String id) onNavigateToDetail;
  final VoidCallback onNavigateBack;

  const SearchScreen({
    super.key,
    required this.onNavigateToDetail,
    required this.onNavigateBack,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onNavigateBack,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  widget.onNavigateToDetail(query);
                }
              },
            ),
            SizedBox(height: AppSpacing.lg),
            Expanded(
              child: Center(
                child: Text(
                  'Search results will appear here',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}