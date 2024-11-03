import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';

import '../core.dart';

class CloseFullPageButton extends StatelessWidget {
  const CloseFullPageButton({
    super.key,
    required this.color,
    this.onClose,
  });

  final Color color;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: AppConstants.spacing32,
      color: color,
      onPressed: () {
        if (onClose != null) onClose!();

        Navigator.pop(context);
      },
      icon: const Icon(CupertinoIcons.xmark_circle),
    );
  }
}
