import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_images_app/core/core.dart';

import '../../../features.dart';

class PhotoDetailPage extends ConsumerStatefulWidget {
  const PhotoDetailPage({
    super.key,
    required this.photoId,
  });
  final String photoId;

  static const routePath = 'photo-detail';

  @override
  ConsumerState<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends ConsumerState<PhotoDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  bool _isTitleShown = true;
  bool _hasTitleBeenToggled = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    unawaited(_automaticallyHideTitleAfterDelay());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _automaticallyHideTitleAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (!_isTitleShown) return;
    if (_hasTitleBeenToggled) return;

    _toggleTitleShown(false);
  }

  void _toggleTitleShown(bool isTitleShown) {
    setState(() => _isTitleShown = isTitleShown);
    if (_hasTitleBeenToggled) return;

    setState(() => _hasTitleBeenToggled = true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final photoAsyncValue = ref.watch(photoDetailsProvider(
      widget.photoId,
    ));

    return StatusBarWrapper(
      statusBarStyle: StatusBarStyle.light,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 0.0,
        ),
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: false,
          bottom: false,
          child: photoAsyncValue.when(
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            error: (error, stackTrace) => GenericError(
              errorText: error.toString(),
              onRetry: () {
                ref.invalidate(photoDetailsProvider(widget.photoId));
              },
            ),
            data: (photo) => SizedBox.expand(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                    onTap: () => _toggleTitleShown(!_isTitleShown),
                    child: SizedBox.expand(
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset.zero,
                          end: const Offset(-0.01, 0.01),
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Hero(
                          tag: photo.id,
                          child: FadingNetworkImage(
                            path: photo.regularPhotoUrl,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: kToolbarHeight * 2,
                        minWidth: size.width,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.75),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Spacer(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        decoration: _isTitleShown
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.70),
                                    Colors.black.withOpacity(0.20),
                                  ],
                                ),
                              )
                            : const BoxDecoration(),
                        padding: const EdgeInsets.only(
                          left: 26.0,
                          right: 26.0,
                          top: 33.0,
                          bottom: 49.0,
                        ),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: _isTitleShown ? 1.0 : 0.0,
                          child: GestureDetector(
                            onTap: !_isTitleShown
                                ? () => _toggleTitleShown(true)
                                : null,
                            child: AbsorbPointer(
                              absorbing: !_isTitleShown,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    photo.title,
                                    style: textTheme.displayMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 13.0),
                                  Text(
                                    '${photo.likes} likes',
                                    style: textTheme.titleMedium?.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  AppSpacingWidgets.verticalSpacing24,
                                  UserTileOnPhotoDetailPage(
                                    photoAuthor: photo.photoAuthor,
                                  ),
                                  AppSpacingWidgets.verticalSpacing24,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Positioned(
                    top: AppConstants.spacing24 + kToolbarHeight,
                    left: AppConstants.spacing24,
                    child: CloseFullPageButton(color: Colors.white),
                  ),
                  Positioned(
                    top: AppConstants.spacing24 + kToolbarHeight,
                    right: AppConstants.spacing24,
                    child: _PhotoDetailFavoriteButton(photo: photo),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoDetailFavoriteButton extends ConsumerWidget {
  const _PhotoDetailFavoriteButton({
    required this.photo,
    // ignore: unused_element
    super.key,
  });
  final PhotoModel photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoritePhoto = ref.watch(
      favoritePhotosProvider.select(
        (value) => value.favoritePhotoIds.contains(photo.id),
      ),
    );
    return IconButton(
      iconSize: AppConstants.spacing32,
      icon: Icon(
        isFavoritePhoto ? Icons.favorite : Icons.favorite_border,
        color: Colors.white,
      ),
      onPressed: () {
        _toggleAsFavorite(ref, context);
      },
    );
  }

  void _toggleAsFavorite(WidgetRef ref, BuildContext context) {
    FavoritePhotosHelpers.toggleFavoritePhoto(
      photo: photo,
      controller: ref.read(favoritePhotosProvider.notifier),
      context: context,
      favoritePhotos: ref.read(favoritePhotosProvider).favoritePhotos,
    );
  }
}
