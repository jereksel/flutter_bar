import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/monitor.dart';
import 'package:flutter_bar_plugin/position.dart';
import 'package:flutter_bar_plugin/simple_stream_builder.dart';

import 'bar_settings.dart';
import 'flutter_bar_plugin.dart';

void start(Widget widget,
    {int barSize = 16,
    MonitorPredicate monitorPredicate,
    Position barPosition = Position.BOTTOM,
    String font = "Roboto",
    int fontSize = 14}) async {
  final _monitorPredicate = monitorPredicate ?? primary();

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterBarPlugin.disableTopBar();

  final barSettings = BarSettings();

  barSettings.setBarSize(barSize);
  barSettings.setMonitorPredicate(_monitorPredicate);
  barSettings.setBarPosition(barPosition);
  barSettings.setBarFont(font);
  barSettings.setFontSize(fontSize);

  runApp(_MainWidget(widget));
}

class _MainWidget extends StatelessWidget {
  final Widget _widget;

  _MainWidget(this._widget);

  @override
  Widget build(BuildContext context) {
    return SimpleStreamBuilder(
      stream: BarSettings().barFont,
      builder: (String fontFamily) {
        return MaterialApp(
          theme: ThemeData(fontFamily: fontFamily),
          home: Scaffold(
            backgroundColor: Colors.black,
            body: _widget,
          ),
        );
      },
    );
  }
}
