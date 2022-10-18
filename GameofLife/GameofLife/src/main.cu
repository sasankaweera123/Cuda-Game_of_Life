#include <iostream>

#include "app.cuh"
#include "system_state.cuh"
#include "world_generation.cuh"
#include "world_grid.cuh"

int main(int argc, char **argv) {
    grid_width = 10;
    
    // Initialize the app
    App::init();

    // Run the app
    App::run();

    // Clean up
    App::cleanup();

    // WorldGeneration::generate_random_world();
    // grid -> printWorld();
    // std::cin.get();
    

    return 0;
}
