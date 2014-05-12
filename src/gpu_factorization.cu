#include "gpu_factorization.h"

__global__ void gpu_factorization(long n, long* p, long* q) {



	long i;
	long idx = blockIdx.x * blockDim.x + threadIdx.x;
	long step_size = blockDim.x*gridDim.x;

	//TODO: n = sqrt(n) !
	for (i=idx; i<n; i += step_size)
	{
		if(n % i == 0)
		{
			*p = i;
		}
	}
	*q = n / *p;

	__syncthreads();
}
