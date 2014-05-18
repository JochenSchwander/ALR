#include "stdio.h"
#include "factorization.h"
#include "gpu_factorization.h"
#include "rsacalculation.h"
#include <cuda.h>



int main()
{
	//CUDA
	long *dev_n, *dev_p, *dev_q;
	int size = sizeof(long);
	//time measurement
	clock_t start, end;

	long *p, *host_p, *host_q, *q, *n, e, d;
	p = (long*)malloc(sizeof(long));
	q = (long*)malloc(sizeof(long));
	n = (long*)malloc(sizeof(long));

	host_p = (long*)malloc(sizeof(long));
	host_q = (long*)malloc(sizeof(long));


	*n = 902491;
	e = 5;


	printf("n = %ld\n", *n);
	start = clock();
	factorization(*n, p, q);
	end = clock();
	printf("p = %ld; q = %ld in %lf seconds\n", *p, *q, (end-start)/(double)CLOCKS_PER_SEC);
	d = calculatePrivateKey(e,*p,*q);
	printf("d = %ld\n", d);


	//allocate the momory on th GPU
	cudaMalloc((void **) &dev_n, sizeof(long));
	cudaMalloc((void **) &dev_p, sizeof(long));
	cudaMalloc((void **) &dev_q, sizeof(long));

	cudaMemcpy( dev_n, n, size,cudaMemcpyHostToDevice);

	start = clock();
	gpu_factorization<<<4,384>>>(dev_n, dev_p, dev_q);
	cudaDeviceSynchronize();
	end = clock();

	cudaMemcpy( host_p, dev_p, sizeof(long),	cudaMemcpyDeviceToHost);
	cudaMemcpy( host_q, dev_q, sizeof(long),	cudaMemcpyDeviceToHost);

	printf("p = %ld; q = %ld in %lf seconds\n", *host_p, *host_q, (end-start)/(double)CLOCKS_PER_SEC);

	cudaFree(dev_p);
	cudaFree(dev_q);
	cudaFree(dev_n);

	system("say martin ist ein bob.");
	return 0;
}
