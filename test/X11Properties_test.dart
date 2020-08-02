import 'dart:io';

import 'package:flutter_bar_plugin/X11Properties.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final propertyName = "_TEST_PROPERTY";

  setUp(() async {
    await Process.run("xprop", ["-root", "-remove", propertyName]);
  });

  tearDown(() async {
    await Process.run("xprop", ["-root", "-remove", propertyName]);
  });

  test('Get single cardinal', () async {
    await Process.run("xprop",
        ["-root", "-f", propertyName, "32c", "-set", propertyName, "1"]);

    final propertyListener = CardinalPropertyListener(propertyName);
    final propertyValue = propertyListener.getPropertyValue();

    expect(propertyValue, equals(1));
  });

  test("Get list of 8 bit numbers", () async {
    await Process.run("xprop",
        ["-root", "-f", propertyName, "8c", "-set", propertyName, "1,2,3,4"]);

    final propertyListener = IntegerArrayPropertyListener(propertyName);
    final propertyValue = propertyListener.getPropertyValue();

    expect(propertyValue, equals([1, 2, 3, 4]));
  }, skip: true);

  test("Get list of cardinals", () async {
    await Process.run("xprop",
        ["-root", "-f", propertyName, "32c", "-set", propertyName, "1,2,3,4"]);

    final propertyListener = IntegerArrayPropertyListener(propertyName);
    final propertyValue = propertyListener.getPropertyValue();

    expect(propertyValue, equals([1, 2, 3, 4]));
  });

  test("Get list of UTF-8 strings", () async {
    final process = await _run_xproperty([propertyName, "1", "2", "a", "b"]);
    final exitCode = await process.exitCode;
    expect(exitCode, 0);
    final propertyListener = StringArrayPropertyListener(propertyName);
    final propertyValue = propertyListener.getPropertyValue();

    expect(propertyValue, equals(["1", "2", "a", "b"]));
  });
}

Future<ProcessResult> _run_xproperty(args) {
  return Process.run("python", [_get_xproperty_location()] + args);
}

String _get_xproperty_location() {
  final loc1 = "xproperty/xproperty.py";
  final loc2 = "../$loc1";
  if (new File(loc1).existsSync()) {
    return loc1;
  }
  return loc2;
}