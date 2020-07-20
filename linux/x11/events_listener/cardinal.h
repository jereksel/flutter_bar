#ifndef RUNNER_CARDINAL_H
#define RUNNER_CARDINAL_H

#include "abstract_listener.h"

class CardinalX11EventsListener : public AbstractX11EventsListener<uint32_t> {
    using AbstractX11EventsListener::AbstractX11EventsListener;

protected:
    uint32_t getAtom() override;
};

#endif //RUNNER_CARDINAL_H
