#include <iostream>
#include <array>
#include "gtk_bridge.h"

FlMethodResponse *get_monitors() {

    auto display = gdk_display_get_default();

    auto list = fl_value_new_list();

    for (auto i = 0; i < gdk_display_get_n_monitors(display); i++) {
        auto monitor = gdk_display_get_monitor(display, i);
        if (!monitor) {
            auto message = "Monitor nr. " + std::to_string(i) + " not found";
            std::cerr << message << std::endl;
            return FL_METHOD_RESPONSE(fl_method_error_response_new("NO_MONITOR", message.data(), nullptr));
        }
        GdkRectangle rectangle;
        gdk_monitor_get_workarea(monitor, &rectangle);
        auto map = fl_value_new_map();

        fl_value_set_string_take(map, "x", fl_value_new_int(rectangle.x));
        fl_value_set_string_take(map, "y", fl_value_new_int(rectangle.y));
        fl_value_set_string_take(map, "width", fl_value_new_int(rectangle.width));
        fl_value_set_string_take(map, "height", fl_value_new_int(rectangle.height));
        fl_value_set_string_take(map, "primary", fl_value_new_bool(gdk_monitor_is_primary(monitor)));
        fl_value_set_string_take(map, "name", fl_value_new_string(gdk_monitor_get_model(monitor)));

        fl_value_append_take(list, map);
    }

    return FL_METHOD_RESPONSE(fl_method_success_response_new(list));
}

void disable_top_bar() {

    auto windows = gtk_window_list_toplevels();

    auto window = GTK_WINDOW(g_list_nth_data(windows, 0));

    disable_top_bar_for_window(window);

}

void disable_top_bar_for_window(GtkWindow *window) {

    auto app = gtk_window_get_application(window);
    if (app == nullptr) {
        return;
    }

    auto win1 = GTK_WINDOW(gtk_application_get_active_window(app));
    if (win1 == nullptr) {
        return;
    }

    gtk_window_set_type_hint(win1, GDK_WINDOW_TYPE_HINT_DOCK);
    gtk_window_set_decorated(win1, false);

}

void setup_struts(long x, long y, long width, long height, std::array<unsigned long, 12> struts) {

    auto windows = gtk_window_list_toplevels();

    auto window = GTK_WINDOW(g_list_nth_data(windows, 0));

    auto root_window = GDK_WINDOW(gtk_widget_get_window(gtk_widget_get_toplevel(GTK_WIDGET(window))));

    gtk_window_set_default_size(window, width, height);

    auto dpy = GDK_WINDOW_XDISPLAY(root_window);
    auto x11_window = GDK_WINDOW_XID(root_window);

    auto NET_WM_STRUT_PARTIAL = "_NET_WM_STRUT_PARTIAL";
    auto NET_WM_STRUT = "_NET_WM_STRUT";
    auto NET_WM_STRUT_SIZE = 4;
    auto NET_WM_STRUT_PARTIAL_SIZE = 12;

    auto atom_strut = XInternAtom(dpy, NET_WM_STRUT, True);
    if (atom_strut == None) {
        std::clog << "Cannot create atom " << NET_WM_STRUT << std::endl;
        return;
    }

    auto atom_strut_partial = XInternAtom(dpy, NET_WM_STRUT_PARTIAL, True);
    if (atom_strut_partial == None) {
        std::clog << "Cannot create atom " << NET_WM_STRUT_PARTIAL << std::endl;
        return;
    }

    auto casted_arr = (const unsigned char *) struts.data();
    XChangeProperty(dpy, x11_window, atom_strut, XA_CARDINAL, 32, PropModeReplace,
                    casted_arr, NET_WM_STRUT_SIZE);
    XChangeProperty(dpy, x11_window, atom_strut_partial, XA_CARDINAL, 32, PropModeReplace,
                    casted_arr, NET_WM_STRUT_PARTIAL_SIZE);

    //Struts should be set before window mapping, so we want to remap
    gdk_window_hide(root_window);
    gdk_window_show(root_window);

    gtk_window_move(window, x, y);
    gtk_window_resize(window, width, height);

}
