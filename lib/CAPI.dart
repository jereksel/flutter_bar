import 'dart:ffi' as ffi;

import 'dart:ffi';

import 'package:flutter/cupertino.dart';

// FFI signature of the hello_world C function
typedef hello_world_func = Pointer<MemInfoStruct> Function();
// Dart type definition for calling the C foreign function
typedef HelloWorld = Pointer<MemInfoStruct> Function();

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

class CAPI {
  final dylib = ffi.DynamicLibrary.open('libflutter_bar_plugin_plugin.so');

//  MemInfo getMemoryInfo() {
//
//    final HelloWorld hello = dylib
//        .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
//        .asFunction();
//
//    final cMemInfo = hello();
//
//    return MemInfo(totalRam: cMemInfo.ref.totalRam, freeRam: cMemInfo.ref.freeRam);
//
//  }

}
