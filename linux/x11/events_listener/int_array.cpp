#include <iostream>
#include "int_array.h"

std::vector<uint32_t> IntArrayX11EventsListener::getAtom() {
    xcb_get_property_cookie_t cookie;
    xcb_get_property_reply_t *reply;

    auto conn = this->conn;
    auto current_desktop_atom = this->current_desktop_atom;
    auto window = this->window;

/* These atoms are predefined in the X11 protocol. */
    xcb_atom_t property = current_desktop_atom;
    xcb_atom_t type = XCB_ATOM_CARDINAL;

    cookie = xcb_get_property(conn, 0, window, property, type, 0, UINT32_MAX);
    if ((reply = xcb_get_property_reply(conn, cookie, nullptr))) {
        int len = (xcb_get_property_value_length(reply) / 4);
        auto int_arr = reinterpret_cast<uint32_t *>(xcb_get_property_value(reply));
        auto vec = std::vector<uint32_t>(len);
        for (int i = 0; i < len; i++) {
            vec[i] = int_arr[i];
        }
        return vec;
    }
    throw std::runtime_error("Cannot get reply");
}
