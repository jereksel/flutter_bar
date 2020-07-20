#ifndef RUNNER_ABSTRACT_LISTENER_H
#define RUNNER_ABSTRACT_LISTENER_H

#include <xcb/xcb.h>
#include <string>
#include <stdexcept>
#include <sstream>
#include "../../util.h"

template<class ATOM_TYPE>
class AbstractX11EventsListener {

public:
    explicit AbstractX11EventsListener(const std::string &atom_name);
    ATOM_TYPE getEvent();

protected:
    xcb_connection_t *conn;
    xcb_atom_t current_desktop_atom;
    xcb_window_t window;

    virtual ATOM_TYPE getAtom() = 0;

private:
    bool first = true;

};

#endif //RUNNER_ABSTRACT_LISTENER_H
