#include "rsacalculation.h"

long calculatePrivateKey(long e, long p, long q) {
	long phiN = (p - 1) * (q - 1);

	long a = e;
	long b = phiN;
	long x = 1, y = 0;
	long xLast = 0, yLast = 1;
	long q, r, m, n;

	while (a != 0) {
		q = b / a;
		r = b % a;
		m = xLast - q * x;
		n = yLast - q * y;
		xLast = x, yLast = y;
		x = m, y = n;
		b = a, a = r;
	}

	if (xLast < 0l) {
		xLast += phiN;
	}

	return xLast;
}
