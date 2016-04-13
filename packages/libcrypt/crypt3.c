/**************************************************************************
*            Unix-like crypt(3) Algorithm for Password Encryption
*
*   File    : crypt3.c
*   Purpose : Provides crypt(3) functionality to ANSI C compilers
*             without a need for the crypt library.
*   Author  : Michael Dipperstein
*   Date    : November 3, 1998
*
***************************************************************************
*   The source in this file is heavily borrowed from the crypt3.c file
*   found on several ftp sites on the Internet.  The original source
*   claimed to be BSD, but was not distributed with any BSD license or
*   copyright claims.  I am releasing the source that I have provided into
*   public domain without any restrictions, warranties, or copyright
*   claims of my own.
*
*   The code below has been cleaned and compiles correctly under, gcc,
*   lcc, and Borland's bcc C compilers.  A bug involving the left and
*   right halves of the encrypted data block in the widely published
*   crypt3.c source has been fixed by this version.  All implicit register
*   declarations have been removed, because they generated suboptimal code.
*   All constant data has been explicitly declared as const and all
*   declarations have been given a minimal scope, because I'm paranoid.
*
*   Caution: crypt() returns a pointer to static data.  I left it this way
*            to maintain backward compatibility.  The downside is that
*            successive calls will cause previous results to be lost.
*            This can easily be changed with only minor modifications to
*            the function crypt().
**************************************************************************/

/* Initial permutation */
static const char IP[] =
{
    58, 50, 42, 34, 26, 18, 10, 2,
    60, 52, 44, 36, 28, 20, 12, 4,
    62, 54, 46, 38, 30, 22, 14, 6,
    64, 56, 48, 40, 32, 24, 16, 8,
    57, 49, 41, 33, 25, 17,  9, 1,
    59, 51, 43, 35, 27, 19, 11, 3,
    61, 53, 45, 37, 29, 21, 13, 5,
    63, 55, 47, 39, 31, 23, 15, 7,
};

/* Final permutation, FP = IP^(-1) */
static const char FP[] = {
    40, 8, 48, 16, 56, 24, 64, 32,
    39, 7, 47, 15, 55, 23, 63, 31,
    38, 6, 46, 14, 54, 22, 62, 30,
    37, 5, 45, 13, 53, 21, 61, 29,
    36, 4, 44, 12, 52, 20, 60, 28,
    35, 3, 43, 11, 51, 19, 59, 27,
    34, 2, 42, 10, 50, 18, 58, 26,
    33, 1, 41,  9, 49, 17, 57, 25,
};

/**************************************************************************
* Permuted-choice 1 from the key bits to yield C and D.
* Note that bits 8,16... are left out:
* They are intended for a parity check.
**************************************************************************/
static const char PC1_C[] =
{
    57, 49, 41, 33, 25, 17,  9,
     1, 58, 50, 42, 34, 26, 18,
    10,  2, 59, 51, 43, 35, 27,
    19, 11,  3, 60, 52, 44, 36,
};

static const char PC1_D[] =
{
    63, 55, 47, 39, 31, 23, 15,
     7, 62, 54, 46, 38, 30, 22,
    14,  6, 61, 53, 45, 37, 29,
    21, 13,  5, 28, 20, 12,  4,
};

/* Sequence of shifts used for the key schedule. */
static const char shifts[] =
    {1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1};

/**************************************************************************
* Permuted-choice 2, to pick out the bits from the CD array that generate
* the key schedule.
**************************************************************************/
static const char PC2_C[] =
{
    14, 17, 11, 24,  1,  5,
     3, 28, 15,  6, 21, 10,
    23, 19, 12,  4, 26,  8,
    16,  7, 27, 20, 13,  2,
};

static const char PC2_D[] =
{
    41, 52, 31, 37, 47, 55,
    30, 40, 51, 45, 33, 48,
    44, 49, 39, 56, 34, 53,
    46, 42, 50, 36, 29, 32,
};

/* The C and D arrays used to calculate the key schedule. */
static char C[28];
static char D[28];

/* The key schedule.  Generated from the key. */
static char KS[16][48];

