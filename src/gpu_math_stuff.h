#ifndef GPU_MATH_STUFF_H
#define GPU_MATH_STUFF_H

#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__device__ extern inline long long int euclidean_gcd(long long int a, long long int b);

__device__ extern inline long long int power_mod(long long int base, long long int exponent, long long int modulus);

#endif
