#include "stdio.h"
#include "factorization.h"

int main()
{
	printf("Hello, da du !\n");
	long p, q;
	factorization(989, &p, &q);

	printf("%ld * %ld", p, q);

	return 0;
}
