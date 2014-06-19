#include "gpu_pollard_p1_factorization.h"
#include "gpu_math_stuff.h"
#include "device.h"
#include <stdbool.h>

#ifdef MACBOOK
int gridSize = 3;
int blockSize = 976;
#endif

#ifdef XMG
int gridSize = 12;
int blockSize = 16;
#endif

//Weichen
//#define DEBUG_GPU_ONLY_CALC

#ifdef DEBUG_GPU_ONLY_CALC
#include <stdio.h>
#include <time.h>
clock_t start, end;
#endif

void setGridSize(int size) {
	gridSize = size;
}

int getGridSize() {
	return gridSize;
}

void setBlockSize(int size) {
	blockSize = size;
}

int getBlockSize() {
	return blockSize;
}

void gpu_pollard_p1_factorization(long long int n, long long int* p, long long int* q, unsigned long int *primes, unsigned long int primes_length) {
	// pointers needed on device
	long long int a, a_max = 1000;
	long long int *n_dev, *p_dev, *a_dev;
	unsigned long int *primes_dev, *primes_length_dev;
	bool factor_not_found = true;
	bool *factor_not_found_dev;


	// allocate memory on device
	cudaMalloc((void **) &n_dev, sizeof(long long int));
	cudaMalloc((void **) &p_dev, sizeof(long long int));
	cudaMalloc((void **) &primes_length_dev, sizeof(unsigned long int));
	cudaMalloc((void **) &primes_dev, sizeof(unsigned long int) * primes_length);
	cudaMalloc((void **) &a_dev, sizeof(long long int));
	cudaMalloc((void **) &factor_not_found_dev, sizeof(bool));

	
	// copy input to device
	cudaMemcpy(n_dev, &n, sizeof(long long int), cudaMemcpyHostToDevice);
	cudaMemcpy(primes_length_dev, &primes_length, sizeof(unsigned long int), cudaMemcpyHostToDevice);
	cudaMemcpy(primes_dev, primes, sizeof(unsigned long int) * primes_length, cudaMemcpyHostToDevice);
	cudaMemcpy(factor_not_found_dev, &factor_not_found, sizeof(bool), cudaMemcpyHostToDevice);

	for (a = 2; a < a_max && factor_not_found; a++) {
		// copy a in
		cudaMemcpy(a_dev, &a, sizeof(long long int), cudaMemcpyHostToDevice);

#ifdef DEBUG_GPU_ONLY_CALC
		//measure gpu calculation only
		start = clock();
#endif

		// calculate a prime factor on gpu
		gpu_pollard_p1_factor<<<gridSize,blockSize>>>(n_dev, a_dev, primes_dev, primes_length_dev, p_dev, factor_not_found_dev);
		cudaDeviceSynchronize();

#ifdef DEBUG_GPU_ONLY_CALC
		end = clock();
		printf("---> gpu calculation: %lf; a = %lld\n",  (end-start)/(double)CLOCKS_PER_SEC, a);
#endif

		// check if factor allready found
		cudaMemcpy(&factor_not_found, factor_not_found_dev, sizeof(bool), cudaMemcpyDeviceToHost);
	}

	// copy result to host
	cudaMemcpy(p, p_dev, sizeof(long long int), cudaMemcpyDeviceToHost);

	// free memory on device
	cudaFree(n_dev);
	cudaFree(p_dev);
	cudaFree(primes_length_dev);
	cudaFree(primes_dev);
	cudaFree(a_dev);
	cudaFree(factor_not_found_dev);

	// calculate other factor on cpu
	*q = n / *p;
}

__global__ void gpu_pollard_p1_factor(long long int *n_in, long long int *a_in, unsigned long int *primes, unsigned long int *primes_length_in, long long int *factor_out, bool *factor_not_found_dev) {
	unsigned int b;
	long long int  e, p, i, g;
	long long int n = *n_in;
	unsigned long int primes_length = *primes_length_in;

	for (b = 2 + blockIdx.x * blockDim.x + threadIdx.x; b < 1000000 && *factor_not_found_dev; b += blockDim.x * gridDim.x) {
		//calculate e
		e = *a_in;
		for (i = 0; i < primes_length; i++) {
			p = (long long int) primes[i];
			if (b >= p) {
				e = gpu_power_mod(e, p, n);
			} else {
				break;
			}
		}

		//check if g is a factor of n
		g = gpu_euclidean_gcd(e - 1, n);
		if (g > 1) {
			if (g == n) {
				//found trivial factor n of n
				return;
			} else {
				//found a real factor of n
				*factor_out = g;

				//stop all other threads
				*factor_not_found_dev = false;
				return;
			}
		}
	}
}
