import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core.dart';
import '../../features.dart';

class PhotosPage extends ConsumerWidget {
  const PhotosPage({super.key});

  static const routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final photos = ref.watch(
      photosProvider.select((value) => value.photos),
    );
    final hasMore = ref.watch(
      photosProvider.select((value) => value.hasMore),
    );
    final hasError = ref.watch(
      photosProvider.select((value) => value.failure != null),
    );
    final isLoading = ref.watch(
      photosProvider.select((value) => value.isLoading),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      drawer: AppDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _navigateToSearchPage(context),
              ),
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () => _navigateToFavoritesPage(context),
              ),
            ],
            title: Text(
              'Photos',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.foregroundColor,
              ),
            ),
          ),
          if (isLoading) ...{
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          } else if (hasError) ...{
            SliverFillRemaining(
              child: GenericError(
                errorText: ref.watch(
                  photosProvider
                      .select((value) => value.failure?.message ?? 'Error'),
                ),
                onRetry: () {
                  ref.read(photosProvider.notifier).getPhotos();
                },
              ),
            ),
          } else ...{
            SliverPadding(
              padding: const EdgeInsets.only(
                top: AppConstants.spacing32,
                right: AppConstants.spacing24,
                left: AppConstants.spacing24,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (
                    BuildContext context,
                    int index,
                  ) {
                    final isLastItem = index == photos.length;
                    if (isLastItem) {
                      if (!hasMore) {
                        return const SizedBox();
                      }

                      return LoadMoreItem(
                        onShow: () {
                          ref.read(photosProvider.notifier).getMorePhotos();
                        },
                        key: Key(
                          'load_more_photos_page_length_${photos.length}',
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
                      isRightSide: isRightSide,
                      isFavoritePhoto: isFavoritePhoto,
                      onFavoritePressed: () =>
                          FavoritePhotosHelpers.toggleFavoritePhoto(
                        context: context,
                        photo: photo,
                        controller: ref.read(favoritePhotosProvider.notifier),
                        favoritePhotos:
                            ref.read(favoritePhotosProvider).favoritePhotos,
                      ),
                    );
                  },
                  childCount: photos.length + 1,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppConstants.spacing16,
                  crossAxisSpacing: AppConstants.spacing16,
                  childAspectRatio: 0.69,
                ),
              ),
            ),
          },
        ],
      ),
    );
  }

  void _navigateToSearchPage(BuildContext context) {
    Navigator.of(context).pushNamed(PhotoSearchPage.routePath);
  }

  void _navigateToFavoritesPage(BuildContext context) {
    Navigator.of(context).pushNamed(FavoritePhotosPage.routePath);
  }
}
