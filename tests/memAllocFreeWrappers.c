#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define USE_MALLOC_WRAPPERS

#include "malloc_wrap.h"

#define SIZE 10
typedef int TYPE;

TYPE *srcArr1;
TYPE *srcArr2;
TYPE *sumArr;
TYPE *diffArr;
TYPE *sqrArr;

TYPE coeff = 2;

int nbytes;

void initVecs()
{
    int i;
    for(i = 0; i < SIZE; i++)
    {
        srcArr1[i]=i*5 + 7;
        srcArr2[i]=2*i - 3;
    }
}

void sumVecs()
{
    int i;
    for(i = 0; i < SIZE; i++)
    {
        sumArr[i] = srcArr1[i] + coeff * srcArr2[i];
    }
}

void diffVecs()
{
    int i;
    for(i = 0; i < SIZE; i++)
    {
        diffArr[i] = coeff * (srcArr1[i] - srcArr2[i]);
    }
}

TYPE SquareRootRounded(TYPE a_nInput)
{
    TYPE op  = a_nInput;
    TYPE res = 0;
    // The second-to-top bit is set: use 1u << 14 for uint16_t type;
    // use 1uL<<30 for TYPE type
    TYPE one = 1uL << 30;

    // "one" starts at the highest power of four <= than the argument.
    while (one > op)
        one >>= 2;

    while (one != 0)
    {
        if (op >= res + one)
        {
            op = op - (res + one);
            res = res +  2 * one;
        }
        res >>= 1;
        one >>= 2;
    }

    // Do arithmetic rounding to nearest integer
    if (op > res)
        res++;

    return res;
}

void sqrootVecs()
{
    int i;
    for(i = 0; i < SIZE; i++)
    {
        sqrArr[i] = SquareRootRounded( sqrArr[i] + diffArr[i] );
    }
}

int main()
{
    nbytes = SIZE*sizeof(TYPE);
    printf("Vector Operations Test.\n");
    printf("Total bytes : %d\n",nbytes);

    srcArr1 = calloc(nbytes/2, sizeof(TYPE) );
    printf("srcArr1 addr after calloc : %p\n",srcArr1);

    srcArr2 = calloc(nbytes, sizeof(TYPE) );
    printf("srcArr2 addr after malloc : %p\n",srcArr2);

    // Now we realloc to increase space for srcArr1
    srcArr1 = realloc(srcArr1, nbytes);
    printf("srcArr1 addr after realloc: %p\n",srcArr1);

    sumArr = malloc(nbytes);
    printf("sumArr addr after malloc : %p\n",sumArr);

#if 0
    diffArr = malloc(nbytes);
    printf("diffArr addr after malloc : %p\n",diffArr);
#else
    // The following realloc behaves like malloc
    diffArr = realloc(NULL, nbytes);
    printf("diffArr addr after realloc : %p\n",diffArr);
#endif

    sqrArr = malloc(nbytes);
    printf("sqrArr addr after malloc : %p\n",sqrArr);

    initVecs();
    sumVecs();
    diffVecs();
    sqrootVecs();

    printf("output : %d\n", sumArr[2]+diffArr[3]+sqrArr[4]);

    free(srcArr1);
    free(srcArr2);
    free(sumArr);
    free(diffArr);
    free(sqrArr);

    return 0;
}
