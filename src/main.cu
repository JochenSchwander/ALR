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
	long long int *dev_n, *dev_p, *dev_q;
	int size = sizeof(long long int);
	//time measurement
	clock_t start, end;

	long long int *p, *host_p, *host_q, *q, *n, e, d;
	p = (long long int*)malloc(sizeof(long long int));
	q = (long long int*)malloc(sizeof(long long int));
	n = (long long int*)malloc(sizeof(long long int));

	host_p = (long long int*)malloc(sizeof(long long int));
	host_q = (long long int*)malloc(sizeof(long long int));


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
	cudaMalloc((void **) &dev_n, sizeof(long long int));
	cudaMalloc((void **) &dev_p, sizeof(long long int));
	cudaMalloc((void **) &dev_q, sizeof(long long int));

	cudaMemcpy( dev_n, n, size,cudaMemcpyHostToDevice);

	start = clock();
	gpu_factorization<<<4,384>>>(dev_n, dev_p, dev_q);
	cudaDeviceSynchronize();
	end = clock();

	cudaMemcpy( host_p, dev_p, sizeof(long long int),	cudaMemcpyDeviceToHost);
	cudaMemcpy( host_q, dev_q, sizeof(long long int),	cudaMemcpyDeviceToHost);

	printf("p = %I64d; q = %I64d in %lf seconds\n", *host_p, *host_q, (end-start)/(double)CLOCKS_PER_SEC);

	cudaFree(dev_p);
	cudaFree(dev_q);
	cudaFree(dev_n);

	return 0;
}
