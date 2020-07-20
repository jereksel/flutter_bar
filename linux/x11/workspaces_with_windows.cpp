#include <xcb/xcb.h>
#include <memory>
#include <iostream>
#include "workspaces_with_windows.h"
#include "../util.h"

std::set<uint32_t> getWorkspacesWithWindows() {

    auto conn = xcb_connect(nullptr, nullptr);
    if (xcb_connection_has_error(conn)) {
        throw std::runtime_error("Cannot open daemon connection.");
    }

    auto screen = xcb_setup_roots_iterator(xcb_get_setup(conn)).data;
    auto root = screen->root;

    uint32_t values[] = {XCB_EVENT_MASK_PROPERTY_CHANGE};
    xcb_change_window_attributes(
            conn,
            root,
            XCB_CW_EVENT_MASK,
            values
    );

    auto desktop_atom = intern_atom(conn, "_NET_WM_DESKTOP");
    auto client_list_atom = intern_atom(conn, "_NET_CLIENT_LIST");

    auto client_list_cookie = xcb_get_property(conn, 0, root, client_list_atom, XCB_ATOM_WINDOW, 0, UINT32_MAX);
    auto client_list_reply = std::make_unique<xcb_get_property_reply_t *>(
            xcb_get_property_reply(conn, client_list_cookie, nullptr));
    if (!client_list_reply) {
        std::cerr << "Cannot get _NET_CLIENT_LIST" << std::endl;
        throw std::runtime_error("Cannot get _NET_CLIENT_LIST");
    }
    auto client_list_size = xcb_get_property_value_length(*client_list_reply) / 4;
    auto client_list_arr = reinterpret_cast<xcb_window_t *>(xcb_get_property_value(*client_list_reply));

    xcb_get_property_cookie_t window_replies[client_list_size];

    for (auto i = 0; i < client_list_size; i++) {
        auto window = client_list_arr[i];
        auto cookie = xcb_get_property(conn, 0, window, desktop_atom, XCB_ATOM_CARDINAL, 0, UINT32_MAX);
        window_replies[i] = cookie;
    }

    auto set = std::set<uint32_t>{};

    for (auto i = 0; i < client_list_size; i++) {
        auto cookie = window_replies[i];
        auto reply = std::make_unique<xcb_get_property_reply_t *>(
                xcb_get_property_reply(conn, cookie, nullptr));
        if (!reply) {
            std::cerr << "Cannot get _NET_WM_DESKTOP" << std::endl;
            throw std::runtime_error("Cannot get _NET_WM_DESKTOP");
        }
        auto current_desktop = reinterpret_cast<uint32_t *>(xcb_get_property_value(*reply))[0];
        set.insert(current_desktop);
    }

    xcb_disconnect(conn);

    return set;
}
