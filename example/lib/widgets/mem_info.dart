import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/streams.dart';
import 'package:flutter_bar_plugin/text.dart';
import 'package:flutter_bar_plugin_example/widgets/simple_stream_builder.dart';
import 'package:flutter_bar_plugin/system_info.dart' as SystemInfo;

class MemInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stream = oneSecondTicker()
        .map((event) => SystemInfo.getMemoryInfo())
        .map(_ramUsagePercent);

    return SimpleStreamBuilder(
      stream: stream,
      builder: (data) {
        return text("\uf85a $data%");
      },
    );
  }

  int _ramUsagePercent(SystemInfo.MemInfo memInfo) {
    final usedRam = (memInfo.totalRam - memInfo.availableRam);
    return ((usedRam / memInfo.totalRam) * 100).round();
  }
}