/* The E bit-selection table. */
static char E[48];
static const char e2[] =
{
    32,  1,  2,  3,  4,  5,
     4,  5,  6,  7,  8,  9,
     8,  9, 10, 11, 12, 13,
    12, 13, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21,
    20, 21, 22, 23, 24, 25,
    24, 25, 26, 27, 28, 29,
    28, 29, 30, 31, 32,  1,
};

/**************************************************************************
* Function:    setkey
*
* Description: Set up the key schedule from the encryption key.
*
* Inputs:      char *key
*              pointer to 64 character array.  Each character represents a
*              bit in the key.
*
* Returns:     none
**************************************************************************/
void setkey(char *key)
{
    int i, j, k, temp;

    /**********************************************************************
    * First, generate C and D by permuting the key.  The low order bit of
    * each 8-bit char is not used, so C and D are only 28 bits apiece.
    **********************************************************************/
    for(i = 0; i < 28; i++)
    {
        C[i] = key[PC1_C[i] - 1];
        D[i] = key[PC1_D[i] - 1];
    }

    /**********************************************************************
    * To generate Ki, rotate C and D according to schedule and pick up a
    * permutation using PC2.
    **********************************************************************/
    for(i = 0; i < 16; i++)
    {
        /* rotate */
        for(k = 0; k < shifts[i]; k++)
        {
            temp = C[0];

            for(j = 0; j < 28 - 1; j++)
                C[j] = C[j+1];

            C[27] = temp;
            temp = D[0];
            for(j = 0; j < 28 - 1; j++)
                D[j] = D[j+1];

            D[27] = temp;
        }

        /* get Ki. Note C and D are concatenated */
        for(j = 0; j < 24; j++)
        {
            KS[i][j] = C[PC2_C[j] - 1];
            KS[i][j + 24] = D[PC2_D[j] - 28 -1];
        }
    }

    /* load E with the initial E bit selections */
    for(i=0; i < 48; i++)
        E[i] = e2[i];
}

/**************************************************************************
* The 8 selection functions. For some reason, they give a 0-origin
* index, unlike everything else.
**************************************************************************/

static const char S[8][64] =
{
    {
        14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
         0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
         4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
        15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13
    },

    {
        15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
         3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
         0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
        13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9
    },

    {
        10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
        13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
        13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
         1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12
    },

    {
         7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
        13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
        10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
         3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14
    },

    {
         2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
        14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
         4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
        11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3
    },

    {
        12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
        10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
         9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
         4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13
    },

    {
         4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
        13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
         1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
         6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12
    },

    {
        13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
         1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
         7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
         2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11
    }
};

/**************************************************************************
* P is a permutation on the selected combination of the current L and key.
**************************************************************************/
static const char P[] =
{
    16,  7, 20, 21,
    29, 12, 28, 17,
     1, 15, 23, 26,
     5, 18, 31, 10,
     2,  8, 24, 14,
    32, 27,  3,  9,
    19, 13, 30,  6,
    22, 11,  4, 25,
};

/* The combination of the key and the input, before selection. */
static char preS[48];

