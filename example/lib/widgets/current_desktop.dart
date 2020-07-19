import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/X11.dart';

class CurrentDesktopWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: prepareCurrentDesktopListener(),
      builder: (BuildContext context, AsyncSnapshot<Stream<int>> snapshot) {
        if (!snapshot.hasData) {
          return Text("Waiting for current desktops");
        }

        return StreamBuilder(
          stream: snapshot.data,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
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