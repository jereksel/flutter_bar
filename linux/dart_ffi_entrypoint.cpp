#include <stdexcept>
#include <.plugin_symlinks/flutter_bar_plugin/linux/x11/workspaces_with_windows.h>
#include "x11/events_listener/string_array.h"
#include "x11/events_listener/int_array.h"
#include "x11/events_listener/cardinal.h"
#include "util.h"

extern "C" {

EXPORT void *create_cardinal_property_listener(const char *atom_name) {
    return new CardinalX11EventsListener(atom_name);
}

EXPORT uint32_t get_cardinal_property(void *p) {
    return static_cast<CardinalX11EventsListener *>(p)->getEvent();
}

EXPORT void *create_string_list_property_listener(const char *atom_name) {
    return new StringArrayX11EventsListener(atom_name);
}

EXPORT list_of_strings *get_string_list_property(void *p) {
    auto property = static_cast<StringArrayX11EventsListener *>(p)->getEvent();
    return create(property);
}

EXPORT void *create_integer_list_property_listener(const char *atom_name) {
    return new IntArrayX11EventsListener(atom_name);
}

EXPORT list_of_ints *get_integer_list_property(void *p) {
    auto property = static_cast<IntArrayX11EventsListener *>(p)->getEvent();
    return create(property);
}

EXPORT list_of_ints *get_workspaces_with_windows() {
    auto workspaces = getWorkspacesWithWindows();
    return create(std::vector(workspaces.begin(), workspaces.end()));
}

}
