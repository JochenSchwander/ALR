#include "gpu_pollard_p1_factorization.h"
#include "gpu_math_stuff.h"




void pollard_p1_factorization(long long int n, long long int* p, long long int* q) {
	
	
	
	//TODO
	*p = pollard_p1_factor(n);
	*q = n / *p;
}


__global__ long long int pollard_p1_factor(long long int n, long long int *factor, long long int a) {
	long long int bound = n / 2; //quadratwurzel oder anders kleiner?
	long long int a, i, mult, b;

	for (a = 2; a < bound; a++) {

		mult = a;
		for (i = 1; i < bound; i++) {

			mult = power_mod(mult, i, n);

			b = euclidean_gcd(mult - 1, n);

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
