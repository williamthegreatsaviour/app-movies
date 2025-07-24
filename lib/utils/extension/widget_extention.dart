import 'package:flutter/material.dart';

extension WidgetPaddingX on Widget {
  // Padding with directional support (for RTL and LTR languages)
  Widget paddingDirectional({
    double start = 0.0,
    double top = 0.0,
    double end = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
        padding: EdgeInsetsDirectional.only(
          start: start,
          top: top,
          end: end,
          bottom: bottom,
        ),
        child: this,
      );
}
