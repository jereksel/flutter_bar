#ifndef RUNNER_UTIL_H
#define RUNNER_UTIL_H

#include <cstdint>
#include <vector>
#include <string>

#define EXPORT __attribute__((visibility("default")))

struct list_of_strings {
    uint64_t length;
    char** data;
};

list_of_strings* create(std::vector<std::string>& vec);

#endif //RUNNER_UTIL_H
