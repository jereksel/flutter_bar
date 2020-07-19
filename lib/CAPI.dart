import 'dart:ffi' as ffi;

import 'dart:ffi';

import 'package:ffi/ffi.dart' as ffi2;

import 'package:flutter/cupertino.dart';

// FFI signature of the hello_world C function
typedef constructor_func = ffi.Pointer Function();
// Dart type definition for calling the C foreign function
typedef Constructor = Pointer Function();

typedef get_current_desktop_func = ffi.Int64 Function(ffi.Pointer);
typedef GetCurrentDesktop = int Function(ffi.Pointer);

typedef get_current_desktop_list_func = Pointer<ListOfStrings> Function(ffi.Pointer);
typedef GetCurrentDesktopList = Pointer<ListOfStrings> Function(ffi.Pointer);

class ListOfStrings extends ffi.Struct {
  @ffi.Uint64()
  int length;

  Pointer<Pointer<ffi2.Utf8>> data;
}

// Example of handling a simple C struct
class MemInfoStruct extends Struct {
  @Uint64()
  int totalRam;

  @Uint64()
  int freeRam;
}

@immutable
class MemInfo {
  final int totalRam;
  final int freeRam;
  final int availableRam;

  MemInfo(
      {@required this.totalRam,
      @required this.freeRam,
      @required this.availableRam});
}

final _dylib = ffi.DynamicLibrary.open('libflutter_bar_plugin_plugin.so');

class X11CurrentDesktopListener {

  final ffi.Pointer _instance;
  final GetCurrentDesktop _getter;

  X11CurrentDesktopListener._(this._instance, this._getter);

  int getCurrentDesktop() {
    return _getter(_instance);
  }

  factory X11CurrentDesktopListener() {
    final Constructor constructor = _dylib.lookup<ffi.NativeFunction<constructor_func>>('create_current_desktop_listener').asFunction();
    final GetCurrentDesktop f = _dylib.lookup<ffi.NativeFunction<get_current_desktop_func>>('get_current_desktop').asFunction();
    final instance = constructor();
    return X11CurrentDesktopListener._(instance, f);
  }

}

class X11DesktopListListener {

  final ffi.Pointer _instance;
  final GetCurrentDesktopList _getter;

  X11DesktopListListener._(this._instance, this._getter);

  List<String> getDesktopNames() {
    final struct = _getter(_instance);
    final list = <String>[];
    for (int i = 0; i < struct.ref.length; i++) {
      final charPtrPtr = struct.ref.data.elementAt(i);
      list.add(ffi2.Utf8.fromUtf8(charPtrPtr.value));
    }
    return list;
  }

  factory X11DesktopListListener() {
    final Constructor constructor = _dylib.lookup<ffi.NativeFunction<constructor_func>>('create_desktop_names_listener').asFunction();
    final GetCurrentDesktopList f = _dylib.lookup<ffi.NativeFunction<get_current_desktop_list_func>>('get_desktop_names').asFunction();
    final instance = constructor();
    return X11DesktopListListener._(instance, f);
  }

}