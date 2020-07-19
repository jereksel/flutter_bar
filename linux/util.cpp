#include <memory.h>
#include "util.h"

list_of_strings* create(std::vector<std::string>& vec) {
    auto list = new list_of_strings;
    list->length = vec.size();
    list->data = new char*[vec.size()];
    for (auto i = 0; i < vec.size(); i++) {
        list->data[i] = strdup(vec[i].data());
    }
    return list;
}