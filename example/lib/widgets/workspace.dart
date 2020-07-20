import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/X11.dart';
import 'package:flutter_bar_plugin/X11Properties.dart';
import 'package:flutter_bar_plugin_example/widgets/simple_stream_builder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

@immutable
class _DesktopStatus {
  final List<String> desktopNames;
  final int currentDesktop;
  final List<int> visibleDesktops;
  final List<int> desktopsWithWindows;

  _DesktopStatus(this.desktopNames, this.currentDesktop, this.visibleDesktops,
      this.desktopsWithWindows);
}

class WorkspaceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workspacesWithWindowsStream =
        Stream.periodic(Duration(milliseconds: 250))
            .map((event) => getWorkspacesWithWindows());

    final allWorkspaces = Rx.combineLatest2(prepareDesktopNamesListener(),
        getNumberOfDesktops(), (a, b) => a.take(b).toList());

    final currentDesktop = prepareCurrentDesktopListener();

    final visibleDesktops = getVisibleDesktops();

    final combined = Rx.combineLatest4(
        allWorkspaces,
        currentDesktop,
        visibleDesktops,
        workspacesWithWindowsStream,
        (a, b, c, d) => _DesktopStatus(a, b, c, d));

    return SimpleStreamBuilder(
      stream: combined,
      builder: (_DesktopStatus data) {
        final allDesktops = data.desktopNames;
        final widgets = <Widget>[];

        for (final visibleDesktop in data.visibleDesktops) {
          TextStyle textStyle = TextStyle();
          if (data.currentDesktop == visibleDesktop) {
            textStyle = TextStyle(color: Colors.red);
          }

          widgets
              .add(Text("[${allDesktops[visibleDesktop]}]", style: textStyle));
        }

        for (int i = 0; i < data.desktopNames.length; i++) {
          if (data.visibleDesktops.contains(i)) continue;
          if (!data.desktopsWithWindows.contains(i)) continue;

          widgets.add(Text("${allDesktops[i]}"));

        }

        return Row(children: widgets);
      },
    );
  }
}
