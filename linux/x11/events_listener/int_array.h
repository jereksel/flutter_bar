#ifndef RUNNER_INT_ARRAY_H
#define RUNNER_INT_ARRAY_H

#include "abstract_listener.h"

class IntArrayX11EventsListener : public AbstractX11EventsListener<std::vector<uint32_t>> {
    using AbstractX11EventsListener::AbstractX11EventsListener;

protected:
    std::vector<uint32_t> getAtom() override;
};

#endif //RUNNER_INT_ARRAY_H
