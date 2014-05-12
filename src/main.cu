#include "stdio.h"
#include "factorization.h"
#include "rsacalculation.h"

int main()
{
	long p, q, n, e, d;
	n = 989;
	e = 5;

	printf("n = %ld\n", n);
	factorization(n, &p, &q);

	printf("p = %ld; q = %ld\n", p, q);
	d = calculatePrivateKey(e,p,q);
	printf("d = %ld\n", d);

	return 0;
}
