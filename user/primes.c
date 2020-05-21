#include "kernel/syscall.h"
#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

// #include "stdio.h"
// #include "math.h"

int isPrime(int n)
{
    int i = 2;
    if (n == 1 || n == 2 || n == 3)
    {
        return 1;
    }

    for (i = 2; (i * i) <= n; ++i)
    {
        if (n % i == 0)
        {
            return 0;
        }
    }

    return 1;
}

int main(int argc, char const *argv[])
{
    if (argc > 1)
    {
        fprintf(2, "Usage: primes (no args) \n");
        exit(1);
    }

    // for (int i = 2; i < 35; ++i)
    // {
    //     if (isPrime(i))
    //         printf(" %d is prime no \n", i);
    // }

    return 0;
}
