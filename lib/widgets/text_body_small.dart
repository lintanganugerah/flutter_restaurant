import 'package:flutter/material.dart';

class TextBodySmall extends StatelessWidget {
  const TextBodySmall({super.key, required this.text, this.maxLines = 2});

  final int maxLines;
  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
