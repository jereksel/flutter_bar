import 'dart:async';

typedef _TickerCallback = Function();

class _TickerInstance {
  _TickerCallback callback = () => {};
  bool _stop = false;

  void start() async {
    callback();
    while (!_stop) {
      final now = DateTime.now();
      await Future.delayed(Duration(milliseconds: 1000 - now.millisecond));
      callback();
    }
  }

  void stop() {
    _stop = true;
  }
}

Stream<void> oneSecondTicker() {
  final instance = _TickerInstance();

  final sc = StreamController<void>(); // ignore: close_sinks

  sc.onListen = () => {instance.start()};

  sc.onCancel = () => {instance.stop()};

  instance.callback = () => {sc.add(null)};

  return sc.stream;
}
