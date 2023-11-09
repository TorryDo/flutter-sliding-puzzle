import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slide_puzzle/config/ui.dart';
import 'package:slide_puzzle/ui/screen/game/game_presenter.dart';
import 'package:slide_puzzle/ui/screen/game/section/board.dart';
import 'package:slide_puzzle/ui/screen/game/section/play_stop_button.dart';
import 'package:slide_puzzle/ui/screen/game/section/stopwatch.dart';

class GameScreen extends StatelessWidget {
  /// Maximum size of the board,
  /// in pixels.
  static const kMaxBoardSize = 400.0;
  static const kBoardMargin = 16.0;
  static const kBoardPadding = 4.0;

  final FocusNode _boardFocus = FocusNode();

  GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = GamePresenterWidget.of(context);

    final screenSize = MediaQuery.of(context).size;
    final screenWidth =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? screenSize.width
            : screenSize.height;
    final screenHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? screenSize.height
            : screenSize.width;

    final isTallScreen = screenHeight > 800 || screenHeight / screenWidth > 1.9;
    final isLargeScreen = screenWidth > 400;

    final fabWidget = _buildFab(context);
    final boardWidget = _buildBoard(context);
    return OrientationBuilder(builder: (context, orientation) {
      final statusWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GameStopwatchWidget(
            time: presenter.time,
            fontSize: orientation == Orientation.landscape && !isLargeScreen
                ? 50.0
                : 65.0,
          ),
          Text(
            '${presenter.steps ?? -1} steps',
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );

      if (orientation == Orientation.portrait) {
        //
        // Portrait layout
        //
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isTallScreen
                    ? SizedBox(
                        height: 50,
                        child: Center(
                            child: Text(
                          'Sliding Puzzle',
                          style: Theme.of(context).textTheme.labelLarge,
                        )),
                      )
                    : const SizedBox(height: 0),
                const SizedBox(height: 16.0),
                Center(child: statusWidget),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: boardWidget,
                  ),
                ),
                isLargeScreen && isTallScreen
                    ? const SizedBox(height: 116)
                    : const SizedBox(height: 72),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: fabWidget,
        );
      } else {
        //
        // Landscape layout
        //
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: <Widget>[
                Expanded(flex: 3, child: boardWidget),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      statusWidget,
                      const SizedBox(height: 48.0),
                      fabWidget,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _buildBoard(final BuildContext context) {
    final presenter = GamePresenterWidget.of(context);
    final config = ConfigUiContainer.of(context);
    final background = Theme.of(context).brightness == Brightness.dark
        ? Colors.black54
        : Colors.black12;

    const borderRadius = 14.0;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(kBoardMargin),
        padding: const EdgeInsets.all(kBoardPadding),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final puzzleSize = min(
              min(constraints.maxWidth, constraints.maxHeight),
              kMaxBoardSize - (kBoardMargin + kBoardPadding) * 2,
            );

            return RawKeyboardListener(
              autofocus: true,
              focusNode: _boardFocus,
              onKey: (event) {
                if (event is! RawKeyDownEvent) {
                  return;
                }

                int offsetY = 0;
                int offsetX = 0;
                switch (event.logicalKey.keyId) {
                  case 0x100070052: // arrow up
                    offsetY = 1;
                    break;
                  case 0x100070050: // arrow left
                    offsetX = 1;
                    break;
                  case 0x10007004f: // arrow right
                    offsetX = -1;
                    break;
                  case 0x100070051: // arrow down
                    offsetY = -1;
                    break;
                  default:
                    return;
                }
                final tapPoint =
                    presenter.board!.blank + Point(offsetX, offsetY);
                if (tapPoint.x < 0 ||
                    tapPoint.x >= presenter.board!.size ||
                    tapPoint.y < 0 ||
                    tapPoint.y >= presenter.board!.size) {
                  return;
                }

                presenter.tap(point: tapPoint);
              },
              child: BoardWidget(
                isSpeedRunModeEnabled: config.isSpeedRunModeEnabled,
                board: presenter.board,
                size: puzzleSize,
                onTap: (point) {
                  presenter.tap(point: point);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFab(final BuildContext context) {
    final presenter = GamePresenterWidget.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 48,
          height: 48,
          child: Material(
            elevation: 0.0,
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                presenter.reset();
              },
              customBorder: const CircleBorder(),
              child: const Icon(
                Icons.refresh,
                semanticLabel: "Reset",
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        PlayStopButton(
          isPlaying: presenter.isPlaying(),
          onTap: () => presenter.playStop(),
        ),
        const SizedBox(width: 16.0),
        SizedBox(
          width: 48,
          height: 48,
          child: Material(
            elevation: 0.0,
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                // Show the modal bottom sheet on
                // tap on "More" icon.
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return _bottomSheet(presenter);
                  },
                );
              },
              customBorder: const CircleBorder(),
              child: const Icon(
                Icons.more_vert,
                semanticLabel: "Settings",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomSheet(GamePresenterWidgetState presenter) {
    return Container(
      height: 300,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  presenter.resize(3);
                },
                child: const Text('3x3'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  presenter.resize(4);
                },
                child: const Text('4x4'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  presenter.resize(5);
                },
                child: const Text('5x5'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Switch Theme'),
          )
        ],
      ),
    );
  }
}
