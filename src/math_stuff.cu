#include "math_stuff.h"

__int64 euclidean_gcd(__int64 a_in, __int64 b_in) {
	__int64 a = a_in;
	__int64 b = b_in;
	__int64 t, m;

	if (b > a) {
		t = a; a = b; b = t;
	}

	while (b != 0) {
		m = a % b;
		a = b;
		b = m;
	}

	return a;
}

__int64 power_mod(__int64 base, __int64 exponent, __int64 modulus) {
	__int64 i;
	__int64 number = base;

	for(i = 1; i < exponent; i++) {
		number = (number * base) % modulus;
	}

	return number;
}
