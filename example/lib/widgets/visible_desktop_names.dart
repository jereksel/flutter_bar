import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/X11.dart';

class VisibleDesktopNamesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: getVisibleDesktops(),
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text("ERROR: ${snapshot.error}");
        }
        if (!snapshot.hasData) {
          return Text("Waiting for visible desktops");
        }
        return Text("Current desktop id: ${snapshot.data}");
      },
    );
  }
}
