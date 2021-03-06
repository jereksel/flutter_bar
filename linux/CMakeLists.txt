cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "flutter_bar_plugin")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "${PROJECT_NAME}_plugin")
set(CMAKE_CXX_STANDARD 17)
find_package(X11 REQUIRED)
include_directories(${X11_X11_INCLUDE_PATH})

add_library(${PLUGIN_NAME} SHARED
  "${PLUGIN_NAME}.cc"
  library.def
  gtk_bridge.cpp
  util.cpp
  dart_ffi_entrypoint.cpp
  x11/events_listener/abstract_listener.cpp
  x11/events_listener/string_array.cpp
  x11/events_listener/int_array.cpp
  x11/events_listener/cardinal.cpp
  x11/workspaces_with_windows.cpp
)

apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)
target_link_libraries(${PLUGIN_NAME} PRIVATE ${X11_X11_LIB})
# List of absolute paths to libraries that should be bundled with the plugin
set(flutter_bar_plugin_bundled_libraries
  ""
  PARENT_SCOPE
)
