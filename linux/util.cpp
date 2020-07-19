#include <memory.h>
#include <iostream>
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