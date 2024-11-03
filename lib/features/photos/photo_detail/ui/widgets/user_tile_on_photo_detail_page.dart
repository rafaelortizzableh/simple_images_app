import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

class UserTileOnPhotoDetailPage extends StatelessWidget {
  const UserTileOnPhotoDetailPage({
    super.key,
    required this.photoAuthor,
  });
  final PhotoAuthor photoAuthor;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox.square(
          dimension: 40.0,
          child: Hero(
            tag: photoAuthor.username,
            child: CircleAvatar(
              foregroundImage: NetworkImage(
                photoAuthor.profilePicUrl ?? '',
              ),
              radius: 40.0,
            ),
          ),
        ),
        AppSpacingWidgets.horizontalSpacing8,
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                photoAuthor.name ?? photoAuthor.username,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
