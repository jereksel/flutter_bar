import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/bar_settings.dart';
import 'package:flutter_bar_plugin/monitor.dart';

class MonitorListWidget extends StatelessWidget {
  final List<Monitor> monitors = BarSettings().monitors;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: BarSettings().monitorName,
      builder: (BuildContext context, String monitorName, Widget child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (var monitor in monitors)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(monitor.name),
                  Radio(
                    value: monitor.name,
                    groupValue: monitorName,
                    onChanged: (value) {
                      BarSettings().monitorName.value = value;
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
