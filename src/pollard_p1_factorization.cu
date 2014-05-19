#include "pollard_p1_factorization.h"
#include "math_stuff.h"
#include <math.h>


void pollard_p1_factorization(long long int n, long long int* p, long long int* q) {
	//TODO primzahlen datei einlesen + als array bereitstellen
	uint16_t *primes;
	uint16_t *primes_length;

	*p = pollard_p1_factor(n, primes, *primes_length);
	*q = n / *p;
}


long long int pollard_p1_factor(long long int n, uint16_t *primes, uint16_t primes_length) {
	long long int b_max = 1000000;
	long long int a_max = 1000;
	long long int b, e, p, i, a, g;

	for (a = 2; a < a_max; a++) {
		for (b = 2; b < b_max; b++) {
			//calculate e
			e = 1;
			for (i = 0; i < primes_length; i++) {
				p = primes[i];
				if (b <= p) {
					e *= power_mod(p, log((long double)b) / log((long double) p), n);
				} else {
					break;
				}
			}

			//check if g is a factor of n
			g = euclidean_gcd(power_mod(a, e - 1, n), n);
			if (g > 1) {
				if (g == n) {
					//found trivial factor n of n
					break;
				} else {
					//found a real factor of n
					return g;
				}
			}
		}
	}

	return n;
}