/**************************************************************************
* Function:    encrypt
*
* Description: Uses DES to encrypt a 64 bit block of data.  Requires
*              setkey to be invoked with the encryption key before it may
*              be used.  The results of the encryption are stored in block.
*
* Inputs:      char *block
*              pointer to 64 character array.  Each character represents a
*              bit in the data block.
*
* Returns:     none
**************************************************************************/
void encrypt(char *block)
{
    int i, ii, temp, j, k;

    char left[32], right[32]; /* block in two halves */
    char old[32];
    char f[32];

    /* First, permute the bits in the input */
    for(j = 0; j < 32; j++)
        left[j] = block[IP[j] - 1];

    for(;j < 64; j++)
        right[j - 32] = block[IP[j] - 1];

    /* Perform an encryption operation 16 times. */
    for(ii= 0; ii < 16; ii++)
    {
        i = ii;
        /* Save the right array, which will be the new left. */
        for(j = 0; j < 32; j++)
            old[j] = right[j];

        /******************************************************************
        * Expand right to 48 bits using the E selector and
        * exclusive-or with the current key bits.
        ******************************************************************/
        for(j =0 ; j < 48; j++)
            preS[j] = right[E[j] - 1] ^ KS[i][j];

        /******************************************************************
        * The pre-select bits are now considered in 8 groups of 6 bits ea.
        * The 8 selection functions map these 6-bit quantities into 4-bit
        * quantities and the results are permuted to make an f(R, K).
        * The indexing into the selection functions is peculiar;
        * it could be simplified by rewriting the tables.
        ******************************************************************/
        for(j = 0; j < 8; j++)
        {
            temp = 6 * j;
            k = S[j][(preS[temp + 0] << 5) +
                (preS[temp + 1] << 3) +
                (preS[temp + 2] << 2) +
                (preS[temp + 3] << 1) +
                (preS[temp + 4] << 0) +
                (preS[temp + 5] << 4)];

            temp = 4 * j;

            f[temp + 0] = (k >> 3) & 01;
            f[temp + 1] = (k >> 2) & 01;
            f[temp + 2] = (k >> 1) & 01;
            f[temp + 3] = (k >> 0) & 01;
        }

        /******************************************************************
        * The new right is left ^ f(R, K).
        * The f here has to be permuted first, though.
        ******************************************************************/
        for(j = 0; j < 32; j++)
            right[j] = left[j] ^ f[P[j] - 1];

        /* Finally, the new left (the original right) is copied back. */
        for(j = 0; j < 32; j++)
            left[j] = old[j];
    }

    /* The output left and right are reversed. */
    for(j = 0; j < 32; j++)
    {
        temp = left[j];
        left[j] = right[j];
        right[j] = temp;
    }

    /* The final output gets the inverse permutation of the very original. */
    for(j = 0; j < 64; j++)
    {
        i = FP[j];
        if (i < 33)
                block[j] = left[FP[j] - 1];
        else
                block[j] = right[FP[j] - 33];
    }
}

/**************************************************************************
* Function:    crypt
*
* Description: Clone of Unix crypt(3) function.
*
* Inputs:      char *pw
*              pointer to 8 character encryption key (user password)
*              char *salt
*              pointer to 2 character salt used to modify the DES results.
*
* Returns:     Pointer to static array containing the salt concatenated
*              on to the encrypted results.  Same as stored in passwd file.
**************************************************************************/
char *crypt(char *pw, char *salt)
{
    int i, j, temp;
    char c,
         block[66];             /* 1st store key, then results */
    static char iobuf[16];      /* encrypted results */

    for(i = 0; i < 66; i++)
        block[i] = 0;

    /* break pw into 64 bits */
    for(i = 0, c = *pw; c && (i < 64); i++)
    {
        for(j = 0; j < 7; j++, i++)
            block[i] = (c >> (6 - j)) & 01;
        pw++;
        c = *pw;
    }

    /* set key based on pw */
    setkey(block);

    for(i = 0; i < 66; i++)
        block[i] = 0;

    for(i = 0; i < 2; i++)
    {
        /* store salt at beginning of results */
        c = *salt++;
        iobuf[i] = c;

        if(c > 'Z')
            c -= 6;

        if(c > '9')
            c -= 7;

        c -= '.';

        /* use salt to effect the E-bit selection */
        for(j = 0; j < 6; j++)
        {
            if((c >> j) & 01)
            {
                temp = E[6 * i + j];
                E[6 * i +j] = E[6 * i + j + 24];
                E[6 * i + j + 24] = temp;
            }
        }
    }

    /* call DES encryption 25 times using pw as key and initial data = 0 */
    for(i = 0; i < 25; i++)
        encrypt(block);

    /* format encrypted block for standard crypt(3) output */
    for(i=0; i < 11; i++)
    {
        c = 0;
        for(j = 0; j < 6; j++)
        {
            c <<= 1;
            c |= block[6 * i + j];
        }

        c += '.';
        if(c > '9')
            c += 7;

        if(c > 'Z')
            c += 6;

        iobuf[i + 2] = c;
    }

    iobuf[i + 2] = '\0';

    /* prevent premature NULL terminator */
    if(iobuf[1] == '\0')
        iobuf[1] = iobuf[0];

    return(iobuf);
}
