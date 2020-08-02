import 'dart:ffi' as ffi;

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

class _ListOfStrings extends ffi.Struct {
  @ffi.Uint64()
  int length;

  Pointer<Pointer<Utf8>> data;

  List<String> toList() {
    final list = <String>[];
    for (int i = 0; i < length; i++) {
      final charPtrPtr = data.elementAt(i);
      list.add(Utf8.fromUtf8(charPtrPtr.value));
    }
    return list;
  }

  destroy() {
    for (int i = 0; i < length; i++) {
      free(data[i]);
    }
    free(data);
  }

}

class _ListOfIntegers extends ffi.Struct {
  @ffi.Uint64()
  int length;

  Pointer<ffi.Uint32> data;

  List<int> toList() {
    final list = <int>[];
    for (int i = 0; i < length; i++) {
      final intPtr = data.elementAt(i);
      list.add(intPtr.value);
    }
    return list;
  }

  void destroy() {
    free(data);
  }

}

const FLUTTERBAR_VISIBLE_WORKSPACES = "_FLUTTERBAR_VISIBLE_WORKSPACES";

typedef _constructor_func = ffi.Pointer Function(ffi.Pointer<Utf8> name);
typedef _Constructor = Pointer Function(ffi.Pointer<Utf8> name);

typedef _get_cardinal_property_func = ffi.Int64 Function(ffi.Pointer);
typedef _GetCardinalProperty = int Function(ffi.Pointer);

typedef _get_string_list_property_func = Pointer<_ListOfStrings> Function(
    ffi.Pointer);
typedef _GetStringListProperty = Pointer<_ListOfStrings> Function(ffi.Pointer);

typedef _get_integer_list_property_func = Pointer<_ListOfIntegers> Function(
    ffi.Pointer);
typedef _GetIntegerListProperty = Pointer<_ListOfIntegers> Function(
    ffi.Pointer);

ffi.DynamicLibrary _getLibrary() {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    final location1 = "tests_project/build/linux/debug/plugins/flutter_bar_plugin/libflutter_bar_plugin_plugin.so";
    final location2 = "../$location1";
    if (new File(location1).existsSync()) {
      return ffi.DynamicLibrary.open(location1);
    } else {
      return ffi.DynamicLibrary.open(location2);
    }
  } else {
    return ffi.DynamicLibrary.open('libflutter_bar_plugin_plugin.so');
  }
}

final ffi.DynamicLibrary _dylib = _getLibrary();

final _Constructor cardinalPropertyListenerConstructor = _dylib
    .lookup<ffi.NativeFunction<_constructor_func>>(
        'create_cardinal_property_listener')
    .asFunction();

final _Constructor stringListPropertyListenerConstructor = _dylib
    .lookup<ffi.NativeFunction<_constructor_func>>(
        'create_string_list_property_listener')
    .asFunction();

final _Constructor integerListPropertyListenerConstructor = _dylib
    .lookup<ffi.NativeFunction<_constructor_func>>(
        'create_integer_list_property_listener')
    .asFunction();

final _GetCardinalProperty _getCardinalProperty = _dylib
    .lookup<ffi.NativeFunction<_get_cardinal_property_func>>(
        'get_cardinal_property')
    .asFunction();

final _GetStringListProperty _getStringListProperty = _dylib
    .lookup<ffi.NativeFunction<_get_string_list_property_func>>(
        'get_string_list_property')
    .asFunction();

final _GetIntegerListProperty _getIntegerListProperty = _dylib
    .lookup<ffi.NativeFunction<_get_integer_list_property_func>>(
        'get_integer_list_property')
    .asFunction();

final ffi.Pointer<_ListOfIntegers> Function() _getWorkspacesWithWindows = _dylib
    .lookup<ffi.NativeFunction<Pointer<_ListOfIntegers> Function()>>(
        'get_workspaces_with_windows')
    .asFunction();

abstract class PropertyListener<T> {
  T getPropertyValue();
}

class CardinalPropertyListener extends PropertyListener<int> {
  final ffi.Pointer _instance;

  CardinalPropertyListener._(this._instance);

  int getPropertyValue() {
    return _getCardinalProperty(_instance);
  }

  factory CardinalPropertyListener(String atomName) {
    final instance = cardinalPropertyListenerConstructor(Utf8.toUtf8(atomName));
    return CardinalPropertyListener._(instance);
  }
}

class StringArrayPropertyListener extends PropertyListener<List<String>> {
  final ffi.Pointer _instance;

  StringArrayPropertyListener._(this._instance);

  List<String> getPropertyValue() {
    final struct = _getStringListProperty(_instance);
    final list = struct.ref.toList();
    struct.ref.destroy();
    free(struct);
    return list;
  }

  factory StringArrayPropertyListener(String atomName) {
    final instance =
        stringListPropertyListenerConstructor(Utf8.toUtf8(atomName));
    return StringArrayPropertyListener._(instance);
  }
}

class IntegerArrayPropertyListener extends PropertyListener<List<int>> {
  final ffi.Pointer _instance;

  IntegerArrayPropertyListener._(this._instance);

  List<int> getPropertyValue() {
    final struct = _getIntegerListProperty(_instance);
    final list = struct.ref.toList();
    struct.ref.destroy();
    free(struct);
    return list;
  }

  factory IntegerArrayPropertyListener(String atomName) {
    final instance =
        integerListPropertyListenerConstructor(Utf8.toUtf8(atomName));
    return IntegerArrayPropertyListener._(instance);
  }
}

List<int> getWorkspacesWithWindows() {
  final struct = _getWorkspacesWithWindows();
  final list = struct.ref.toList();
  struct.ref.destroy();
  free(struct);
  return list;
}