#include "gpu_pollard_p1_factorization.h"
#include "gpu_math_stuff.h"

//#define GPU_POLLARD_P1_V2
#define GPU_POLLARD_P1_V1

void gpu_pollard_p1_factorization(long long int n, long long int* p, long long int* q, unsigned long int *primes, unsigned long int primes_length) {
	// pointers needed on device
	long long int *n_dev, *p_dev;
	unsigned long int *primes_dev, *primes_length_dev;

	// allocate memory on device
	cudaMalloc((void **) &n_dev, sizeof(long long int));
	cudaMalloc((void **) &p_dev, sizeof(long long int));
	cudaMalloc((void **) &primes_length_dev, sizeof(unsigned long int));
	cudaMalloc((void **) &primes_dev, sizeof(unsigned long int) * primes_length);
	
	// copy input to device
	cudaMemcpy(n_dev, &n, sizeof(long long int), cudaMemcpyHostToDevice);
	cudaMemcpy(primes_length_dev, &primes_length, sizeof(unsigned long int), cudaMemcpyHostToDevice);
	cudaMemcpy(primes_dev, primes, sizeof(unsigned long int) * primes_length, cudaMemcpyHostToDevice);

	// calculate a prime factor on gpu
	gpu_pollard_p1_factor<<<1,1>>>();
	cudaDeviceSynchronize();

	// copy result to host
	cudaMemcpy(p, p_dev, sizeof(long long int), cudaMemcpyDeviceToHost);

	// free memory on device
	cudaFree(n_dev);
	cudaFree(p_dev);
	cudaFree(primes_length_dev);
	cudaFree(primes_dev);

	// calculate other factor on cpu
	*q = n / *p;
}

__global__ void gpu_pollard_p1_factor(long long int n, unsigned long int *primes, unsigned long int primes_length, long long int *factor) {
	long long int b_max = 1000000;
	long long int a_max = 1000;
	long long int b, e, p, i, a, g;

	for (a = 2; a < a_max; a++) {

		for (b = 2; b < b_max; b++) {

			//calculate e
#ifdef GPU_POLLARD_P1_V2
			e = 1;
#endif
#ifdef GPU_POLLARD_P1_V1
			e = a;
#endif
			for (i = 0; i < primes_length; i++) {
				p = (long long int) primes[i];
				if (b >= p) {
#ifdef GPU_POLLARD_P1_V2
					e *= power_mod(p, log((long double)b) / log((long double) p), n);
#endif
#ifdef GPU_POLLARD_P1_V1
					e = power_mod(e, p, n);
#endif
				} else {
					break;
				}
			}

			//check if g is a factor of n
#ifdef GPU_POLLARD_P1_V2
			g = euclidean_gcd(power_mod(a, e - 1, n), n);
#endif
#ifdef GPU_POLLARD_P1_V1
			g = euclidean_gcd(e - 1, n);
#endif
			if (g > 1) {
				if (g == n) {
					//found trivial factor n of n
					break;
				} else {
					//found a real factor of n
					*factor = g;
					return;
				}
			}
		}
	}
}
