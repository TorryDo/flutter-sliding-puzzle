import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/config/ui.dart';
import 'package:slide_puzzle/data/result.dart';
import 'package:slide_puzzle/ui/screen/game/game_screen_presenter.dart';
import 'package:slide_puzzle/ui/screen/game/game_screen.dart';
import 'package:slide_puzzle/ui/screen/game/section/victory.dart';
import 'package:slide_puzzle/ui/screen/theme_provider.dart';

import 'config/app_themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      Provider<ThemeProvider>(create: (_) {
        final d = ThemeProvider();
        d.init();
        return d;
      }),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ui = ConfigUiContainer.of(context);

    // final themeProvider = context.provider<ThemeProvider>();
    // themeProvider.readTheme();

    const title = "Sliding puzzle";

    bool useDarkTheme;
    if (true) {
      var platformBrightness = MediaQuery.of(context).platformBrightness;
      useDarkTheme = platformBrightness == Brightness.dark;
    } else {
      useDarkTheme = ui.useDarkTheme!;
    }
    transparentStatusBar(useDarkTheme);

    return MaterialApp(
      title: title,
      darkTheme: AppThemes.darkTheme,
      theme: AppThemes.lightTheme,
      home: Builder(
        builder: (context) {
          return GameScreenPresenter(
            child: GameScreen(),
            onSolve: (Result result) {
              showDialog(
                context: context,
                builder: (context) => GameVictoryDialog(result: result),
              );
            },
          );
        },
      ),
    );
  }

  void transparentStatusBar(bool useDarkTheme) {
    final overlay =
        useDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
    SystemChrome.setSystemUIOverlayStyle(
      overlay.copyWith(statusBarColor: Colors.transparent),
    );
  }
}
