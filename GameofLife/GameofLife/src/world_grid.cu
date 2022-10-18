#include "world_grid.cuh"
#include <iostream>
#include <thread>

// world grid constructor
WorldGrid::WorldGrid(int width)
{
    grid_width = width;
    grid = new bool[width * width];
    for (int i = 0; i < width; i++)
    {
        for (int j = 0; j < width; j++)
        {
            setCell(i, j, false);
        }
    }
}

void WorldGrid::setCell(int x, int y, bool value)
{
    grid[x * grid_width + y] = value;
    
}
// world grid destructor
WorldGrid::~WorldGrid()
{
    delete[] grid;
}

int WorldGrid::getGridWidth() const
{
    return grid_width;
}

bool* WorldGrid::getGrid() const
{
    return grid;
}

bool WorldGrid::getCell(int x, int y) const
{
    try
    {
        return grid[x * grid_width + y];
    }catch (...)
    {
        return false;
    }
}

int WorldGrid::getWorldSize() const
{
    return grid_width* grid_width;
}

void WorldGrid::printWorld() const
{
    std::string frame;
    for(int i = 0; i < getGridWidth(); i++)
    {
        for (int j=0; j < getGridWidth(); j++)
        {
            std::string cell = getCell(i, j) ? "X" : "0";
            frame.append(cell);
            frame.append(" ");
        }
        frame.append("\n");
    }
    std::cout << frame << std::endl;
    std::this_thread::sleep_for(std::chrono::milliseconds(50));
    //system("CLS");
}