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
        SizedBox(
          height: 37.0,
          width: 37.0,
          child: Hero(
            tag: photoAuthor.username,
            child: CircleAvatar(
              foregroundImage: NetworkImage(
                photoAuthor.profilePicUrl ?? '',
              ),
              radius: 37.0,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        SizedBox(
          height: 37.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                photoAuthor.name ?? photoAuthor.username,
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                'View Profile',
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w300,
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
