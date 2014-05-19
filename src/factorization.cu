#include "factorization.h"
#include "stdio.h"

void factorization(long long int n, long long int* p, long long int* q) {
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
