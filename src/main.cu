#include <stdio.h>
//#include "factorization.h"
#include "pollard_p1_factorization.h"
#include "gpu_factorization.h"
#include "rsacalculation.h"
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <time.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

void read_primes(uint16_t *primes, uint16_t primes_length);

int main() {
	uint16_t primes_length = 78499;
	uint16_t *primes = (uint16_t *) malloc(sizeof(uint16_t) * primes_length);
	read_primes(primes, primes_length);

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

	cudaMemcpy( dev_n, n, size,cudaMemcpyHostToDevice);

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

void read_primes(uint16_t *primes, uint16_t primes_length) {
	FILE *datei;
	int prime;
	int count = 0; 
	/* Zum Lesen öffnen */ 
	datei = fopen("src/primzahlenbis1millionen.txt", "r");
	while ((fscanf(datei, "%d,", &prime)) != EOF) { 
		primes[count++] = (uint16_t) prime; 
	} 
	fclose(datei); // Loop over strings
	for (int i = 0; i < 78499; i++) { 
		printf("%d \n", primes[i]);
	}
}
