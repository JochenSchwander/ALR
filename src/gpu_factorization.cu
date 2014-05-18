#include "gpu_factorization.h"

__global__ void gpu_factorization(long* n, long* p, long* q) {


	long local_n = *n;
	long i;
	long idx = blockIdx.x * blockDim.x + threadIdx.x;
	long step_size = blockDim.x*gridDim.x;
	long steps = local_n/2;
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
