import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_images_app/core/core.dart';

import '../../../features.dart';

class PhotoItem extends StatelessWidget {
  const PhotoItem({
    super.key,
    required this.isRightSide,
    required this.photo,
    required this.isFavoritePhoto,
    required this.onFavoritePressed,
  });

  final bool isRightSide;
  final PhotoModel photo;
  final bool isFavoritePhoto;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final animationDuration =
        !isRightSide ? const Duration(seconds: 2) : const Duration(seconds: 1);

    return Padding(
      padding: EdgeInsets.only(
        top: isRightSide ? AppConstants.spacing8 : 0,
        bottom: isRightSide ? 0 : AppConstants.spacing8,
      ),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact().ignore();
          Navigator.of(context).pushNamed(
            PhotoDetailPage.routePath,
            arguments: photo.id,
          );
        },
        child: Card(
          elevation: isRightSide ? 3 : 2,
          shape: const RoundedRectangleBorder(
            borderRadius: AppConstants.borderRadius12,
          ),
          borderOnForeground: false,
          shadowColor: theme.brightness == Brightness.light
              ? theme.foregroundColor.withOpacity(0.5)
              : theme.scaffoldBackgroundColor.withOpacity(0.5),
          color: Colors.transparent.withOpacity(0),
          margin: const EdgeInsets.all(0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: AppConstants.borderRadius12,
                child: Hero(
                  tag: photo.id,
                  child: AspectRatio(
                    aspectRatio: 0.69,
                    child: FadingNetworkImage(
                      path: photo.regularPhotoUrl,
                      animationDuration: animationDuration,
                    ),
                  ),
                ),
              ),
              _FadeAndTitleOnImageTile(
                animationDuration: animationDuration,
                photo: photo,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: SizedBox.square(
                  dimension: AppConstants.spacing32,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        isFavoritePhoto
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      iconSize: AppConstants.spacing16,
                      onPressed: onFavoritePressed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FadeAndTitleOnImageTile extends StatefulWidget {
  const _FadeAndTitleOnImageTile({
    // ignore: unused_element
    super.key,
    required this.photo,
    required this.animationDuration,
  });
  final PhotoModel photo;
  final Duration animationDuration;

  @override
  State<_FadeAndTitleOnImageTile> createState() =>
      _FadeAndTitleOnImageTileState();
}

class _FadeAndTitleOnImageTileState extends State<_FadeAndTitleOnImageTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: widget.animationDuration)
          ..forward()
          ..addListener(_updatePosition);
    super.initState();
  }

  void _updatePosition() {
    setState(() => opacity = 1.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AnimatedOpacity(
      duration: _animationController.duration ?? widget.animationDuration,
      opacity: opacity,
      child: AspectRatio(
        aspectRatio: 0.69,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppConstants.borderRadius12,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.70),
                  Colors.black.withOpacity(0.0),
                ],
              ),
            ),
            child: Padding(
              padding: AppConstants.padding12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.photo.title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${widget.photo.likes} likes',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w200,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    maxLines: 1,
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
