#include "stdio.h"
#include "factorization.h"
#include "gpu_factorization.h"
#include "rsacalculation.h"
#include <cuda.h>

//CUDA section
#define N 10
//END CUDA section

int main()
{
	//CUDA
	long *dev_n, *dev_p, *dev_q;
	int size = sizeof(long int);
	long p, q, n, e, d, expectedD = 185;
	n = 989;
	e = 5;

	printf("n = %ld\n", n);
	factorization(n, &p, &q);
	printf("p = %ld; q = %ld\n", p, q);
	d = calculatePrivateKey(e,p,q);
	printf("d = %ld\n", d);
	printf("lala");
	if (expectedD == d)
		printf("geknackt!");




	//allocate the momory on th GPU
	cudaMalloc((void **) &dev_n, N * sizeof(long));
	cudaMalloc((void **) &dev_p, N * sizeof(long));
	cudaMalloc((void **) &dev_q, N * sizeof(long));

	cudaMemcpy( dev_n, &n, size,cudaMemcpyHostToDevice);

	printf("utz utz2");
	gpu_factorization<<<N,1>>>(*dev_n, dev_p, dev_q);

	printf("utz utz1");
	cudaDeviceSynchronize();
	printf("utz utz");
	cudaMemcpy( &p, dev_p, sizeof(long),	cudaMemcpyDeviceToHost);
	cudaMemcpy( &q, dev_q, sizeof(long),	cudaMemcpyDeviceToHost);

	printf("p = %ld; q = %ld\n", p, q);

	cudaFree(dev_p);
	cudaFree(dev_q);
	cudaFree(dev_n);

	return 0;
}
