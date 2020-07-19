/**
 * https://www.systutorials.com/docs/linux/man/3-xcb_get_property_value_length/
 * https://stackoverflow.com/a/57910188/2511670
 */

#include <xcb/xcb.h>
#include <cstring>
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

template<class ATOM_TYPE>
class AbstractX11EventsListener {

public:

    explicit AbstractX11EventsListener(const std::string &atom_name) {
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


        current_desktop_atom = intern_atom(conn, atom_name.data());
        if (current_desktop_atom == XCB_NONE) {
            std::stringstream ss;
            ss << "Cannot get " << atom_name << "atom";
            throw std::runtime_error(ss.str());
        }

        xcb_flush(conn);

    }

    ATOM_TYPE getEvent() {
        if (first) {
            first = false;
            return getAtom();
        }
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

private:
    bool first = true;

};

class CardinalX11EventsListener : public AbstractX11EventsListener<uint32_t> {

    using AbstractX11EventsListener::AbstractX11EventsListener;

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
            auto current_desktop = reinterpret_cast<uint32_t *>(xcb_get_property_value(reply))[0];
            delete reply;
            return current_desktop;
        }
        throw std::runtime_error("Cannot get reply");
    }

};

class StringArrayX11EventsListener : public AbstractX11EventsListener<std::vector<std::string>> {

    using AbstractX11EventsListener::AbstractX11EventsListener;

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

};

class IntArrayX11EventsListener : public AbstractX11EventsListener<std::vector<uint32_t>> {

    using AbstractX11EventsListener::AbstractX11EventsListener;

protected:

    std::vector<uint32_t> getAtom() override {
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

};


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

}