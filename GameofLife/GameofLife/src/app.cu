#include "app.cuh"

#include "console_switch.cuh"
#include "cpu_compute.cuh"
#include "gpu_compute.cuh"
#include "system_state.cuh"

ThreadManager *thread_manager;

int App::init()
{
    system_state = INIT;
    ConsoleSwitch::printMenu();
    return 0;
}

int App::run()
{
    switch (system_mode)
    {
    case CPU_SINGLE_THREAD:
        {
            thread_manager = new ThreadManager(grid);
            thread_manager->run();
            break;
            
        }
    case CPU_MULTI_THREAD:
        {
            thread_manager = new ThreadManager(grid);
            thread_manager->run();
            break;
        }
    case GPU_CUDA:
        {
            auto *compute_gpu = new GpuCompute(grid_width,grid->getGrid());
            compute_gpu->init();
            compute_gpu->run();
            break;
            
        }
    }
    return 0;
}

int App::cleanup()
{
    return 0;
}

