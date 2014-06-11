#define __CUDACC__

#include <stdio.h>
#include "gpu_pollard_p1_factorization.h"
#include "pollard_p1_factorization.h"
#include "gpu_factorization.h"
#include "rsacalculation.h"
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include "mpz/mpz.h"
#include "kernel.h"



void read_primes(unsigned long int *primes);


int main() {
	unsigned long int primes_length = 78498;
	unsigned long int *primes = (unsigned long int *) malloc(sizeof(unsigned long int) * primes_length);

	//time measurement
	clock_t start, end;

	long long int *p, *q, *n, e, d;
	n = (long long int*)malloc(sizeof(long long int));
	
	read_primes(primes);

	*n = 20903LL * 20921LL;
	//*n = 7331LL * 7333LL;
	//*n = 902491;
	e = 5;

	int choice;
	double cpuTime, gpuTime;
	bool isEnd = false;


	// TODO add menu point for GPU and CPU calculation seperat
	while(!isEnd){



		p = (long long int*)malloc(sizeof(long long int));
		q = (long long int*)malloc(sizeof(long long int));

		//system("say Bitte waehlen sie einen Menuepunkt. Vergiss nicht, martin ist ein bob/!");
		printf("------------- Menu ----------------\n");
		printf("1. CPU & GPU - starten mit Standard n und e ...\n");
		printf("2. CPU & GPU - Eingabe von n und e ...\n");
		printf("3. CPU - starten mit Standard n und e ...\n");
		printf("4. CPU - Eingabe von n und e ...\n");
		printf("5. GPU - starten mit Standard n ...\n");
		printf("6. GPU - Eingabe von n ...\n");
		printf("7. Exit the program ...\n");
		printf("Eingabe choice: ");
		scanf("%d",&choice);

		switch(choice){
			case 1:	printf("------------- Ausgabe -------------\n");
					printf("========= CPU ========\n");
					printf("CPU berchnung wird gestartet...\n");
					start = clock();
					pollard_p1_factorization(*n, p, q, primes, primes_length);
					end = clock();
					cpuTime = (end-start)/(double)CLOCKS_PER_SEC;
					printf("p = %lld\nq = %lld in %lu clocks\n", *p, *q, (unsigned long)(end-start));
					printf("Ergebnis nach (%lf) Sekunden : \np = %lld\nq = %lld \n", cpuTime, *p, *q);
					d = calculatePrivateKey(e,*p,*q);
					printf("d = %lld\n", d);

					printf("========= GPU ========\n");
					printf("GPU Register werden beschrieben\n");
					printf("GPU berechnung wird gestartet\n");
					start = clock();
					gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);
					end = clock();
					gpuTime = (end-start)/(double)CLOCKS_PER_SEC;
					printf("p = %lld\nq = %lld in %lu clocks\n", *p, *q, (unsigned long)(end-start));
					printf("Ergebnis nach (%lf) Sekunden : \np = %lld\nq = %lld \n", gpuTime, *p, *q);

					printf("---------------------------\n");
					if(cpuTime > gpuTime) {
						printf("GPU war %lf Sekunden schneller\n", cpuTime-gpuTime);
						printf("GPU war %lf mal schneller\n", cpuTime/gpuTime);
					} else {
						printf("CPU war %lf Sekunden schneller\n", gpuTime-cpuTime);
						printf("CPU war %lf mal schneller\n", gpuTime/cpuTime);
					}
				break;
			case 2:	printf("Eingabe n: ");
					scanf("%lld",n);
					printf("Eingabe e: ");
					scanf("%lld",&e);
					printf("You input n=%lld und e=%lld \n", *n, e);

					printf("------------- Ausgabe -------------\n");
					printf("========= CPU ========\n");
					printf("CPU berchnung wird gestartet...\n");
					start = clock();
					pollard_p1_factorization(*n, p, q, primes, primes_length);
					end = clock();
					cpuTime = (end-start)/(double)CLOCKS_PER_SEC;
					printf("p = %lld\nq = %lld in %lu clocks\n", *p, *q, (unsigned long)(end-start));
					printf("Ergebnis nach %lf Sekunden : \np = %lld\nq = %lld \n", cpuTime, *p, *q);
					d = calculatePrivateKey(e,*p,*q);
					printf("d = %lld\n", d);

					printf("========= GPU ========\n");
					printf("GPU Register werden beschrieben\n");
					printf("GPU berechnung wird gestartet\n");
					start = clock();
					gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);
					end = clock();
					gpuTime = (end-start)/(double)CLOCKS_PER_SEC;
					printf("p = %lld\nq = %lld in %lu clocks\n", *p, *q, (unsigned long)(end-start));
					printf("Ergebnis nach (%lf) Sekunden : \np = %lld\nq = %lld \n", gpuTime, *p, *q);

					printf("---------------------------\n");
					if(cpuTime > gpuTime) {
						printf("GPU war %lf Sekunden schneller\n", cpuTime-gpuTime);
						printf("GPU war %lf mal schneller\n", cpuTime/gpuTime);
					} else {
						printf("CPU war %lf Sekunden schneller\n", gpuTime-cpuTime);
						printf("CPU war %lf mal schneller\n", gpuTime/cpuTime);
					}
				break;
			case 3: printf("------------- Ausgabe -------------\n");
					printf("========= CPU ========\n");
					printf("CPU berchnung wird gestartet...\n");
					start = clock();
					pollard_p1_factorization(*n, p, q, primes, primes_length);
					end = clock();
					cpuTime = (end-start)/(double)CLOCKS_PER_SEC;
					printf("p = %lld\nq = %lld in %lu clocks\n", *p, *q, (unsigned long)(end-start));
					printf("Ergebnis nach (%lf) Sekunden : \np = %lld\nq = %lld \n", cpuTime, *p, *q);
					d = calculatePrivateKey(e,*p,*q);
					printf("d = %lld\n", d);
				break;
			case 4: printf("Eingabe n: ");
					scanf("%lld",n);
					printf("Eingabe e: ");
					scanf("%lld",&e);
					printf("You input n=%lld und e=%lld \n", *n, e);

					printf("------------- Ausgabe -------------\n");
					printf("========= CPU ========\n");
					printf("CPU berchnung wird gestartet...\n");
					start = clock();
					pollard_p1_factorization(*n, p, q, primes, primes_length);
					end = clock();
					cpuTime = (end-start)/(double)CLOCKS_PER_SEC;
					printf("p = %lld\nq = %lld in %lu clocks\n", *p, *q, (unsigned long)(end-start));
					printf("Ergebnis nach %lf Sekunden : \np = %lld\nq = %lld \n", cpuTime, *p, *q);
					d = calculatePrivateKey(e,*p,*q);
					printf("d = %lld\n", d);
				break;
			case 5: printf("------------- Ausgabe -------------\n");
					printf("========= GPU ========\n");
					printf("GPU Register werden beschrieben\n");
					printf("GPU berechnung wird gestartet\n");
					start = clock();
					gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);
					end = clock();
					gpuTime = (end-start)/(double)CLOCKS_PER_SEC;
					printf("p = %lld\nq = %lld in %lu clocks\n", *p, *q, (unsigned long)(end-start));
					printf("Ergebnis nach (%lf) Sekunden : \np = %lld\nq = %lld \n", gpuTime, *p, *q);
				break;
			case 6: printf("Eingabe n: ");
					scanf("%lld",n);
					printf("You input n=%lld\n", *n);

					printf("------------- Ausgabe -------------\n");
					printf("========= GPU ========\n");
					printf("GPU Register werden beschrieben\n");
					printf("GPU berechnung wird gestartet\n");
					start = clock();
					gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);
					end = clock();
					gpuTime = (end-start)/(double)CLOCKS_PER_SEC;
					printf("p = %lld\nq = %lld in %lu clocks\n", *p, *q, (unsigned long)(end-start));
					printf("Ergebnis nach (%lf) Sekunden : \np = %lld\nq = %lld \n", gpuTime, *p, *q);
				break;
			default: isEnd = true;
				break;
		}
		free(p);
		free(q);
	}

	return 0;
}

void read_primes(unsigned long int *primes) {
	FILE *datei;
	unsigned long int prime;
	int count = 0; 
	
	datei = fopen("src/primes.txt", "r");
	while ((fscanf(datei, "%lu,", &prime)) != EOF) {
		primes[count++] = prime; 
	} 
	fclose(datei); 
}
