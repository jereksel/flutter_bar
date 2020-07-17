import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/bar_settings.dart';
import 'package:flutter_bar_plugin/position.dart';

class PositionListWidget extends StatelessWidget {
  final Map<Position, String> _positionNames = LinkedHashMap.fromIterables(
      [Position.TOP, Position.BOTTOM], ["Top", "Bottom"]);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: BarSettings().barPosition,
      builder: (BuildContext context, Position currentPosition, Widget child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (var item in _positionNames.entries)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.value),
                  Radio(
                    value: item.key,
                    groupValue: currentPosition,
                    onChanged: (value) {
                      BarSettings().barPosition.value = value;
                    },
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
