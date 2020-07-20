#ifndef RUNNER_UTIL_H
#define RUNNER_UTIL_H

#include <xcb/xcb.h>
#include <cstdint>
#include <vector>
#include <string>

#define EXPORT __attribute__((visibility("default")))

struct list_of_strings {
    uint64_t length;
    char** data;
};

struct list_of_ints {
    uint64_t length;
    uint32_t* data;
};

list_of_strings* create(const std::vector<std::string>& vec);
list_of_ints* create(const std::vector<uint32_t>& vec);

xcb_atom_t intern_atom(xcb_connection_t *conn, const char *atom);
std::vector<std::string> splitString(const std::string &str, char separator);

#endif //RUNNER_UTIL_H
