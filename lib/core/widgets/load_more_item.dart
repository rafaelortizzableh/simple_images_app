import 'package:flutter/material.dart';

class LoadMoreItem extends StatefulWidget {
  const LoadMoreItem({
    required this.onShow,
    required super.key,
  });

  final VoidCallback? onShow;

  @override
  State<LoadMoreItem> createState() => _LoadMoreItemState();
}

class _LoadMoreItemState extends State<LoadMoreItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(Duration.zero, () => widget.onShow?.call()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox.square(
          dimension: 60,
          child: CircularProgressIndicator.adaptive(),
        ),
      ],
    );
  }
}
