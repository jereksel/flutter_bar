#include <memory.h>
#include <xcb/xcb.h>
#include <sstream>
#include "util.h"

list_of_strings* create(const std::vector<std::string>& vec) {
    auto list = new list_of_strings;
    list->length = vec.size();
    list->data = new char*[vec.size()];
    for (unsigned int i = 0; i < vec.size(); i++) {
        list->data[i] = strdup(vec[i].data());
    }
    return list;
}

list_of_ints* create(const std::vector<uint32_t>& vec) {
    auto list = new list_of_ints;
    list->length = vec.size();
    list->data = new uint32_t[vec.size()];
    for (unsigned int i = 0; i < vec.size(); i++) {
        list->data[i] = vec[i];
    }
    return list;
}

std::vector<std::string> splitString(const std::string &str, const char separator) {
    std::vector<std::string> strings;
    std::istringstream f(str);
    std::string s;
    while (getline(f, s, separator)) {
        strings.push_back(s);
    }
    return strings;
}

xcb_atom_t intern_atom(xcb_connection_t *conn, const char *atom) {
    auto result = XCB_NONE;
    auto cookie = xcb_intern_atom(conn, 0, strlen(atom), atom);
    auto r = xcb_intern_atom_reply(conn, cookie, nullptr);
    if (r)
        result = r->atom;
    free(r);
    return result;
}