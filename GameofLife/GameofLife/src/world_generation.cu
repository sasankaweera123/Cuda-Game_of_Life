#include "world_generation.cuh"

#include <cstdlib>

#include "system_state.cuh"
#include "world_grid.cuh"

void WorldGeneration::generate_random_world()
{
    grid = new WorldGrid(grid_width);
    for(int i = 0; i < grid_width; i++)
    {
        for(int j = 0; j < grid_width; j++)
        {
            grid->setCell(i, j, static_cast<bool>(rand() % 2));
        }
    }
    
}
