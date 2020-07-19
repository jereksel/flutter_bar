import 'dart:async';
import 'dart:isolate';

import 'CAPI.dart';

Future<Stream<int>> prepareCurrentDesktopListener() async {

  ReceivePort isolateToMainStream = ReceivePort();

  final s = StreamController<int>();

  isolateToMainStream.listen((message) {
    s.add(message);
  });

  await Isolate.spawn(_currentDesktopEntryPoint, isolateToMainStream.sendPort);

  return s.stream.distinct();

}

void _currentDesktopEntryPoint(SendPort sendPort) {

  final event_provider = X11CurrentDesktopListener();

  while(true) {
    sendPort.send(event_provider.getCurrentDesktop());
  }

}

Future<Stream<List<String>>> prepareDesktopNamesListener() async {

  ReceivePort isolateToMainStream = ReceivePort();

  final s = StreamController<List<String>>();

  isolateToMainStream.listen((message) {
    s.add(message);
  });

  await Isolate.spawn(_desktopNamesEntryPoint, isolateToMainStream.sendPort);

  return s.stream.distinct();

}

void _desktopNamesEntryPoint(SendPort sendPort) {

  final event_provider = X11DesktopListListener();

  while(true) {
    sendPort.send(event_provider.getDesktopNames());
  }

}