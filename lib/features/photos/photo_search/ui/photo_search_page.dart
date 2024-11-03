import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class PhotoSearchPage extends ConsumerStatefulWidget {
  const PhotoSearchPage({super.key});

  static const routePath = '/photo-search';

  @override
  ConsumerState<PhotoSearchPage> createState() =>
      _PhotoSearchPageConsumerState();
}

class _PhotoSearchPageConsumerState extends ConsumerState<PhotoSearchPage> {
  final _searchController = TextEditingController();
  // Create a timer to debounce the search query
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      _updateSearchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _listenToQueryUpdatesAndRateLimitErrors();

    final photoSearchPhotosState = ref.watch(
      photoSearchProvider,
    );
    final isLoading = photoSearchPhotosState.isLoading;
    final photos = photoSearchPhotosState.photos;
    final hasNotSearchedForPhotos = photos.isEmpty && !isLoading;
    final hasFailure = photoSearchPhotosState.failure != null && photos.isEmpty;
    final failure = photoSearchPhotosState.failure;
    final hasMore = photoSearchPhotosState.hasMore;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            centerTitle: true,
            title: Text(
              'Search Photos',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.foregroundColor,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: _navigateToSearchHistoryPage,
              ),
            ],
          ),
          SliverPadding(
            padding: AppConstants.padding16,
            sliver: SliverList.list(
              children: [
                Hero(
                  tag: 'search_photos_bar',
                  child: CupertinoSearchTextField(
                    placeholder: 'Search for photos',
                    autofocus: true,
                    controller: _searchController,
                    style: TextStyle(
                      color: context.theme.brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (hasFailure) ...{
            SliverFillRemaining(
              child: Center(
                child: GenericError(
                  errorText: failure!.message,
                  onRetry: () {
                    ref.read(photoSearchProvider.notifier).searchPhotos(
                          query: ref.read(photoSearchProvider).query,
                          page: 1,
                        );
                  },
                ),
              ),
            ),
          } else if (isLoading) ...{
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          } else if (hasNotSearchedForPhotos) ...{
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: AppConstants.spacing48,
                    ),
                    AppSpacingWidgets.verticalSpacing16,
                    Text(
                      'Search for photos',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          } else ...{
            SliverPadding(
              padding: AppConstants.padding16,
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final isLastItem = index == photos.length;
                    if (isLastItem) {
                      if (!hasMore) {
                        return const SizedBox();
                      }
                      return LoadMoreItem(
                        onShow: () {
                          ref.read(photoSearchProvider.notifier).searchPhotos();
                        },
                        key: Key(
                          'load_more_search_photos_page_length_${photos.length}',
                        ),
                      );
                    }
                    final photo = photos[index];
                    final isFavoritePhoto = ref.watch(
                      favoritePhotosProvider.select(
                        (value) => value.favoritePhotoIds.contains(photo.id),
                      ),
                    );
                    final isRightSide = index % 2 != 0;

                    return PhotoItem(
                      photo: photo,
                      isFavoritePhoto: isFavoritePhoto,
                      isRightSide: isRightSide,
                      onFavoritePressed: () {
                        FavoritePhotosHelpers.toggleFavoritePhoto(
                          context: context,
                          photo: photo,
                          controller: ref.read(favoritePhotosProvider.notifier),
                          favoritePhotos:
                              ref.read(favoritePhotosProvider).favoritePhotos,
                        );
                      },
                    );
                  },
                  childCount: photos.length + 1,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 0.69,
                  mainAxisSpacing: AppConstants.spacing8,
                  crossAxisSpacing: AppConstants.spacing8,
                ),
              ),
            ),
          },
        ],
      ),
    );
  }

  Future<void> _updateSearchQuery() async {
    final searchQuery = _searchController.text;
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(
      const Duration(milliseconds: 750),
      () {
        final controller = ref.read(photoSearchProvider.notifier);
        final searchHistoryController =
            ref.read(searchHistoryProvider.notifier);
        final sanitizedQuery = searchQuery.trim();
        if (sanitizedQuery.isEmpty) {
          controller.clearSearchResults();
          return;
        }

        searchHistoryController.addSearchQuery(sanitizedQuery);
        controller.searchPhotos(
          query: sanitizedQuery,
          page: 1,
        );
      },
    );
  }

  void _listenToQueryUpdatesAndRateLimitErrors() {
    ref.listen<PhotoFailure?>(
      photoSearchProvider.select((value) => value.failure),
      (PhotoFailure? _, PhotoFailure? failure) {
        if (failure == null) {
          return;
        }
        if (failure.type == PhotoFailureType.rateLimitExceeded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
            ),
          );
        }
      },
    );
  }

  Future<void> _navigateToSearchHistoryPage() async {
    try {
      // Push is used here instead of pushNamed to get the result from the page
      // There's an issue with pushNamed that doesn't return the result.
      // https://github.com/flutter/flutter/issues/57186
      final searchQuery = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SearchHistoryPage(),
        ),
      );
      if (searchQuery is! String) {
        return;
      }
      if (searchQuery.isEmpty) {
        return;
      }
      _searchController.text = searchQuery;
    } catch (e) {
      log('Error navigating to search history page: $e');
    }
  }
}
