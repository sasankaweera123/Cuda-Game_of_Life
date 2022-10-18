#pragma once
#include "world_grid.cuh"

enum state
{
    INIT,
    RUNNIG,
    CLOSING
};
enum mode
{
    CPU_SINGLE_THREAD,
    CPU_MULTI_THREAD,
    GPU_CUDA
};

inline state system_state;
inline state cpu_state;
inline state gpu_state;

inline mode system_mode;

inline int grid_width;
inline WorldGrid* grid;