#ifndef POLLARD_P1_FACTORIZATION_H
#define POLLARD_P1_FACTORIZATION_H

void pollard_p1_factorization(long long int n, long long int* p, long long int* q, unsigned long int *primes, unsigned long int primes_length);

long long int pollard_p1_factor(long long int n, unsigned long int *primes, unsigned long int primes_length);

#endif
