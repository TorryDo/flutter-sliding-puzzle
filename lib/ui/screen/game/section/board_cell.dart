import 'package:flutter/material.dart';

class BoardCell extends StatelessWidget {
  final String text;
  final Color overlayColor;
  final Color backgroundColor;
  final double fontSize;
  final double size;

  final Function onPressed;

  const BoardCell({
    super.key,
    required this.text,
    required this.overlayColor,
    required this.backgroundColor,
    required this.fontSize,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = size < 150;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(isCompact ? 4.0 : 8.0)),
    );

    var color = Theme.of(context).cardColor;
    color = Color.alphaBlend(backgroundColor, color);
    color = Color.alphaBlend(overlayColor, color);

    return Semantics(
      label: "",
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 2.0 : 4.0),
        child: Material(
          shape: shape,
          color: color,
          elevation: 2,
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: () => onPressed(),
            customBorder: shape,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
