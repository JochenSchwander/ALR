#include "gpu_factorization.h"

__global__ void gpu_factorization(__int64* n, __int64* p, __int64* q) {


	__int64 local_n = *n;
	__int64 i;
	__int64 idx = blockIdx.x * blockDim.x + threadIdx.x;
	__int64 step_size = blockDim.x*gridDim.x;
	__int64 steps = local_n/2;
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
