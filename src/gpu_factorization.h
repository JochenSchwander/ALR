#ifndef GPU_FACTORIZATION_H
#define GPU_FACTORIZATION_H

#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void gpu_factorization(long long int* n, long long int* p, long long int* q);

#endif
