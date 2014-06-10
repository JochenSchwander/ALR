#include "pollard_p1_factorization.h"
#include "math_stuff.h"
#include <math.h>
#include <stdlib.h>

//#define DEBUG_POLLARD_P1
#ifdef DEBUG_POLLARD_P1
#include <stdio.h>
#endif

//#define POLLARD_P1_V2
#define POLLARD_P1_V1



void pollard_p1_factorization(long long int n, long long int* p, long long int* q, unsigned long int *primes, unsigned long int primes_length) {
	*p = pollard_p1_factor(n, primes, primes_length);
	*q = n / *p;
}


long long int pollard_p1_factor(long long int n, unsigned long int *primes, unsigned long int primes_length) {

	long long int b_max = 1000000;
	long long int a_max = 1000;
	long long int b, e, p, i, a, g;

	for (a = 2; a < a_max; a++) {
#ifdef DEBUG_POLLARD_P1
		printf("PP1: a = %lld\n", a);
#endif
		for (b = 2; b < b_max; b++) {
#ifdef DEBUG_POLLARD_P1
			printf("PP1: b = %lld, ", b);
#endif
			//calculate e
#ifdef POLLARD_P1_V2
			e = 1;
#endif
#ifdef POLLARD_P1_V1
			e = a;
#endif
			for (i = 0; i < primes_length; i++) {
				p = (long long int) primes[i];
				if (b >= p) {
#ifdef POLLARD_P1_V2
					e *= power_mod(p, log((long double)b) / log((long double) p), n);
#endif
#ifdef POLLARD_P1_V1
					e = power_mod(e, p, n);
#endif
				} else {
					break;
				}
			}
#ifdef DEBUG_POLLARD_P1
			printf("e = %lld, ", e);
#endif
			//check if g is a factor of n
#ifdef POLLARD_P1_V2
			g = euclidean_gcd(power_mod(a, e - 1, n), n);
#endif
#ifdef POLLARD_P1_V1
			g = euclidean_gcd(e - 1, n);
#endif
#ifdef DEBUG_POLLARD_P1
			printf("g = %lld\n", g);
#endif
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
