enum Routes {
  splash,
  about,
  game,
  setting
}

class _Paths {
  static const String splash = '/';
  static const String about = '/about';
  static const String game = '/game';
  static const String setting = '/setting';

  static const Map<Routes, String> _pathMap = {
    Routes.splash: _Paths.splash,
    Routes.about: _Paths.about,
    Routes.game: _Paths.game,
    Routes.setting: _Paths.setting
  };

  static String of(Routes route) => _pathMap[route] ?? splash;

}

