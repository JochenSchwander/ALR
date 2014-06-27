#include "pollard_p1_factorization.h"
#include "math_stuff.h"
#include <math.h>
#include <stdlib.h>

//#define DEBUG_POLLARD_P1
#ifdef DEBUG_POLLARD_P1
#include <stdio.h>
#endif


void pollard_p1_factorization(long long int n, long long int* p, long long int* q, unsigned long int *primes, unsigned long int primes_length) {
	*p = pollard_p1_factor(n, primes, primes_length);
	*q = n / *p;
}


long long int pollard_p1_factor(long long int n, unsigned long int *primes, unsigned long int primes_length) {
	long long int b, e, p, i, a, g;
	const long long int b_max = 1000000;

	for (a = 2; a < 1000; a++) {
		for (b = 2; b < b_max; b++) {
#ifdef DEBUG_POLLARD_P1
			printf("PP1: a = %lld, b = %lld, ", a, b);
#endif
			//calculate e
			e = a;
			for (i = 0; i < primes_length; i++) {
				p = (long long int) primes[i];
				if (b >= p) {
					e = power_mod(e, p, n);
				} else {
					break;
				}
			}
#ifdef DEBUG_POLLARD_P1
			printf("e = %lld, ", e);
#endif
			//check if g is a factor of n
			g = euclidean_gcd(e - 1, n);
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
