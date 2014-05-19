#ifndef POLLARD_P1_FACTORIZATION_H
#define POLLARD_P1_FACTORIZATION_H

void pollard_p1_factorization(long long int n, long long int* p, long long int* q, unsigned int *primes, unsigned int primes_length);

long long int pollard_p1_factor(long long int n, unsigned int *primes, unsigned int primes_length);

#endif
