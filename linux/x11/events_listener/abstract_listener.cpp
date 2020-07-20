#include "abstract_listener.h"

template<class ATOM_TYPE>
AbstractX11EventsListener<ATOM_TYPE>::AbstractX11EventsListener(const std::string &atom_name) {
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

template<class ATOM_TYPE>
ATOM_TYPE AbstractX11EventsListener<ATOM_TYPE>::getEvent() {
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

template class AbstractX11EventsListener<std::vector<uint32_t>>;
template class AbstractX11EventsListener<std::vector<std::string>>;
template class AbstractX11EventsListener<uint32_t>;