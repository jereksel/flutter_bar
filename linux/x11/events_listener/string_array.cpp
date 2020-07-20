#include "string_array.h"

std::vector<std::string> StringArrayX11EventsListener::getAtom() {
    xcb_get_property_cookie_t cookie;
    xcb_get_property_reply_t *reply;

    auto conn = this->conn;
    auto current_desktop_atom = this->current_desktop_atom;
    auto window = this->window;

    /* These atoms are predefined in the X11 protocol. */
    xcb_atom_t property = current_desktop_atom;
    xcb_atom_t type = intern_atom(conn, "UTF8_STRING");

    cookie = xcb_get_property(conn, 0, window, property, type, 0, UINT32_MAX);
    if ((reply = xcb_get_property_reply(conn, cookie, nullptr))) {
        int len = xcb_get_property_value_length(reply);
        auto char_arr = reinterpret_cast<char *>(xcb_get_property_value(reply));
        auto data = std::string(char_arr, len);
        auto desktops = splitString(data, '\x00');
        return desktops;
    }
    throw std::runtime_error("Cannot get reply");
}
