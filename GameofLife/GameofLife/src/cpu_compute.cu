#include "cpu_compute.cuh"

#include <thread>

#include "system_state.cuh"

unsigned int processor_count;

void ThreadWork(WorldGrid* world_grid, WorldGrid* world_buffer, int start)
{
    for(int i = start; i < start + world_grid->getWorldSize() / processor_count; i++)
    {
        const int x_cord = i % world_grid->getGridWidth();
        const int y_cord = i / world_grid->getGridWidth();
			
        int alive_neighbours = 0; 
        for(int j = -1; j < 2; j++)
        {
            for(int k = -1; k < 2; k++)
            {
                if(j == 0 && k == 0)
                {
                    continue;
                }
                if(world_grid->getCell(x_cord + j, y_cord + k) == ALIVE)
                {
                    alive_neighbours++;
                }
            } 
        }
        if(alive_neighbours == 3) world_buffer->setCell(x_cord, y_cord, ALIVE);
        else if(alive_neighbours == 2) world_buffer->setCell(x_cord, y_cord, world_grid->getCell(x_cord, y_cord));
        else world_buffer->setCell(x_cord, y_cord, DEAD);
    }
}

ThreadManager::ThreadManager(WorldGrid* world_grid)
{
    cpu_state = INIT;
    init(world_grid);
}

void ThreadManager::init(WorldGrid* _world_grid)
{
    cpu_state = RUNNIG;
    switch(system_mode)
    {
    case CPU_SINGLE_THREAD:
        processor_count = 1;
        break;
    case CPU_MULTI_THREAD:
        processor_count = std::thread::hardware_concurrency();
        break;
    }
    world_grid = _world_grid;
    world_buffer = new WorldGrid(world_grid->getGridWidth());
}

void ThreadManager::run()
{
    while(cpu_state == RUNNIG)
    {
        const auto threads = new std::thread[processor_count];
			
        // Initializing threads
        //int starting_point = i*(world_grid->getWorldSize()/processor_count)); <- This is the starting point for each thread. This was used in the previous version of the code. Now inlined
        for(int i = 0; i < processor_count; i++) threads[i] = std::thread(ThreadWork, world_grid, world_buffer, i*(world_grid->getWorldSize()/processor_count));
			
        // Joining threads
        for(int i = 0; i < processor_count; i++) threads[i].join();
        world_grid->printWorld();
        // Swap the buffers and threads clean up
        delete[] threads;
        delete world_grid;
        world_grid = world_buffer;
        world_buffer = new WorldGrid(world_grid->getGridWidth());
    }
}

void ThreadManager::cleanup()
{
    cpu_state = CLOSING;
    delete world_grid;
    delete world_buffer;
}
