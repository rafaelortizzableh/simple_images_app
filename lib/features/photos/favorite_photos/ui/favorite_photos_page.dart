import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class FavoritePhotosPage extends ConsumerWidget {
  const FavoritePhotosPage({super.key});

  static const routePath = '/favorite-photos';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favoritePhotos = ref.watch(
      favoritePhotosProvider.select((value) => value.favoritePhotos),
    );
    final areThereFavoritePhotos = favoritePhotos.isNotEmpty;

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
              'Favorite Photos',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.foregroundColor,
              ),
            ),
          ),
          if (areThereFavoritePhotos) ...{
            SliverPadding(
              padding: const EdgeInsets.only(
                top: AppConstants.spacing32,
                right: AppConstants.spacing16,
                left: AppConstants.spacing16,
                bottom: AppConstants.spacing32,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final photo = favoritePhotos[index];

                    final isRightSide = index % 2 != 0;

                    return PhotoItem(
                      photo: photo,
                      isRightSide: isRightSide,
                      onFavoritePressed: () =>
                          FavoritePhotosHelpers.toggleFavoritePhoto(
                        context: context,
                        photo: photo,
                        controller: ref.read(favoritePhotosProvider.notifier),
                        favoritePhotos: favoritePhotos,
                      ),
                      isFavoritePhoto: true,
                    );
                  },
                  childCount: favoritePhotos.length,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 0.69,
                  mainAxisSpacing: AppConstants.spacing8,
                  crossAxisSpacing: AppConstants.spacing8,
                ),
              ),
            ),
          } else ...{
            const _NoPhotosYet(),
          },
        ],
      ),
    );
  }
}

class _NoPhotosYet extends StatelessWidget {
  const _NoPhotosYet({
    // ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          AppSpacingWidgets.verticalSpacing12,
          const Text('No favorite photos yet'),
          AppSpacingWidgets.verticalSpacing12,
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                PhotosPage.routePath,
                (route) => false,
              );
            },
            child: const Text('Go to Photos'),
          ),
        ],
      ),
    );
  }
}
