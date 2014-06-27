#include "gpu_pollard_p1_factorization.h"
#include "pollard_p1_factorization.h"
#include "rsacalculation.h"
#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "statistic_definitions.h"

void read_primes(unsigned long int *primes);

int main(int argc, char *argv[]) {
	unsigned long int primes_length = 78498;
	unsigned long int *primes = (unsigned long int *) malloc(sizeof(unsigned long int) * primes_length);
	int i, j;
	bool statisticMode = false;

	//time measurement
	clock_t start, end;

	long long int *p, *q, *n, e, d;
	n = (long long int*) malloc(sizeof(long long int));
	p = (long long int*) malloc(sizeof(long long int));
	q = (long long int*) malloc(sizeof(long long int));

	read_primes(primes);

	int choice;
	double cpuTime, gpuTime;
	bool isEnd = false;

	if (argc > 1) {
		if (strstr(argv[1], "-statistic") != NULL) {
			statisticMode = true;
			choice = 7;
			goto menu;
		}
	}

	while (!isEnd) {
		printf("------------- Menu ----------------\n");
		printf("1. CPU & GPU - Starten mit Standard n und e ...\n");
		printf("2. CPU & GPU - Eingabe von n und e ...\n");
		printf("3. CPU - Starten mit Standard n und e ...\n");
		printf("4. CPU - Eingabe von n und e ...\n");
		printf("5. GPU - Starten mit Standard n ...\n");
		printf("6. GPU - Eingabe von n ...\n");
		printf("7. GPU - BlockSize/GridSize Statistik ...\n");
		printf("8. CPU & GPU - n's aus Datei einlesen und Statistik erstellen ...\n");
		printf("0. Programm verlassen ...\n");
		printf("Eingabe Menuepunkt: ");
		scanf("%d", &choice);

menu: 
		//*n = 65521LL * 65537LL;  //n6, biggest possible n
		//*n = 57037LL * 57041LL;  //n5
		//*n = 40709LL * 40739LL;  //n4
		//*n = 32621LL * 32633LL;  //n3!
		//*n = 25087LL * 25097LL;  //n2
		*n = 20903LL * 20921LL;  //n1
		//*n = 7331LL * 7333LL;
		//*n = 902491;
		e = 21;

		*p = 1;
		*q = 1;

		switch (choice) {
		case 1:
			printf("------------- Eingabe -------------\n");
			printf("n = %lld, e = %lld\n", *n, e);

			printf("------------- Ausgabe -------------\n");
			printf("========= CPU ========\n");
			printf("CPU erchnung wird gestartet...\n");
			start = clock();
			pollard_p1_factorization(*n, p, q, primes, primes_length);
			end = clock();
			cpuTime = (end - start) / (double) CLOCKS_PER_SEC;
			printf("Ergebnis nach %lf Sekunden / %lu clocks: \np = %lld\nq = %lld \n", cpuTime, (unsigned long) (end - start), *p, *q);
			d = calculatePrivateKey(e, *p, *q);
			printf("d = %lld\n", d);

			printf("========= GPU ========\n");
			printf("GPU Register werden beschrieben\n");
			printf("GPU berechnung wird gestartet\n");
			start = clock();
			gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);
			end = clock();
			gpuTime = (end - start) / (double) CLOCKS_PER_SEC;
			printf("Ergebnis nach %lf Sekunden / %lu clocks: \np = %lld\nq = %lld \n", gpuTime, (unsigned long) (end - start), *p, *q);

			printf("---------------------------\n");
			if (cpuTime > gpuTime) {
				printf("GPU war %lf Sekunden schneller\n", cpuTime - gpuTime);
				printf("GPU war %lf mal schneller\n", cpuTime / gpuTime);
			} else {
				printf("CPU war %lf Sekunden schneller\n", gpuTime - cpuTime);
				printf("CPU war %lf mal schneller\n", gpuTime / cpuTime);
			}
			break;
		case 2:
			printf("Eingabe n: ");
			scanf("%lld", n);
			printf("Eingabe e: ");
			scanf("%lld", &e);

			printf("------------- Eingabe -------------\n");
			printf("n = %lld, e = %lld\n", *n, e);

			printf("------------- Ausgabe -------------\n");
			printf("========= CPU ========\n");
			printf("CPU berchnung wird gestartet...\n");
			start = clock();
			pollard_p1_factorization(*n, p, q, primes, primes_length);
			end = clock();
			cpuTime = (end - start) / (double) CLOCKS_PER_SEC;
			printf("Ergebnis nach %lf Sekunden / %lu clocks: \np = %lld\nq = %lld \n", cpuTime, (unsigned long) (end - start), *p, *q);
			d = calculatePrivateKey(e, *p, *q);
			printf("d = %lld\n", d);

			printf("========= GPU ========\n");
			printf("GPU Register werden beschrieben\n");
			printf("GPU berechnung wird gestartet\n");
			start = clock();
			gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);
			end = clock();
			gpuTime = (end - start) / (double) CLOCKS_PER_SEC;
			printf("Ergebnis nach %lf Sekunden / %lu clocks: \np = %lld\nq = %lld \n", gpuTime, (unsigned long) (end - start), *p, *q);

			printf("---------------------------\n");
			if (cpuTime > gpuTime) {
				printf("GPU war %lf Sekunden schneller\n", cpuTime - gpuTime);
				printf("GPU war %lf mal schneller\n", cpuTime / gpuTime);
			} else {
				printf("CPU war %lf Sekunden schneller\n", gpuTime - cpuTime);
				printf("CPU war %lf mal schneller\n", gpuTime / cpuTime);
			}
			break;
		case 3:
			printf("------------- Eingabe -------------\n");
			printf("n = %lld, e = %lld\n", *n, e);

			printf("------------- Ausgabe -------------\n");
			printf("========= CPU ========\n");
			printf("CPU berchnung wird gestartet...\n");
			start = clock();
			pollard_p1_factorization(*n, p, q, primes, primes_length);
			end = clock();
			cpuTime = (end - start) / (double) CLOCKS_PER_SEC;
			printf("Ergebnis nach %lf Sekunden / %lu clocks: \np = %lld\nq = %lld \n", cpuTime, (unsigned long) (end - start), *p, *q);
			d = calculatePrivateKey(e, *p, *q);
			printf("d = %lld\n", d);
			break;
		case 4:
			printf("Eingabe n: ");
			scanf("%lld", n);
			printf("Eingabe e: ");
			scanf("%lld", &e);

			printf("------------- Eingabe -------------\n");
			printf("n = %lld, e = %lld\n", *n, e);

			printf("------------- Ausgabe -------------\n");
			printf("========= CPU ========\n");
			printf("CPU berchnung wird gestartet...\n");
			start = clock();
			pollard_p1_factorization(*n, p, q, primes, primes_length);
			end = clock();
			cpuTime = (end - start) / (double) CLOCKS_PER_SEC;
			printf("Ergebnis nach %lf Sekunden / %lu clocks: \np = %lld\nq = %lld \n", cpuTime, (unsigned long) (end - start), *p, *q);
			d = calculatePrivateKey(e, *p, *q);
			printf("d = %lld\n", d);
			break;
		case 5:
			printf("------------- Eingabe -------------\n");
			printf("n = %lld, e = %lld\n", *n, e);

			printf("------------- Ausgabe -------------\n");
			printf("========= GPU ========\n");
			printf("GPU Register werden beschrieben\n");
			printf("GPU berechnung wird gestartet\n");
			start = clock();
			gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);
			end = clock();
			gpuTime = (end - start) / (double) CLOCKS_PER_SEC;
			printf("Ergebnis nach %lf Sekunden / %lu clocks: \np = %lld\nq = %lld \n", gpuTime, (unsigned long) (end - start), *p, *q);
			break;
		case 6:
			printf("Eingabe n: ");
			scanf("%lld", n);
			
			printf("------------- Eingabe -------------\n");
			printf("n = %lld, e = %lld\n", *n, e);

			printf("------------- Ausgabe -------------\n");
			printf("========= GPU ========\n");
			printf("GPU Register werden beschrieben\n");
			printf("GPU berechnung wird gestartet\n");
			start = clock();
			gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);
			end = clock();
			gpuTime = (end - start) / (double) CLOCKS_PER_SEC;
			printf("Ergebnis nach %lf Sekunden / %lu clocks: \np = %lld\nq = %lld \n", gpuTime, (unsigned long) (end - start), *p, *q);
			break;
		case 7: //first run takes longer, remove from statistics
			gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);

			printf("gridSize;blockSize;p;q;clocks;seconds\n");
			for (i = STATISTIC_MULTIPROCESSORS; i <= STATISTIC_MAX_GRIDSIZE; i += STATISTIC_MULTIPROCESSORS) {
				setGridSize(i);
				for (j = STATISTIC_BLOCKSIZE_STEPSIZE; j <= STATISTIC_MAX_BLOCKSIZE; j += STATISTIC_BLOCKSIZE_STEPSIZE) {
					if ((i / STATISTIC_MULTIPROCESSORS) * j > STATISTIC_MAX_THREADS_PER_MULTIPROCESSOR) {
						continue;
					}
					setBlockSize(j);
					start = clock();
					gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);
					end = clock();
					gpuTime = (end - start) / (double) CLOCKS_PER_SEC;
					printf("%d;%d;%lld;%lld;%lu;%lf\n", getGridSize(), getBlockSize(), *p, *q, (unsigned long) (end - start), gpuTime);
					*p = 1;
					*q = 1;
				}
			}
			if (statisticMode) {
				isEnd = true;
			}
			break;
		case 8: {
			FILE *input, *statOutput; //*output
			char filename[50];
			char buff[25];
			input = fopen("fileofN_check.txt", "r");
			//NOT IN SUBFOLDER "statistic" -> program crashes if folder isn't there...
			//output = fopen("outputCalculation.txt", "a+");

			//open and create statistic output file for excel import
			time_t timeforFilename = time(0);
			strftime(buff, 25, "%Y%m%d_%H_%M_%S", localtime(&timeforFilename));
			//NOT IN SUBFOLDER "statistic" -> program crashes if folder isn't there...
			sprintf(filename, "statOutput_%s.csv", buff);
			statOutput = fopen(filename, "w");

			//fprintf(output, "_____________________________________________________________________________________________________________________________________________________________________________\n");
			//fprintf(output, " 	n		|	 	TimeStamp		 |		  CPU(p,q)		   |		CPU time		|		  GPU(p,q)		   |		  GPU time		|						Result		\n");

			// read n's out of file and calculate
			while ((fscanf(input, "%lld,", n)) != EOF) {
				// log n to output
				printf("%lld		", *n);
				//fprintf(output, "%lld		", *n);
				// log n to statOutput
				fprintf(statOutput, "%lld;", *n);
				//timestamp output
				//time_t nowtime = time(0);
				//strftime(buff, 25, "%Y-%m-%d %H:%M:%S", localtime(&nowtime));
				//printf("%s		", buff);
				//fprintf(output, "%s		", buff);
				// CPU calculation
				start = clock();
				pollard_p1_factorization(*n, p, q, primes, primes_length);
				end = clock();
				// log result of p and q
				printf("(C) p=%lld, q=%lld		", *p, *q);
				//fprintf(output, "(C) p=%lld, q=%lld		", *p, *q);
				cpuTime = (end - start) / (double) CLOCKS_PER_SEC;
				// log result of CPU and time
				printf("%lf Sekunden		", cpuTime);
				//fprintf(output, "%lf Sekunden		", cpuTime);
				// log CPU time to statOutput
				fprintf(statOutput, "%lf;", cpuTime);
				// GPU calculation
				start = clock();
				gpu_pollard_p1_factorization(*n, p, q, primes, primes_length);
				end = clock();
				// log result of p and q
				printf("(G) p=%lld, q=%lld		", *p, *q);
				//fprintf(output, "(G) p=%lld, q=%lld		", *p, *q);
				gpuTime = (end - start) / (double) CLOCKS_PER_SEC;
				// log result of GPU and time
				printf("%lf Sekunden		", gpuTime);
				//fprintf(output, "%lf Sekunden		", gpuTime);
				// log CPU time to statOutput
				fprintf(statOutput, "%lf;", gpuTime);
				// log result of CPU and GPU, calculate which is faster
				if (cpuTime > gpuTime) {
					printf("GPU %lf Sekunden | %lf mal schneller\n", cpuTime - gpuTime, cpuTime / gpuTime);
					//fprintf(output, "GPU %lf Sekunden | %lf mal schneller\n", cpuTime - gpuTime, cpuTime / gpuTime);
				} else {
					printf("CPU %lf Sekunden | %lf mal schneller\n", gpuTime - cpuTime, gpuTime / cpuTime);
					//fprintf(output, "CPU %lf Sekunden | %lf mal schneller\n", gpuTime - cpuTime, gpuTime / cpuTime);
				}
				fprintf(statOutput, "%lld;%lld;\n", *p, *q);
				printf("\n");
				//fprintf(output, "\n");

				//reset p and q just to be save
				*p = 1;
				*q = 1;
			}

			fclose(input);
			//fclose(output);
			fclose(statOutput);
		}
			break;
		default:
			isEnd = true;
			break;
		}
	}

	free(n);
	free(p);
	free(q);

	return 0;
}

void read_primes(unsigned long int *primes) {
	FILE *datei;
	unsigned long int prime;
	int count = 0;

	datei = fopen("primes.txt", "r");
	while ((fscanf(datei, "%lu,", &prime)) != EOF) {
		primes[count++] = prime;
	}
	fclose(datei);
}
