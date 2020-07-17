import 'package:flutter/material.dart';

import 'package:flutter_bar_plugin/bar_settings.dart';
import 'package:flutter_bar_plugin/flutter_bar_plugin.dart';
import 'package:get_it/get_it.dart';

import 'date.dart';
import 'monitor_list.dart';
import 'position_list.dart';

final getIt = GetIt.instance;

void main() {
  main0();
}

void main0() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterBarPlugin.disableTopBar();
  await BarSettings().init();
  BarSettings().monitorName.value = BarSettings().monitors[0].name;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          widthFactor: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PositionListWidget(),
              Padding(padding: EdgeInsets.only(left: 10.0)),
              MonitorListWidget(),
              Padding(padding: EdgeInsets.only(left: 10.0)),
              DateWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
