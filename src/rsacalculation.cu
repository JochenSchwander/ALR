#include "rsacalculation.h"

__int64 calculatePrivateKey(__int64 publicKey, __int64 primeOne, __int64 primeTwo) {
	__int64 phiN = (primeOne - 1) * (primeTwo - 1);
	__int64 a = publicKey;
	__int64 b = phiN;
	__int64 x = 1, y = 0;
	__int64 xLast = 0, yLast = 1;
	__int64 q, r, m, n;

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
