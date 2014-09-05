#include <stdio.h>
#include <stdlib.h>

#define SIZE 10
typedef int uint32_t;

// unsigned int srcArr1[SIZE];
// unsigned int srcArr2[SIZE];
// unsigned int sqrArr[SIZE];
// unsigned int sumArr[SIZE];
// unsigned int diffArr[SIZE];
unsigned int *srcArr1;
unsigned int *srcArr2;
unsigned int *sqrArr;
unsigned int *sumArr;
unsigned int *diffArr;

unsigned int coeff = 2;

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

uint32_t SquareRootRounded(uint32_t a_nInput)
{
    uint32_t op  = a_nInput;
    uint32_t res = 0;
    uint32_t one = 1uL << 30; // The second-to-top bit is set: use 1u << 14 for uint16_t type; use 1uL<<30 for uint32_t type

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

    /* Do arithmetic rounding to nearest integer */
    if (op > res)
    {
        res++;
    }

    return res;
}

void sqrootVecs()
{
    int i;
    for(i = 0; i < SIZE; i++)
    {
        sqrArr[i] = SquareRootRounded( sumArr[i] );
        sqrArr[i] = SquareRootRounded( sqrArr[i] + diffArr[i] );
    }
}

int main()
{
    printf("Vector Operations Test.\n");
    char *dummy = malloc(1);
    dummy = calloc(1, sizeof(char) );
    dummy = realloc(dummy, 2);
    printf("Dummy malloc addr : %p\n", (void *)dummy );
    free(dummy);

    srcArr1 = calloc(SIZE/2 * sizeof(uint32_t), sizeof(uint32_t) );
    printf("srcArr1 addr after calloc : %p\n",srcArr1);

    srcArr2 = malloc(SIZE * sizeof(uint32_t));
    printf("srcArr2 addr : %p\n",srcArr2);

    srcArr1 = realloc(srcArr1, SIZE * sizeof(uint32_t));
    printf("srcArr1 addr after realloc: %p\n",srcArr1);

    sumArr = malloc(SIZE * sizeof(uint32_t));
    printf("sumArr addr : %p\n",sumArr);

    diffArr = malloc(SIZE * sizeof(uint32_t));
    printf("diffArr addr : %p\n",diffArr);

    sqrArr = malloc(SIZE * sizeof(uint32_t));
    printf("sqrArr addr : %p\n",sqrArr);

    initVecs();
    sumVecs();
//     diffVecs();
//     diffVecs();
    diffVecs();
    sqrootVecs();

//     printf("output : %d\n",sumArr[1]+diffArr[1]);
    printf("output : %d\n",sumArr[1]+diffArr[1]+sqrArr[1]);

    free(srcArr1);
    free(srcArr2);
    free(sumArr);
    free(diffArr);
    free(sqrArr);

    return 0;
}
