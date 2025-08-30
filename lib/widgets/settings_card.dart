import 'package:flutter/material.dart';
import 'package:restaurant_flutter/widgets/text_body_small.dart';
import 'package:restaurant_flutter/widgets/title_medium.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget widget;

  const SettingsCard({
    super.key,
    required this.title,
    required this.description,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleMedium(text: title),
              TextBodySmall(text: description, fontSize: 12),
            ],
          ),
        ),
        widget,
      ],
    );
  }
}
