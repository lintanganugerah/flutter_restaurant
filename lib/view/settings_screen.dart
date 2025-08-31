import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/viewModel/settings_view_model.dart';
import 'package:restaurant_flutter/view/widgets/settings_card.dart';
import 'package:restaurant_flutter/view/widgets/text_body_small.dart';
import 'package:restaurant_flutter/view/widgets/title_medium.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TitleMedium(text: "Settings", fontSize: 24),
              SizedBox(height: 24),
              Consumer<SettingsViewModel>(
                builder: (context, viewmodel, child) {
                  switch (viewmodel.state) {
                    case SettingsStateLoading():
                      return Center(child: CircularProgressIndicator());

                    case SettingsStateError(message: final message):
                      return Center(child: TextBodySmall(text: message));

                    case SettingsStateLoaded(setting: final setting):
                      return SettingsCard(
                        title: "Dark Theme",
                        description: "Change App Theme to Dark",
                        widget: Switch(
                          value: setting.isDarkMode,
                          onChanged: (bool newVal) {
                            context.read<SettingsViewModel>().toggleDarkMode(
                              newVal,
                            );
                          },
                          key: Key("dark_theme_switch"),
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
