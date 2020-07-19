import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/X11.dart';
import 'package:flutter_bar_plugin_example/widgets/simple_stream_builder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

@immutable
class _DesktopStatus {
  final List<String> desktopNames;
  final int currentDesktop;
  final List<int> visibleDesktops;

  _DesktopStatus(this.desktopNames, this.currentDesktop, this.visibleDesktops);
}

class WorkspaceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stream = Rx.combineLatest4(
        prepareDesktopNamesListener(),
        prepareCurrentDesktopListener(),
        getVisibleDesktops(),
        getNumberOfDesktops(),
        (a, b, c, d) =>
            new Tuple4<List<String>, int, List<int>, int>(a, b, c, d)).map(
        (event) => _DesktopStatus(
            event.item1.take(event.item4).toList(), event.item2, event.item3));

    return SimpleStreamBuilder(
      stream: stream,
      builder: (_DesktopStatus data) {

        final allDesktops = data.desktopNames;
        final widgets = <Widget>[];

        for (final visibleDesktop in data.visibleDesktops) {
          TextStyle textStyle = TextStyle();
          if (data.currentDesktop == visibleDesktop) {
            textStyle = TextStyle(color: Colors.red);
          }

          widgets.add(Text("[${allDesktops[visibleDesktop]}]", style: textStyle));

        }

        return Row(children: widgets);

      },
    );
  }
}
