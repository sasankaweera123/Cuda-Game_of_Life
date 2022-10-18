#include "gpu_compute.cuh"
#include <cstdlib>
#include <iostream>
#include <string>
#include <thread>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "system_state.cuh"


__global__ void compute(bool *primary_device_buffer, bool *secondary_device_buffer, int world_width)
{
    int index = blockIdx.x * blockDim.x +threadIdx.x;
    const int x_cord = index % world_width;
    const int y_cord = index / world_width;
    int alive_neighbours = 0;

    for (int k = -1; k < 2; k++)
    {
        for (int j = -1; j < 2; j++)
        {
            if (j == 0 && k == 0)
            {
                continue;
            }
            if (primary_device_buffer[(y_cord + k) * world_width + (x_cord + j)] == true)
            {
                alive_neighbours++;
            }
        }
    }
    if(alive_neighbours < 2 || alive_neighbours > 3)
    {
        secondary_device_buffer[index] = false;
    }
    else if(alive_neighbours == 3)
    {
        secondary_device_buffer[index] = true;
    }
    else
    {
        secondary_device_buffer[index] = primary_device_buffer[index];
    }
}

GpuCompute::GpuCompute(int world_width, bool* start_world_frame)
{
    gpu_state = INIT;
    this->world_width = world_width;
    this->host_world_buffer = start_world_frame;
}

void GpuCompute::init()
{
    buffer_size = world_width * world_width * sizeof(bool);
    //GPU device memory allocation
    cudaMalloc(&primary_device_world_buffer, buffer_size);
    cudaMalloc(&secondary_device_world_buffer, buffer_size);

    //Copy world buffer to GPU device
    cudaMemcpy(primary_device_world_buffer, host_world_buffer, buffer_size,cudaMemcpyHostToDevice);

    gpu_state = RUNNIG;
    
}

void print(int width, bool* buffer)
{
    std::string frame;
    for (int i = 0; i < width; i++)
    {
        for (int j = 0; j < width; j++)
        {
            std::string cell = buffer[i * width + j] ? "X" : " ";
            frame.append(cell);
            frame.append(" ");
        }
        frame.append("\n");
    }
    std::cout << frame;
    std::this_thread::sleep_for(std::chrono::milliseconds(20));
    system("CLS"); 
    
}

void GpuCompute::run()
{
    while (gpu_state == RUNNIG)
    {
        //print(world_width, host_world_buffer);
        compute <<< world_width, world_width >>> (primary_device_world_buffer, secondary_device_world_buffer, world_width);
        cudaMemcpy(host_world_buffer, secondary_device_world_buffer, buffer_size, cudaMemcpyDeviceToHost);
        cudaMemcpy(primary_device_world_buffer, secondary_device_world_buffer, buffer_size, cudaMemcpyDeviceToDevice);
        print(world_width, host_world_buffer);
    }
}

void GpuCompute::cleanup()
{
    free(host_world_buffer);
    cudaFree(primary_device_world_buffer);
    cudaFree(secondary_device_world_buffer);
    gpu_state = CLOSING;
}


