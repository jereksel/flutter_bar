import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/bar_settings.dart';
import 'package:flutter_bar_plugin/simple_stream_builder.dart';

Widget text(String data, {TextStyle style, TextOverflow overflow}) {
  return ClipRect(
    child: SimpleStreamBuilder(
      stream: BarSettings().fontSize,
      builder: (int fontSize) {
        final TextStyle _style =
            (style ?? TextStyle()).copyWith(fontSize: fontSize.toDouble());

        return Text(
          data,
          style: _style,
          maxLines: 1,
          overflow: overflow,
        );
      },
    ),
  );
}
