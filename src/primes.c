#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>


int main(void) {
	int primes_length = 78499;

	unsigned int *primes = (uint16_t *) malloc(sizeof(unsigned int ) * primes_length);
	FILE *datei;
	unsigned int  prime;
	int count = 0;
	/* Zum Lesen šffnen */
	datei = fopen("src/primzahlenbis1millionen.txt", "r");
	while ((fscanf(datei, "%d,", &prime)) != EOF) {
		primes[count++] = prime;
	}
	fclose(datei);

// Loop over strings
	for (int i = 0; i < 78498; i++) {
		printf("%d \n", primes[i]);
	}

	return 0;
}

