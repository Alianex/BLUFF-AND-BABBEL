import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/game_state.dart';
import 'providers/theme_provider.dart';
import 'screens/game_screen.dart';
import 'services/game_service.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const BluffAndBabelApp());
}

class BluffAndBabelApp extends StatelessWidget {
  const BluffAndBabelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(ThemeService()),
        ),
        ChangeNotifierProvider(
          create: (_) => GameState(GameService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bluff & Babel',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        home: const GameScreen(),
      ),
    );
  }
}
