/**
 * https://www.systutorials.com/docs/linux/man/3-xcb_get_property_value_length/
 * https://stackoverflow.com/a/57910188/2511670
 */

#include <xcb/xcb.h>
#include <malloc.h>
#include <cstring>
#include <memory>
#include <sstream>
#include <vector>
#include <iostream>
#include "util.h"

std::vector<std::string> splitString(const std::string &str, const char separator) {
    std::vector<std::string> strings;
    std::istringstream f(str);
    std::string s;
    while (getline(f, s, separator)) {
        strings.push_back(s);
    }
    return strings;
}

static xcb_atom_t intern_atom(xcb_connection_t *conn, const char *atom) {
    auto result = XCB_NONE;
    auto cookie = xcb_intern_atom(conn, 0, strlen(atom), atom);
    auto r = xcb_intern_atom_reply(conn, cookie, nullptr);
    if (r)
        result = r->atom;
    free(r);
    return result;
}

template<const char *ATOM_NAME, class ATOM_TYPE>
class AbstractX11EventsListener {

public:

    AbstractX11EventsListener() {
        conn = xcb_connect(nullptr, nullptr);
        if (xcb_connection_has_error(conn)) {
            throw std::runtime_error("Cannot open daemon connection.");
        }

        auto screen = xcb_setup_roots_iterator(xcb_get_setup(conn)).data;
        window = screen->root;

        uint32_t values[] = {XCB_EVENT_MASK_PROPERTY_CHANGE};
        xcb_change_window_attributes(
                conn,
                screen->root,
                XCB_CW_EVENT_MASK,
                values
        );


        current_desktop_atom = intern_atom(conn, ATOM_NAME);
        if (current_desktop_atom == XCB_NONE) {
            std::stringstream ss;
            ss << "Cannot get " << ATOM_NAME << "atom";
            throw std::runtime_error(ss.str());
        }

        xcb_flush(conn);

    }

    ATOM_TYPE getEvent() {
        xcb_generic_event_t *ev;
        while ((ev = xcb_wait_for_event(conn))) {
            if (ev->response_type == XCB_PROPERTY_NOTIFY) {
                auto *e = reinterpret_cast<xcb_property_notify_event_t *>(ev);
                if (e->atom == current_desktop_atom) {
                    return getAtom();
                }
            }
        }
        throw std::runtime_error("Lost connection to X server");
    }

protected:
    xcb_connection_t *conn;
    xcb_atom_t current_desktop_atom;
    xcb_window_t window;

    explicit AbstractX11EventsListener(xcb_connection_t *conn, xcb_atom_t current_desktop_atom, xcb_window_t window)
            : conn(
            conn), current_desktop_atom(current_desktop_atom), window(window) {}

    virtual ATOM_TYPE getAtom() = 0;

};

template<const char *ATOM_NAME>
class CardinalX11EventsListener : public AbstractX11EventsListener<ATOM_NAME, uint32_t> {

protected:

    uint32_t getAtom() override {
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
            auto current_desktop = *reinterpret_cast<uint32_t *>(xcb_get_property_value(reply));
            delete reply;
            return current_desktop;
        }
        throw std::runtime_error("Cannot get reply");
    }

};

template<const char *ATOM_NAME>
class StringArrayX11EventsListener : public AbstractX11EventsListener<ATOM_NAME, std::vector<std::string>> {

protected:

    std::vector<std::string> getAtom() override {
        xcb_get_property_cookie_t cookie;
        xcb_get_property_reply_t *reply;

        auto conn = this->conn;
        auto current_desktop_atom = this->current_desktop_atom;
        auto window = this->window;

        /* These atoms are predefined in the X11 protocol. */
        xcb_atom_t property = current_desktop_atom;
        xcb_atom_t type = intern_atom(conn, "UTF8_STRING");

        cookie = xcb_get_property(conn, 0, window, property, type, 0, 8);
        if ((reply = xcb_get_property_reply(conn, cookie, nullptr))) {
            int len = xcb_get_property_value_length(reply);
            auto char_arr = reinterpret_cast<char *>(xcb_get_property_value(reply));

            auto data = std::string(char_arr, len);

            auto desktops = splitString(data, '\x00');

            std::cout << "[" << std::endl;
            for (const auto &desktop : desktops) {
                std::cout << desktop << std::endl;
            }
            std::cout << "]" << std::endl;

            return desktops;
        }
        throw std::runtime_error("Cannot get reply");
    }

};

constexpr char NET_CURRENT_DESKTOP[] = "_NET_CURRENT_DESKTOP";
constexpr char NET_DESKTOP_NAMES[] = "_NET_DESKTOP_NAMES";
constexpr char NET_NUMBER_OF_DESKTOPS[] = "__NET_NUMBER_OF_DESKTOPS";

using CurrentDesktopEventsListener = CardinalX11EventsListener<NET_CURRENT_DESKTOP>;
using NumberOfDesktopsEventsListener = CardinalX11EventsListener<NET_NUMBER_OF_DESKTOPS>;

using DesktopNamesEventsListener = StringArrayX11EventsListener<NET_DESKTOP_NAMES>;

extern "C" {

EXPORT void *create_current_desktop_listener() {
    return new CurrentDesktopEventsListener();
}

EXPORT uint32_t get_current_desktop(void *p) {
    auto listener = static_cast<CurrentDesktopEventsListener *>(p);
    return listener->getEvent();
}

EXPORT void* create_desktop_names_listener() {
    return new DesktopNamesEventsListener();
}

EXPORT list_of_strings* get_desktop_names(void *p) {
    auto listener = static_cast<DesktopNamesEventsListener *>(p);
    auto desktops = listener->getEvent();
    return create(desktops);
}

}