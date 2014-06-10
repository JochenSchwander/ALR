#ifndef GPU_POLLARD_P1_FACTORIZATION_H
#define GPU_POLLARD_P1_FACTORIZATION_H

#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

void gpu_pollard_p1_factorization(long long int n, long long int* p, long long int* q, unsigned long int *primes, unsigned long int primes_length);

__global__ void gpu_pollard_p1_factor(long long int *n_in, long long int *a_in, unsigned long int *primes, unsigned long int *primes_length_in, long long int *factor_out, bool *factor_not_found_dev);

void setGridSize(int size);
int getGridSize();
void setBlockSize(int size);
int getBlockSize();

#endif
