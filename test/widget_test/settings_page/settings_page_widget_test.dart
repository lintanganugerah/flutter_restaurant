import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/model/services/local_notification_services.dart';
import 'package:restaurant_flutter/model/services/setting_services.dart';
import 'package:restaurant_flutter/viewModel/settings_view_model.dart';
import 'package:restaurant_flutter/view/widgets/settings_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_flutter/view/settings_screen.dart';

import '../../mock_function.dart';

Widget settingsPage(SharedPreferences pref) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => SettingsViewModel(
          SettingsService(pref),
          LocalNotificationServices(),
        ),
      ),
    ],
    child: Consumer<SettingsViewModel>(
      builder: (context, viewModel, child) {
        final settingsViewModel = context.watch<SettingsViewModel>();
        final state = settingsViewModel.state;
        final isDarkMode = (state is SettingsStateLoaded)
            ? state.setting.isDarkMode
            : false;
        return MaterialApp(
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          theme: ThemeData.light(),
          home: const SettingsPage(),
        );
      },
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group("Settings Widgets Test", () {
    testWidgets("Page Settings should be displayed", (
      WidgetTester tester,
    ) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(settingsPage(prefs));
      await tester.pumpAndSettle();

      //Expect dalam page ada title Settings
      expect(
        find.textContaining("Settings"),
        findsOneWidget,
        reason:
            "Dalam page settings harus ada title mengenai page tersebut (Settings)",
      );

      //Expect dalam page ada reusable widget settings
      final findSettingsCard = find.byType(SettingsCard);
      expect(
        findSettingsCard,
        findsWidgets,
        reason: "Dalam page ada reusable widget settings",
      );
    });

    group("Dark Theme Switch", () {
      testWidgets("Dark Theme Switch should be displayed", (
        WidgetTester tester,
      ) async {
        final prefs = await SharedPreferences.getInstance();
        await tester.pumpWidget(settingsPage(prefs));
        await tester.pumpAndSettle();

        //Expect dalam page ada widget switch milik setting Dark Theme
        final darkThemeSwitch = find.byKey(Key("dark_theme_switch"));
        expect(
          darkThemeSwitch,
          findsOneWidget,
          reason: "Dark Theme Settings should be displayed",
        );
      });
      testWidgets("should change theme from light to dark when tapped", (
        WidgetTester tester,
      ) async {
        final prefs = await SharedPreferences.getInstance();
        await tester.pumpWidget(settingsPage(prefs));
        await tester.pumpAndSettle();

        // Cek bahwa tema awal adalah terang
        var materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(
          materialApp.themeMode,
          ThemeMode.light,
          reason: "Default theme adalah light",
        );

        // Cek bahwa switch dalam keadaan 'off'
        final switchWidget = tester.widget<Switch>(
          find.byKey(Key("dark_theme_switch")),
        );
        expect(
          switchWidget.value,
          isFalse,
          reason: "Default switch seharusnya dalam keadaan false atau off",
        );

        // Lakukan Tap Switch untuk mengubah theme
        final darkThemeSwitchFinder = find.byKey(Key("dark_theme_switch"));
        await tester.tap(darkThemeSwitchFinder);
        await tester.pumpAndSettle();

        // Cek bahwa tema di MaterialApp telah menjadi dark
        materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(
          materialApp.themeMode,
          ThemeMode.dark,
          reason: "Theme seharusnya akan menjadi dark ketika di tap",
        );

        // Cek bahwa nilainya sudah tersimpan di SharedPreferences mock
        expect(
          prefs.getBool('isDarkMode'),
          isTrue,
          reason: "SharedPreferences seharusnya menyimpan state data dark mode",
        );
      });
    });

    group("Daily Reminder Notification Switch", () {
      // Helper untuk membuat widget tree dengan ViewModel yang sudah di-mock.
      Widget createSettingsScreen(SettingsViewModel viewModel) {
        return ChangeNotifierProvider.value(
          value: viewModel,
          child: MaterialApp(home: const SettingsPage()),
        );
      }

      late SettingsViewModel viewModel;
      late MockSettingsService mockSettingsService;
      late MockLocalNotificationServices mockNotificationServices;

      setUp(() async {
        // Inisialisasi ulang semua komponen agar tes tidak saling mempengaruhi
        mockSettingsService = MockSettingsService();
        mockNotificationServices = MockLocalNotificationServices();
        viewModel = SettingsViewModel(
          mockSettingsService,
          mockNotificationServices,
        );
        // Tunggu constructor ViewModel selesai memuat state awal (loadSettings)
        await Future.delayed(Duration.zero);
      });

      testWidgets("Dark Theme Switch should be displayed", (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createSettingsScreen(viewModel));
        await tester.pumpAndSettle();

        //Expect dalam page ada widget switch milik setting Dark Theme
        final darkThemeSwitch = find.byKey(Key("daily_reminder_switch"));
        expect(
          darkThemeSwitch,
          findsOneWidget,
          reason: "daily_reminder_switch Settings should be displayed",
        );
      });
      testWidgets('should be displayed and OFF by default', (tester) async {
        await tester.pumpWidget(createSettingsScreen(viewModel));
        await tester.pumpAndSettle();

        final reminderSwitchFinder = find.byKey(
          const Key("daily_reminder_switch"),
        );
        expect(reminderSwitchFinder, findsOneWidget);

        final switchWidget = tester.widget<Switch>(reminderSwitchFinder);
        expect(switchWidget.value, isFalse);
      });

      testWidgets('should call toggleDailyReminder and turn ON when tapped', (
        tester,
      ) async {
        await tester.pumpWidget(createSettingsScreen(viewModel));
        await tester.pumpAndSettle();

        mockNotificationServices.permissionsGrantedResult = true;

        final reminderSwitchFinder = find.byKey(
          const Key("daily_reminder_switch"),
        );

        await tester.tap(reminderSwitchFinder);
        await tester.pumpAndSettle();

        final switchWidget = tester.widget<Switch>(reminderSwitchFinder);
        expect(switchWidget.value, isTrue);

        // Verifikasi bahwa metode di service notifikasi dipanggil
        expect(mockNotificationServices.scheduleCallCount, 1);
      });
    });
  });
}
