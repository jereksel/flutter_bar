import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/X11.dart';

class DesktopNamesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: prepareDesktopNamesListener(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text("ERROR: ${snapshot.error}");
        }
        if (!snapshot.hasData) {
          return Text("Waiting for current desktops");
        }
        return Text("Current desktop id: ${snapshot.data}");
      },
    );
  }
}
