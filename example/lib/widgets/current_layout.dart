import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/X11.dart';
import 'package:flutter_bar_plugin/text.dart';
import 'package:flutter_bar_plugin_example/widgets/simple_stream_builder.dart';

class CurrentLayoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleStreamBuilder(
      stream: prepareLayoutNamesListener(),
      builder: (String data) {
        return text(
          "\uf2d2  $data",
        );
      },
    );
  }
}
