#include "cardinal.h"

uint32_t CardinalX11EventsListener::getAtom() {
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
        auto current_desktop = reinterpret_cast<uint32_t *>(xcb_get_property_value(reply))[0];
        delete reply;
        return current_desktop;
    }
    throw std::runtime_error("Cannot get reply");
}
