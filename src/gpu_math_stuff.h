#ifndef GPU_MATH_STUFF_H
#define GPU_MATH_STUFF_H

#include <cuda.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

//#define EUCLID_UNROLLED

__device__ inline long long int gpu_euclidean_gcd(long long int a, long long int b) {
#ifdef EUCLID_UNROLLED
	if (b > a) {
		goto euclidean_gcd_b_larger;
	}

	while(1) {
		a = a % b;
		if (a == 0) {
			return b;
		}
euclidean_gcd_b_larger:
		b = b % a;
		if (b == 0) {
			return a;
		}
	}
#else
	long long int t;

	if (b > a) {
		t = a; a = b; b = t;
	}

	while (b != 0) {
		t = a % b;
		a = b;
		b = t;
	}

	return a;
#endif
}

__device__ inline long long int gpu_binary_gcd(long long int u, long long int v) {
	long long int shift, t;

	/* GCD(0,v) == v; GCD(u,0) == u, GCD(0,0) == 0 */
	if (u == 0) {
		return v;
	}
	if (v == 0) {
		return u;
	}

	/* Let shift := lg K, where K is the greatest power of 2 dividing both u and v. */
	for (shift = 0; ((u | v) & 1) == 0; ++shift) {
		u >>= 1;
		v >>= 1;
	}

	while ((u & 1) == 0) {
		u >>= 1;
	}

	/* From here on, u is always odd. */
	do {
		/* remove all factors of 2 in v -- they are not common */
		/*   note: v is not zero, so while will terminate */
		while ((v & 1) == 0) { /* Loop X */
			v >>= 1;
		}

		/* Now u and v are both odd. Swap if necessary so u <= v,
		then set v = v - u (which is even). For bignums, the
		swapping is just pointer movement, and the subtraction
		can be done in-place. */
		if (u > v) {
			t = v; v = u; u = t; // Swap u and v.
		}  
		v = v - u; // Here v >= u.
	} while (v != 0);

	/* restore common factors of 2 */
	return u << shift;
}

__device__ inline long long int gpu_power_mod(long long int base, long long int exponent, long long int modulus) {
	long long int i;
	long long int number = base;

	for(i = 1; i < exponent; i++) {
		number *= base;

		//so not every time a modulus is used, when unneeded
		if (number >= modulus) {
			number %= modulus;
		}
	}

	return number;
}

#endif
