import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slide_puzzle/config/ui.dart';
import 'package:slide_puzzle/utils/platform.dart';
import 'package:slide_puzzle/widgets/game/page.dart';

void main() {
  // For play billing library 2.0 on Android, it is mandatory to call
  // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
  // as part of initializing the app.
  // InAppPurchaseConnection.enablePendingPurchases();
  _setTargetPlatformForDesktop();
  runApp(
      // PlayGamesContainer(
      //   child: ConfigUiContainer(
      //     child: MyApp(),
      //   ),
      // ),
      const MyApp());
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform? targetPlatform;
  if (platformCheck(() => Platform.isMacOS)) {
    targetPlatform = TargetPlatform.iOS;
  } else if (platformCheck(() => Platform.isLinux || Platform.isWindows)) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Sliding Puzzle';
    return _MyMaterialApp(title: title);
  }
}

/// Base class for all platforms, such as
/// [Platform.isIOS] or [Platform.isAndroid].
abstract class _MyPlatformApp extends StatelessWidget {
  final String title;

  const _MyPlatformApp({required this.title});
}

class _MyMaterialApp extends _MyPlatformApp {
  const _MyMaterialApp({
    required String title,
  }) : super(title: title);

  @override
  Widget build(BuildContext context) {
    final ui = ConfigUiContainer.of(context);

    ThemeData applyDecor(ThemeData theme) => theme.copyWith(
          primaryColor: Colors.blue,
          // accentColor: Colors.amberAccent,
          // accentIconTheme: theme.iconTheme.copyWith(color: Colors.black),
          dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
          textTheme: theme.textTheme.apply(fontFamily: 'ManRope'),
          primaryTextTheme: theme.primaryTextTheme.apply(fontFamily: 'ManRope'),
          // accentTextTheme: theme.accentTextTheme.apply(fontFamily: 'ManRope'),
        );

    final baseDarkTheme = applyDecor(ThemeData(
      brightness: Brightness.dark,
      canvasColor: const Color(0xFF121212),
      backgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
    ));
    final baseLightTheme = applyDecor(ThemeData.light());

    ThemeData darkTheme;
    ThemeData lightTheme;
    if (ui.useDarkTheme == null) {
      // auto
      darkTheme = baseDarkTheme;
      lightTheme = baseLightTheme;
    } else if (ui.useDarkTheme == true) {
      // dark
      darkTheme = baseDarkTheme;
      lightTheme = baseDarkTheme;
    } else {
      // light
      darkTheme = baseLightTheme;
      lightTheme = baseLightTheme;
    }

    return MaterialApp(
      title: title,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: Builder(
        builder: (context) {
          bool useDarkTheme;
          if (ui.useDarkTheme == null) {
            var platformBrightness = MediaQuery.of(context).platformBrightness;
            useDarkTheme = platformBrightness == Brightness.dark;
          } else {
            useDarkTheme = ui.useDarkTheme;
          }
          final overlay = useDarkTheme
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark;
          SystemChrome.setSystemUIOverlayStyle(
            overlay.copyWith(
              statusBarColor: Colors.transparent,
            ),
          );
          return GamePage();
        },
      ),
    );
  }
}
