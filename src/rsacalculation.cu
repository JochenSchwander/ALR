#include "rsacalculation.h"

long long int calculatePrivateKey(long long int publicKey, long long int primeOne, long long int primeTwo) {
	long long int phiN = (primeOne - 1) * (primeTwo - 1);
	long long int a = publicKey;
	long long int b = phiN;
	long long int x = 1, y = 0;
	long long int xLast = 0, yLast = 1;
	long long int q, r, m, n;

	while (a != 0) {
		q = b / a;
		r = b % a;
		m = xLast - q * x;
		n = yLast - q * y;
		xLast = x, yLast = y;
		x = m, y = n;
		b = a, a = r;
	}

	if (xLast < 0) {
		xLast += phiN;
	}

	return xLast;
}
