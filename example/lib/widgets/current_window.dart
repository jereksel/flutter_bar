import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/X11.dart';
import 'package:flutter_bar_plugin/text.dart';
import 'package:flutter_bar_plugin_example/widgets/simple_stream_builder.dart';

class CurrentWindowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleStreamBuilder(
      stream: getCurrentWindow(),
      builder: (String data) {
        return Container(
          constraints: BoxConstraints(maxWidth: 500),
          child: text(
            "\uf2d0 $data",
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
