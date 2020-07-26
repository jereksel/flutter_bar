import 'package:flutter/cupertino.dart';
import 'package:flutter_bar_plugin/text.dart';

Widget createPowerline(List<Widget> widgets, List<Color> colors) {
  assert(widgets.length == colors.length);

  final length = widgets.length;

  final finalWidgets = <Widget>[];

  final powerlineGlyph = '\uE0B0';

  for (int i = 0; i < length - 1; i++) {
    finalWidgets.addAll([
      Container(
        child: widgets[i],
        color: colors[i],
      ),
      Container(
        color: colors[i + 1],
        child: text(
          powerlineGlyph,
          style: TextStyle(
            color: colors[i],
          ),
        ),
      ),
    ]);
  }

  //Last container does not end with powerline glyph
  for (int i = length - 1; i < length; i++) {
    finalWidgets.addAll([
      Container(
        child: widgets[i],
        color: colors[i],
      ),
    ]);
  }

  return Row(children: finalWidgets);
}
