import 'package:flutter/material.dart';

class TextBodySmall extends StatelessWidget {
  const TextBodySmall({
    super.key,
    required this.text,
    this.maxLines = 2,
    this.fontSize,
  });

  final int maxLines;
  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
        fontSize: fontSize,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
