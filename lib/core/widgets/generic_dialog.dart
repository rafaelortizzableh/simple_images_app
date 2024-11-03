import 'package:flutter/material.dart';

import '../core.dart';

class GenericDialog extends StatelessWidget {
  const GenericDialog({
    super.key,
    this.title,
    required this.content,
    this.rightButtonText,
    this.leftButtonText,
    this.leftButtonCallBack,
    this.rightButtonCallBack,
  });

  final String? title;
  final String content;

  /// If this is null,
  /// will be 'Okay' by default
  final String? rightButtonText;
  final String? leftButtonText;
  final VoidCallback? leftButtonCallBack;

  /// If this is null, this button will pop the dialog
  final VoidCallback? rightButtonCallBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final leftButtonText = this.leftButtonText;
    final title = this.title;
    final isLeftButtonVisible =
        leftButtonText != null && leftButtonCallBack != null;

    return AlertDialog(
      title: title != null
          ? Text(
              title,
              style: textTheme.headlineSmall,
            )
          : null,
      content: Text(
        content,
        style: textTheme.bodyLarge,
      ),
      actions: [
        if (isLeftButtonVisible) ...{
          TextButton(
            onPressed: leftButtonCallBack,
            child: Text(leftButtonText),
          ),
        } else ...{
          const SizedBox(),
        },
        TextButton(
          onPressed: rightButtonCallBack ?? () => Navigator.pop(context),
          child: Text(
            rightButtonText ?? 'Okay',
          ),
        ),
      ],
    );
  }
}

Future<bool> showConfirmationDialog({
  required BuildContext context,
  String? title,
  String? rightButtonText,
  String? leftButtonText,
  String? content,
}) async {
  final result = await showDialog(
    context: context,
    builder: (context) => GenericDialog(
      title: title,
      content: content ?? 'Are you sure?',
      leftButtonText: leftButtonText ?? 'Cancel',
      leftButtonCallBack: () {
        Navigator.of(context).pop(false);
      },
      rightButtonText: rightButtonText ?? 'Yes',
      rightButtonCallBack: () {
        Navigator.of(context).pop(true);
      },
    ),
  );

  return result == true;
}

Future<void> showInformationalDialog({
  required BuildContext context,
  required String title,
  required String content,
  VoidCallback? rightButtonCallBack,
}) async {
  await showDialog(
    context: context,
    builder: (context) => GenericDialog(
      title: title,
      content: content,
      rightButtonCallBack: rightButtonCallBack,
    ),
  );
}
