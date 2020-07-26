import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/text.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bar_plugin/streams.dart';

import 'simple_stream_builder.dart';

class DateWidget extends StatelessWidget {
  final String dateFormat;

  const DateWidget({Key key, this.dateFormat = "yyyy-MM-dd (EEE) HH:mm:ss"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final format = DateFormat(dateFormat);
    final dateStream =
        oneSecondTicker().map((event) => format.format(DateTime.now()));

    return SimpleStreamBuilder(
      stream: dateStream,
      builder: (String data) {
        return text("\uf64f $data");
      },
    );
  }
}
