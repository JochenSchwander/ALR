#include "pollard_p1_factorization.h"
#include "math_stuff.h"

//#define DEBUG_POLLARD_P1
#ifdef DEBUG_POLLARD_P1
#include <stdio.h>
#endif


void pollard_p1_factorization(__int64 n, __int64* p, __int64* q) {
	*p = pollard_p1_factor(n);
	*q = n / *p;
}


__int64 pollard_p1_factor(__int64 n) {
	__int64 bound = n / 2;
	__int64 a, i, mult, b;

	for (a = 2; a < bound; a++) {
#ifdef DEBUG_POLLARD_P1
		printf("a = %I64d\n", a);
#endif
		mult = a;
		for (i = 1; i < bound; i++) {
#ifdef DEBUG_POLLARD_P1
			printf("i = %I64d\n", i);
#endif
			mult = power_mod(mult, i, n);
#ifdef DEBUG_POLLARD_P1
			printf("mult = %I64d\n", mult);
#endif
			b = euclidean_gcd(mult - 1, n);
#ifdef DEBUG_POLLARD_P1
			printf("b = %I64d\n", b);
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
