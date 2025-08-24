import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter/model/network/http_adapter.dart';
import 'package:restaurant_flutter/model/services/restaurant_services.dart';
import 'package:restaurant_flutter/type/network_client.dart';
import 'package:restaurant_flutter/view/home_screen.dart';
import 'package:restaurant_flutter/viewModel/restaurant_view_model.dart';
import 'package:http/http.dart' as http;

void main() {
  final INetworkClient httpClient = HttpAdapter(http.Client());
  final restaurantService = RestaurantServices(client: httpClient);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RestaurantViewModel(restaurantService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant API',
      theme: _buildTheme(),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      //Settings supaya ukuran font tetap sama meskipun settings system berbeda
      builder: (BuildContext context, child) {
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: TextScaler.linear(
              mediaQueryData.textScaler.scale(1).clamp(0.9, 1.2),
            ),
          ),
          child: child!,
        );
      },
      home: const Homescreen(),
    );
  }
}

const Color seedColor = Colors.teal;

ThemeData _buildTheme([Brightness brightness = Brightness.light]) {
  final scaffoldBg = brightness == Brightness.light
      ? Colors.white
      : const Color(0xFF121212);
  return ThemeData(
    scaffoldBackgroundColor: scaffoldBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    ),
    fontFamily: GoogleFonts.outfit().fontFamily,
    textTheme: TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
      titleMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      titleSmall: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
    ),
  );
}
