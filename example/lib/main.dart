import 'package:flutter/material.dart';
import 'package:flutter_bar_plugin/powerline.dart';

import 'package:flutter_bar_plugin/bar.dart';

import 'widgets/current_layout.dart';
import 'widgets/current_window.dart';
import 'widgets/date.dart';
import 'widgets/mem_info.dart';
import 'widgets/workspace_powerline.dart';

void main() {
  start(
    MyApp(),
    barSize: 20,
    fontSize: 14,
    font: "Hack Nerd Font",
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var widgets = [
      DateWidget(),
      MemInfoWidget(),
      CurrentLayoutWidget(),
      CurrentWindowWidget(),
      SizedBox.shrink(),
    ];

    final colors = [
      Colors.yellow.shade900,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.redAccent,
      Colors.transparent,
    ];

    final powerline = createPowerline(widgets, colors);

    return Row(
      children: [
        WorkspacePowerlineWidget(nextColor: colors.first),
        powerline,
      ],
    );

  }
}
