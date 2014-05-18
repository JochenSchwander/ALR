#include "factorization.h"
#include "stdio.h"

void factorization(__int64 n, __int64* p, __int64* q) {
	int i , anz =0;
	for ( i =2; i <= n ; i++)
		while ( n % i == 0)
		{
			if (anz==0) {
				*p = i;
			} else {
				*q = i;
			}
			anz ++;
			n /= i ;
		}
}
