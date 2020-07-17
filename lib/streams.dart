Stream<void> oneSecondTicker() async* {
  while (true) {
    final now = DateTime.now();
    await Future.delayed(Duration(milliseconds: 1000 - now.millisecond));
    yield null;
  }
}