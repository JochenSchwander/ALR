#include "gpu_factorization.h"

__global__ void gpu_factorization(long long int* n, long long int* p, long long int* q) {


	long long int local_n = *n;
	long long int i;
	long long int idx = blockIdx.x * blockDim.x + threadIdx.x;
	long long int step_size = blockDim.x*gridDim.x;
	long long int steps = local_n/2;
	//TODO: n = sqrt(n) !

	for (i=3+idx; i<steps; i += step_size)
	{
		if(local_n % i == 0)
		{
			*p = i;
		}
	}
	*q = local_n / *p;

	__syncthreads();
}
