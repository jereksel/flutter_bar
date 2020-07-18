#include "util.h"
#include "sys/types.h"
#include "sys/sysinfo.h"

extern "C" {

    struct RamInfo {
        u_int64_t totalRam;
        u_int64_t freeRam;
    };

    EXPORT RamInfo* hello_world() {
        struct sysinfo memInfo{};

        sysinfo (&memInfo);

        auto ram_info = new RamInfo{memInfo.totalram, memInfo.freeram + memInfo.bufferram + memInfo.sharedram};

        return ram_info;

    }
}