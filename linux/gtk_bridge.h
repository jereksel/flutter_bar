#ifndef RUNNER_GTK_BRIDGE_H
#define RUNNER_GTK_BRIDGE_H

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtkx.h>
#include <X11/Xatom.h>

FlMethodResponse* get_monitors();

void disable_top_bar();

void disable_top_bar_for_window(GtkWindow* window);

void setup_struts(long x, long y, long width, long height, std::array<unsigned long, 12> struts);

#endif //RUNNER_GTK_BRIDGE_H
