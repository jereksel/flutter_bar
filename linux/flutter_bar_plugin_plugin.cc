#include "include/flutter_bar_plugin/flutter_bar_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>
#include <string>
#include <array>
#include "gtk_bridge.h"
#include "util.h"

#define FLUTTER_BAR_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), flutter_bar_plugin_get_type(), \
                              FlutterBarPlugin))

struct _FlutterBarPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(FlutterBarPlugin, flutter_bar_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void flutter_bar_plugin_handle_method_call(
    FlutterBarPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const auto method = std::string(fl_method_call_get_name(method_call));

  if (method == "getPlatformVersion") {
      struct utsname uname_data = {};
      uname(&uname_data);
      g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
      g_autoptr(FlValue) result = fl_value_new_string(version);
      response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else if (method == "getMonitors") {
      response = get_monitors();
  } else if (method == "disableTopBar") {
      disable_top_bar();
      response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else if (method == "setStruts") {
      auto args = fl_method_call_get_args(method_call);
      auto x = fl_value_get_int(fl_value_get_list_value(args, 0));
      auto y = fl_value_get_int(fl_value_get_list_value(args, 1));
      auto width = fl_value_get_int(fl_value_get_list_value(args, 2));
      auto height = fl_value_get_int(fl_value_get_list_value(args, 3));
      auto fl_strut_array = fl_value_get_list_value(args, 4);

      std::array<unsigned long, 12> t {
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 0))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 1))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 2))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 3))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 4))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 5))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 6))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 7))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 8))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 9))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 10))),
          static_cast<unsigned long>(fl_value_get_int(fl_value_get_list_value(fl_strut_array, 11))),
      };

      setup_struts(x, y, width, height, t);
      response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void flutter_bar_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(flutter_bar_plugin_parent_class)->dispose(object);
}

static void flutter_bar_plugin_class_init(FlutterBarPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = flutter_bar_plugin_dispose;
}

static void flutter_bar_plugin_init(FlutterBarPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  FlutterBarPlugin* plugin = FLUTTER_BAR_PLUGIN(user_data);
  flutter_bar_plugin_handle_method_call(plugin, method_call);
}

void flutter_bar_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FlutterBarPlugin* plugin = FLUTTER_BAR_PLUGIN(
      g_object_new(flutter_bar_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "flutter_bar_plugin",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
