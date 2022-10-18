#pragma once


class GpuCompute
{
private:
    bool* host_world_buffer;
    bool* primary_device_world_buffer;
    bool* secondary_device_world_buffer;
    int world_width;
    int buffer_size;
public:
    GpuCompute(int world_width, bool* start_world_frame);
    void init();
    void run();
    void cleanup();
};
