import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bar_plugin/streams.dart';

class DateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd (EEE) HH:mm:ss.SSS");
    final dateStream =
        oneSecondTicker().map((event) => format.format(DateTime.now()));

    return StreamBuilder(
      stream: dateStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return const Text("");
        }
        return Text(snapshot.data);
      },
    );
  }
}
