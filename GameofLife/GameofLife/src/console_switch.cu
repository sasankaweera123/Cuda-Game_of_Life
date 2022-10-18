#include "console_switch.cuh"

#include "system_state.cuh"
#include "world_generation.cuh"

void ConsoleSwitch::printMenu()
{
    std::cout << "Enter grid size: ";
    std::cin >> grid_width;
    std::cout << "Available modes of Operation: " << std::endl;
    std::cout << "1. CPU single thread" << std::endl;
    std::cout << "2. CPU multi thread" << std::endl;
    std::cout << "3. GPU CUDA" << std::endl;
    std::cout << "Enter mode of operation: ";
    int mode_input;
    std::cin >> mode_input;
    switch(mode_input)
    {
    case 1:
        system_mode = CPU_SINGLE_THREAD;
        std::cout << "CPU single thread mode selected" << std::endl;
        break;
    case 2:
        system_mode = CPU_MULTI_THREAD;
        std::cout << "CPU multi thread mode selected" << std::endl;
        break;
    case 3:
        system_mode = GPU_CUDA;
        std::cout << "GPU CUDA mode selected" << std::endl;
        break;
    default:
        system_mode = CPU_SINGLE_THREAD;
        std::cout << "Invalid mode selected, defaulting to CPU single thread mode" << std::endl;
        break;
    }
    std::cout << "World grid is randomly generated" << std::endl;
    WorldGeneration::generate_random_world();
}

