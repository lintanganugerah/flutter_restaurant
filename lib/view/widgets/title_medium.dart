import 'package:flutter/material.dart';

class TitleMedium extends StatelessWidget {
  const TitleMedium({
    super.key,
    required this.text,
    this.maxLines = 2,
    this.fontWeight = FontWeight.bold,
    this.fontSize,
  });

  final int maxLines;
  final String text;
  final FontWeight fontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
