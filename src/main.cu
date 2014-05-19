#include <stdio.h>
//#include "factorization.h"
#include "pollard_p1_factorization.h"
#include "gpu_factorization.h"
#include "rsacalculation.h"
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>

void read_primes(unsigned int *primes);

int main() {
	unsigned int primes_length = 78498;
	unsigned int *primes = (unsigned int *) malloc(sizeof(unsigned int) * primes_length);

	//CUDA
	long long int *dev_n, *dev_p, *dev_q;
	//time measurement
	clock_t start, end;

	long long int *p, *host_p, *host_q, *q, *n, e, d;
	p = (long long int*)malloc(sizeof(long long int));
	q = (long long int*)malloc(sizeof(long long int));
	n = (long long int*)malloc(sizeof(long long int));

	host_p = (long long int*)malloc(sizeof(long long int));
	host_q = (long long int*)malloc(sizeof(long long int));


	
	read_primes(primes);

	*n = 902491;
	e = 5;


	printf("n = %lld\n", *n);
	start = clock();
	//factorization(*n, p, q);
	pollard_p1_factorization(*n, p, q, primes, primes_length);
	end = clock();
	printf("p = %lld; q = %lld in %lf seconds\n", *p, *q, (end-start)/(double)CLOCKS_PER_SEC);
	d = calculatePrivateKey(e,*p,*q);
	printf("d = %lld\n", d);


	//allocate the momory on th GPU
	cudaMalloc((void **) &dev_n, sizeof(long long int));
	cudaMalloc((void **) &dev_p, sizeof(long long int));
	cudaMalloc((void **) &dev_q, sizeof(long long int));

	cudaMemcpy( dev_n, n, sizeof(long long int),cudaMemcpyHostToDevice);

	start = clock();
	gpu_factorization<<<4,384>>>(dev_n, dev_p, dev_q);
	cudaDeviceSynchronize();
	end = clock();

	cudaMemcpy( host_p, dev_p, sizeof(long long int),	cudaMemcpyDeviceToHost);
	cudaMemcpy( host_q, dev_q, sizeof(long long int),	cudaMemcpyDeviceToHost);

	printf("p = %lld; q = %lld in %lf seconds\n", *host_p, *host_q, (end-start)/(double)CLOCKS_PER_SEC);

	cudaFree(dev_p);
	cudaFree(dev_q);
	cudaFree(dev_n);

	return 0;
}

void read_primes(unsigned int *primes) {
	FILE *datei;
	unsigned int prime;
	int count = 0; 
	/* Zum Lesen öffnen */ 
	datei = fopen("src/primzahlenbis1millionen.txt", "r");
	while ((fscanf(datei, "%u,", &prime)) != EOF) { 
		primes[count++] = prime; 
	} 
	fclose(datei); 
	// Loop over strings
	for (int i = 0; i < 78498; i++) { 
		printf("%u \n", primes[i]);
	}
}
