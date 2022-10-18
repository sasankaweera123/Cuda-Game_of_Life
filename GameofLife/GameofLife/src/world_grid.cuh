#pragma once

class WorldGrid 
{
private:
    // grid width
    int grid_width;
    // grid pointer
    bool* grid;
public:
    // explicit constructor
   explicit WorldGrid(int width);
    ~WorldGrid();
    // get grid width
    int getGridWidth() const;
    // get grid pointer
    bool* getGrid() const;
    // set grid width
    void setGridWidth(int width);
    // set cell value
    void setCell(int x, int y, bool value);
    // get cell value
    bool getCell(int x, int y) const;
    // get world size
    int getWorldSize() const;
    // print world
    void printWorld() const;
    
};
