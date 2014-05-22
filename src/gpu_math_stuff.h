#ifndef GPU_MATH_STUFF_H
#define GPU_MATH_STUFF_H

#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__device__ inline long long int gpu_euclidean_gcd(long long int a_in, long long int b_in) {
	long long int a = a_in;
	long long int b = b_in;
	long long int t, m;

	if (b > a) {
		t = a; a = b; b = t;
	}

	while (b != 0) {
		m = a % b;
		a = b;
		b = m;
	}

	return a;
}

__device__ inline long long int gpu_power_mod(long long int base, long long int exponent, long long int modulus) {
	long long int i;
	long long int number = base;

	for(i = 1; i < exponent; i++) {
		number *= base;

		//so not every time a modulus is used, when unneeded
		if (number >= modulus) {
			number %= modulus;
		}
	}

	return number;
}

#endif


