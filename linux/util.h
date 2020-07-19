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

struct list_of_ints {
    uint64_t length;
    uint32_t* data;
};

list_of_strings* create(const std::vector<std::string>& vec);
list_of_ints* create(const std::vector<uint32_t>& vec);

#endif //RUNNER_UTIL_H
