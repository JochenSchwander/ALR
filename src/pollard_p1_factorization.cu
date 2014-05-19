#include "pollard_p1_factorization.h"
#include "math_stuff.h"

//#define DEBUG_POLLARD_P1
#ifdef DEBUG_POLLARD_P1
#include <stdio.h>
#endif


void pollard_p1_factorization(long long int n, long long int* p, long long int* q) {
	*p = pollard_p1_factor(n);
	*q = n / *p;
}


long long int pollard_p1_factor(long long int n) {
	long long int bound = n / 2; //quadratwurzel oder anders kleiner?
	long long int a, i, mult, b;

	for (a = 2; a < bound; a++) {
#ifdef DEBUG_POLLARD_P1
		printf("a = %lld\n", a);
#endif
		mult = a;
		for (i = 1; i < bound; i++) {
#ifdef DEBUG_POLLARD_P1
			printf("i = %lld\n", i);
#endif
			mult = power_mod(mult, i, n);
#ifdef DEBUG_POLLARD_P1
			printf("mult = %lld\n", mult);
#endif
			b = euclidean_gcd(mult - 1, n);
#ifdef DEBUG_POLLARD_P1
			printf("b = %lld\n", b);
#endif
			if (b > 1) {
				if (b == n) {
					break;
				} else {
					return b;
				}
			}

		}
	}

	return n;
}
