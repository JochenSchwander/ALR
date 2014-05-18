#include "stdio.h"
//#include "factorization.h"
#include "pollard_p1_factorization.h"
#include "gpu_factorization.h"
#include "rsacalculation.h"
#include <cuda.h>
#include <time.h>



int main()
{
	//CUDA
	__int64 *dev_n, *dev_p, *dev_q;
	int size = sizeof(__int64);
	//time measurement
	clock_t start, end;

	__int64 *p, *host_p, *host_q, *q, *n, e, d;
	p = (__int64*)malloc(sizeof(__int64));
	q = (__int64*)malloc(sizeof(__int64));
	n = (__int64*)malloc(sizeof(__int64));

	host_p = (__int64*)malloc(sizeof(__int64));
	host_q = (__int64*)malloc(sizeof(__int64));


	*n = 902491;
	e = 5;


	printf("n = %I64d\n", *n);
	start = clock();
	//factorization(*n, p, q);
	pollard_p1_factorization(*n, p, q);
	end = clock();
	printf("p = %I64d; q = %I64d in %lf seconds\n", *p, *q, (end-start)/(double)CLOCKS_PER_SEC);
	d = calculatePrivateKey(e,*p,*q);
	printf("d = %I64d\n", d);


	//allocate the momory on th GPU
	cudaMalloc((void **) &dev_n, sizeof(__int64));
	cudaMalloc((void **) &dev_p, sizeof(__int64));
	cudaMalloc((void **) &dev_q, sizeof(__int64));

	cudaMemcpy( dev_n, n, size,cudaMemcpyHostToDevice);

	start = clock();
	gpu_factorization<<<4,384>>>(dev_n, dev_p, dev_q);
	cudaDeviceSynchronize();
	end = clock();

	cudaMemcpy( host_p, dev_p, sizeof(__int64),	cudaMemcpyDeviceToHost);
	cudaMemcpy( host_q, dev_q, sizeof(__int64),	cudaMemcpyDeviceToHost);

	printf("p = %I64d; q = %I64d in %lf seconds\n", *host_p, *host_q, (end-start)/(double)CLOCKS_PER_SEC);

	cudaFree(dev_p);
	cudaFree(dev_q);
	cudaFree(dev_n);

	return 0;
}
