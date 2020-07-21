import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bar_plugin/bar_settings.dart';
import 'package:flutter_bar_plugin/flutter_bar_plugin.dart';
import 'package:get_it/get_it.dart';

import 'widgets/date.dart';
import 'widgets/mem_info.dart';
import 'widgets/monitor_list.dart';
import 'widgets/position_list.dart';
import 'widgets/workspace.dart';

final getIt = GetIt.instance;

void main() {
  main0(monitorName: "DP-1");
}

void main0({@required String monitorName}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterBarPlugin.disableTopBar();
  await BarSettings().init();
  BarSettings().monitorName.value = monitorName;

  final fontLocation =
      "/home/andrzej/.local/share/fonts/Hack Nerd Font Regular Mono.ttf";
  final f = new File(fontLocation)
      .readAsBytes()
      .then((value) => ByteData.view(value.buffer));
  final fl = FontLoader("abc");
  fl.addFont(f);
  await fl.load();

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
              Padding(padding: EdgeInsets.only(left: 16.0)),
              MonitorListWidget(),
              Padding(padding: EdgeInsets.only(left: 16.0)),
              DateWidget(),
              Padding(padding: EdgeInsets.only(left: 16.0)),
              MemInfoWidget(),
              Container(width: 32, color: Colors.red),
              Text('\uE0B0',
                  style: TextStyle(
                      backgroundColor: Colors.blue,
                      fontSize: 86.0,
                      color: Colors.red,
                      fontFamily: "abc")),
              WorkspaceWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
