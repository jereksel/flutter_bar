import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:collection/collection.dart';
import 'dart:convert';
import 'X11Properties.dart';

enum PropertyType {
  INT,
  STRING_LIST,
  INT_LIST,
}

class IsolatePackage {
  SendPort sendPort;
  PropertyType propertyType;
  String atomName;
}

//TODO: Rewrite to C API
Stream<String> getCurrentWindow() async* {
  // ignore: close_sinks
  final streamController = StreamController<String>();

  final p = await Process.start(
      "xprop", ["-spy", "-root", "_NET_ACTIVE_WINDOW"],
      mode: ProcessStartMode.detachedWithStdio);

  p.stdout
      .transform(utf8.decoder)
      .map((event) =>
          event.substring("_NET_ACTIVE_WINDOW(WINDOW): window id # ".length))
      .asyncMap((event) async =>
          (await Process.run("xprop", ["-id", event, "_NET_WM_NAME"]))
              .stdout
              .toString())
      .where((event) => event.startsWith("_NET_WM_NAME(UTF8_STRING) = \""))
      .map((event) => event.substring("_NET_WM_NAME(UTF8_STRING) = \"".length))
      //Remove " at the end
      .map((event) => event.substring(0, event.length - 2))
      .listen((event) => streamController.add(event));

  streamController.onCancel = () => {p.kill()};

  yield* streamController.stream.distinct();
}

Stream<List<String>> prepareDesktopNamesListener() {
  return getStringListPropertyStream("_NET_DESKTOP_NAMES");
}

Stream<String> prepareLayoutNamesListener() {
  return getStringListPropertyStream("_XMONAD_CURRENT_LAYOUT")
      .map((event) => event.first);
}

Stream<int> prepareCurrentDesktopListener() {
  return getIntPropertyStream("_NET_CURRENT_DESKTOP");
}

Stream<List<int>> getVisibleDesktops() {
  return getIntListPropertyStream("_FLUTTERBAR_VISIBLE_WORKSPACES");
}

Stream<int> getNumberOfDesktops() {
  return getIntPropertyStream("_NET_NUMBER_OF_DESKTOPS");
}

Stream<int> getIntPropertyStream(String atomName) {
  return getPropertyStream<int>(PropertyType.INT, atomName).distinct();
}

Stream<List<String>> getStringListPropertyStream(String atomName) {
  return getPropertyStream<List<String>>(PropertyType.STRING_LIST, atomName)
      .distinct(ListEquality().equals);
}

Stream<List<int>> getIntListPropertyStream(String atomName) {
  return getPropertyStream<List<int>>(PropertyType.INT_LIST, atomName)
      .distinct(ListEquality().equals);
}

Stream<T> getPropertyStream<T>(PropertyType type, String atomName) async* {
  ReceivePort isolateToMainStream = ReceivePort();

  // ignore: close_sinks
  final s = StreamController<T>();

  isolateToMainStream.listen((message) {
    s.add(message);
  });

  final package = IsolatePackage();
  package.sendPort = isolateToMainStream.sendPort;
  package.propertyType = type;
  package.atomName = atomName;

  await Isolate.spawn(_currentDesktopEntryPoint, package);

  yield* s.stream;
}

void _currentDesktopEntryPoint(IsolatePackage isolatePackage) {
  final sendPort = isolatePackage.sendPort;
  final propertyListener =
      create(isolatePackage.propertyType, isolatePackage.atomName);

  while (true) {
    sendPort.send(propertyListener.getPropertyValue());
  }
}

PropertyListener create(PropertyType type, String atomName) {
  switch (type) {
    case PropertyType.INT:
      return CardinalPropertyListener(atomName);
    case PropertyType.STRING_LIST:
      return StringArrayPropertyListener(atomName);
    case PropertyType.INT_LIST:
      return IntegerArrayPropertyListener(atomName);
  }
  throw Exception("Invalid property type: $type");
}
