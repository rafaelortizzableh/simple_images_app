import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core.dart';

class FadingNetworkImage extends StatelessWidget {
  const FadingNetworkImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.animationDuration = const Duration(seconds: 1),
  });

  final String path;
  final Duration animationDuration;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: path,
      fit: fit,
      fadeInCurve: Curves.easeOut,
      fadeOutCurve: Curves.easeOut,
      fadeInDuration: animationDuration,
      fadeOutDuration: animationDuration,
      errorWidget: (context, url, error) {
        return AppSpacingWidgets.emptySpace;
      },
    );
  }
}
