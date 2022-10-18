#pragma once
#include "world_grid.cuh"


enum cell_state
{
    DEAD,
    ALIVE
};

class ThreadManager
{
private:
    WorldGrid* world_grid{};
    WorldGrid* world_buffer{};

public:
    ThreadManager(WorldGrid* world_grid);
    ~ThreadManager();
    void init(WorldGrid* world_grid);
    void run();
    void cleanup();
    
};

void ThreadWork(WorldGrid* world_grid, WorldGrid* world_buffer, int start);