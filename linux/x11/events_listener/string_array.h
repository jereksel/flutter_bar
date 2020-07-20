#ifndef RUNNER_STRING_ARRAY_H
#define RUNNER_STRING_ARRAY_H

#include "abstract_listener.h"

class StringArrayX11EventsListener : public AbstractX11EventsListener<std::vector<std::string>> {
    using AbstractX11EventsListener::AbstractX11EventsListener;

protected:
    std::vector<std::string> getAtom() override;
};

#endif //RUNNER_STRING_ARRAY_H
