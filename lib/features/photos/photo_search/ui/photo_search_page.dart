import 'dart:async';

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
        title: const Text('Search Photos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _navigateToSearchHistoryPage,
          ),
        ],
      ),
      body: Padding(
        padding: AppConstants.padding16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CupertinoSearchTextField(
              controller: _searchController,
              style: TextStyle(
                color: context.theme.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            if (hasFailure) ...{
              Expanded(
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
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            } else if (hasNotSearchedForPhotos) ...{
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: AppConstants.spacing48,
                      ),
                      AppSpacingWidgets.verticalSpacing24,
                      Text('Search for photos', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            } else ...{
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(
                    top: AppConstants.spacing32,
                    right: AppConstants.spacing16,
                    left: AppConstants.spacing16,
                  ),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 0.69,
                    mainAxisSpacing: AppConstants.spacing8,
                    crossAxisSpacing: AppConstants.spacing8,
                  ),
                  itemCount: photos.length + 1,
                  itemBuilder: (context, index) {
                    final isLastItem = index == photos.length;
                    if (isLastItem) {
                      if (!hasMore) {
                        return const SizedBox();
                      }
                      return LoadMoreItem(
                        onShow: () {
                          ref.read(photoSearchProvider.notifier).searchPhotos(
                                query: ref.read(photoSearchProvider).query,
                              );
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
                ),
              ),
            },
          ],
        ),
      ),
    );
  }

  Future<void> _updateSearchQuery() async {
    final searchQuery = _searchController.text;
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        ref.read(photoSearchProvider.notifier).setQuery(searchQuery);
      },
    );
  }

  void _listenToQueryUpdatesAndRateLimitErrors() {
    ref.listen<String>(
      photoSearchProvider.select((value) => value.query),
      (String? previous, String query) async {
        final sanitizedQuery = query.trim();
        if (sanitizedQuery.isEmpty) {
          return;
        }

        ref.read(searchHistoryProvider.notifier).addSearchQuery(query);
        ref.read(photoSearchProvider.notifier).searchPhotos(
              query: sanitizedQuery,
              page: 1,
            );
      },
    );
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
    final searchQuery =
        await Navigator.of(context).pushNamed(SearchHistoryPage.routePath);

    if (searchQuery is! String || searchQuery.isEmpty) {
      return;
    }

    _searchController.text = searchQuery;
  }
}
