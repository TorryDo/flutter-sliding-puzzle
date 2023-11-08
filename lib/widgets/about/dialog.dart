import 'package:slide_puzzle/links.dart';
import 'package:slide_puzzle/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutDialog extends StatelessWidget {
  const AboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 24);

    Padding HorizontalPadding(Widget child) {
      return Padding(
        padding: padding,
        child: child,
      );
    }

    return SimpleDialog(
      title: const Text('About'),
      children: <Widget>[
        HorizontalPadding(
            const Text('Game of Fifteen is a free and open source app '
                'written with Flutter. It features beautiful design and '
                'smooth animations.')),
        const SizedBox(height: 8),
        HorizontalPadding(
            const Text('You can compete with your friends online. '
                'The complexity of puzzles is similar from game to game.')),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.code, size: 24),
          contentPadding: padding,
          title: const Text('Join development'),
          onTap: () {
            launchUrl(url: URL_REPOSITORY);
          },
        ),
        ListTile(
          leading: const Icon(Icons.bug_report, size: 24),
          contentPadding: padding,
          title: const Text('Send bug report'),
          onTap: () {
            launchUrl(url: URL_FEEDBACK);
          },
        ),
        const SizedBox(height: 24),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
            String text;
            if (snapshot.data != null) {
              final buildVersion = snapshot.data?.version ?? 'version null';
              final buildNumber = snapshot.data?.buildNumber ?? 'buildNumber null';
              text = 'Game of Fifteen v' + buildVersion + "-" + buildNumber;
            } else {
              text = 'Game of Fifteen, web version';
            }
            return HorizontalPadding(
              Semantics(
                label: "App version",
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
