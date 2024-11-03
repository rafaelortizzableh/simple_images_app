import 'package:flutter/material.dart';

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
  /// will be context.l10n.okay
  final String? rightButtonText;
  final String? leftButtonText;
  final VoidCallback? leftButtonCallBack;

  /// If this is null, this button will pop the dialog
  final VoidCallback? rightButtonCallBack;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : const SizedBox(),
      content: Text(content),
      actions: [
        leftButtonText != null && leftButtonCallBack != null
            ? TextButton(
                onPressed: leftButtonCallBack,
                child: Text(leftButtonText!),
              )
            : const SizedBox(),
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
  String? rightButtonText,
  String? leftButtonText,
  String? content,
}) async {
  final result = await showDialog(
    context: context,
    builder: (context) => GenericDialog(
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
