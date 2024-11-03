import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class SearchHistoryPage extends ConsumerWidget {
  const SearchHistoryPage({super.key});

  static const routePath = '/search-history';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previousSearchQueries = ref.watch(
      searchHistoryProvider.select((value) => value.searchQueries),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search History'),
      ),
      body: previousSearchQueries.isEmpty
          ? const _EmptySearchHistory()
          : _SearchHistoryList(
              searchQueries: previousSearchQueries,
              onDeleted: (searchQuery) {
                _deletePreviousSearchQueryIfNeeded(
                  context: context,
                  searchHistoryController:
                      ref.read(searchHistoryProvider.notifier),
                  searchQuery: searchQuery,
                );
              },
            ),
    );
  }

  Future<void> _deletePreviousSearchQueryIfNeeded({
    required BuildContext context,
    required SearchHistoryController searchHistoryController,
    required String searchQuery,
  }) async {
    final shouldDelete = await showConfirmationDialog(context: context);
    if (!shouldDelete) return;
    if (!context.mounted) return;
    unawaited(
      searchHistoryController.removeSearchQuery(searchQuery),
    );
  }
}

class _EmptySearchHistory extends StatelessWidget {
  const _EmptySearchHistory({
    // ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: AppConstants.spacing48,
          ),
          AppSpacingWidgets.horizontalSpacing24,
          Text(
            'No search history',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SearchHistoryList extends StatelessWidget {
  const _SearchHistoryList({
    // ignore: unused_element
    super.key,
    required this.searchQueries,
    required this.onDeleted,
  });

  final List<String> searchQueries;
  final Function(String) onDeleted;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchQueries.length,
      itemBuilder: (context, index) {
        final searchQuery = searchQueries[index];
        return ListTile(
          title: Text(searchQuery),
          onTap: () {
            Navigator.of(context).pop(searchQuery);
          },
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDeleted(searchQuery),
          ),
        );
      },
    );
  }
}
