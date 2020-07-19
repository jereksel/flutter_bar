import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/X11.dart';

class DesktopNamesWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: prepareDesktopNamesListener(),
      builder: (BuildContext context, AsyncSnapshot<Stream<List<String>>> snapshot) {
        if (!snapshot.hasData) {
          return Text("Waiting for current desktops");
        }

        return StreamBuilder(
          stream: snapshot.data,
          builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (!snapshot.hasData) {
              return Text("Waiting for current desktops");
            }
            return Text("Current desktop id: ${snapshot.data}");
          },
        );

      },
    );

  }

}