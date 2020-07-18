import 'package:flutter/widgets.dart';
import 'package:flutter_bar_plugin/streams.dart';
import 'package:flutter_bar_plugin_example/widgets/simple_stream_builder.dart';
import 'package:flutter_bar_plugin/system_info.dart' as SystemInfo;
import 'package:flutter_bar_plugin/CAPI.dart';

class MemInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stream = oneSecondTicker()
        .map((event) => SystemInfo.getMemoryInfo())
        .map(_ramUsagePercent);

    return SimpleStreamBuilder(
      stream: stream,
      builder: (data) {
        return Text(data.toString());
      },
    );
  }

  int _ramUsagePercent(MemInfo memInfo) {
    final usedRam = (memInfo.totalRam - memInfo.availableRam);
    return ((usedRam / memInfo.totalRam) * 100).round();
  }
}
