#include "string.h"
#include "stdio.h"
#include "unistd.h"
#include <sys/fcntl.h>
#include "3Des.h"


#define		rt_memcpy		memcpy


#define EN0   0      /* MODE == encrypt */
#define DE1   1      /* MODE == decrypt */

typedef struct {
    unsigned long ek[32];
    unsigned long dk[32];
} des_ctx;

extern void deskey(unsigned char *, short);
/*                  hexkey[8]     MODE
 * Sets the internal key register according to the hexadecimal
 * key contained in the 8 bytes of hexkey, according to the DES,
 * for encryption or decryption according to MODE.
 */

extern void usekey(unsigned long *);
/*                cookedkey[32]
 * Loads the internal key register with the data in cookedkey.
 */

extern void cpkey(unsigned long *);
/*               cookedkey[32]
 * Copies the contents of the internal key register into the storage
 * located at &cookedkey[0].
 */

extern void des(unsigned char *, unsigned char *);
/*                from[8]         to[8]
 * Encrypts/Decrypts (according to the key currently loaded in the
 * internal key register) one block of eight bytes at address 'from'
 * into the block at address 'to'.  They can be the same.
 */

static void scrunch(unsigned char *, unsigned long *);
static void unscrun(unsigned long *, unsigned char *);
static void desfunc(unsigned long *, unsigned long *);
static void cookey(unsigned long *);

static unsigned long KnL[32] = { 0L };
const unsigned short bytebit[8]    = {
    0200, 0100, 040, 020, 010, 04, 02, 01 };

const unsigned long bigbyte[24] = {
    0x800000L,    0x400000L,     0x200000L,    0x100000L,
    0x80000L,     0x40000L,      0x20000L,     0x10000L,
    0x8000L,      0x4000L,       0x2000L,      0x1000L,
    0x800L,              0x400L,               0x200L,              0x100L,
    0x80L,               0x40L,                0x20L,               0x10L,
    0x8L,         0x4L,          0x2L,         0x1L   };

/* Use the key schedule specified in the Standard (ANSI X3.92-1981). */

const unsigned char pc1[56] = {
    56, 48, 40, 32, 24, 16,  8,   0, 57, 49, 41, 33, 25, 17,
    9,  1, 58, 50, 42, 34, 26,  18, 10,  2, 59, 51, 43, 35,
    62, 54, 46, 38, 30, 22, 14,   6, 61, 53, 45, 37, 29, 21,
    13,  5, 60, 52, 44, 36, 28,  20, 12,  4, 27, 19, 11,  3 };

const unsigned char totrot[16] = {
    1,2,4,6,8,10,12,14,15,17,19,21,23,25,27,28 };

const unsigned char pc2[48] = {
    13, 16, 10, 23,  0,  4,       2, 27, 14,  5, 20,  9,
    22, 18, 11,  3, 25,  7,      15,  6, 26, 19, 12,  1,
    40, 51, 30, 36, 46, 54,      29, 39, 50, 44, 32, 47,
    43, 48, 38, 55, 33, 52,      45, 41, 49, 35, 28, 31 };

void deskey(unsigned char *key, short edf)  {
    /* Thanks to James Gillogly & Phil Karn! */
    register int i, j, l, m, n;
    unsigned char pc1m[56], pcr[56];
    unsigned long kn[32];
    
    for ( j = 0; j < 56; j++ ) {
        l = pc1[j];
        m = l & 07;
        pc1m[j] = (key[l >> 3] & bytebit[m]) ? 1 : 0;
    }
    for( i = 0; i < 16; i++ ) {
        if( edf == DE1 ) m = (15 - i) << 1;
        else             m = i << 1;
        n = m + 1;
        kn[m] = kn[n] = 0L;
        for( j = 0; j < 28; j++ ) {
            l = j + totrot[i];
            if( l < 28 ) pcr[j] = pc1m[l];
            else pcr[j] = pc1m[l - 28];
        }
        for( j = 28; j < 56; j++ ) {
            l = j + totrot[i];
            if( l < 56 ) pcr[j] = pc1m[l];
            else         pcr[j] = pc1m[l - 28];
        }
        for( j = 0; j < 24; j++ ) {
            if( pcr[pc2[j]] )    kn[m] |= bigbyte[j];
            if( pcr[pc2[j+24]] ) kn[n] |= bigbyte[j];
        }
    }
    cookey(kn);
}

static void cookey(unsigned long *raw1)
{
    register unsigned long *cook, *raw0;
    unsigned long dough[32];
    register int i;
    
    cook = dough;
    for( i = 0; i < 16; i++, raw1++ )
    {
        raw0 = raw1++;
        *cook   = (*raw0 & 0x00fc0000L) << 6;
        *cook  |= (*raw0 & 0x00000fc0L) << 10;
        *cook  |= (*raw1 & 0x00fc0000L) >> 10;
        *cook++|= (*raw1 & 0x00000fc0L) >> 6;
        *cook   = (*raw0 & 0x0003f000L) << 12;
        *cook  |= (*raw0 & 0x0000003fL) << 16;
        *cook  |= (*raw1 & 0x0003f000L) >> 4;
        *cook++       |= (*raw1 & 0x0000003fL);
    }
    usekey(dough);
}

void cpkey(unsigned long *into)
{
    register unsigned long *from, *endp;
    
    from = KnL, endp = &KnL[32];
    while( from < endp )
        *into++ = *from++;
}

void usekey(unsigned long *from)
{
    register unsigned long *to, *endp;
    
    to = KnL, endp = &KnL[32];
    while( to < endp )
        *to++ = *from++;
}

static void scrunch(unsigned char *outof, unsigned long *into)
{
    *into   = (*outof++ & 0xffL) << 24;
    *into  |= (*outof++ & 0xffL) << 16;
    *into  |= (*outof++ & 0xffL) << 8;
    *into++ |= (*outof++ & 0xffL);
    *into   = (*outof++ & 0xffL) << 24;
    *into  |= (*outof++ & 0xffL) << 16;
    *into  |= (*outof++ & 0xffL) << 8;
    *into  |= (*outof   & 0xffL);
}

static void unscrun(unsigned long *outof, unsigned char *into)
{
    *into++ = (*outof >> 24) & 0xffL;
    *into++ = (*outof >> 16) & 0xffL;
    *into++ = (*outof >>  8) & 0xffL;
    *into++ =  *outof++      & 0xffL;
    *into++ = (*outof >> 24) & 0xffL;
    *into++ = (*outof >> 16) & 0xffL;
    *into++ = (*outof >>  8) & 0xffL;
    *into   =  *outof     & 0xffL;
}

const unsigned long SP1[64] = {
    0x01010400L, 0x00000000L, 0x00010000L, 0x01010404L,
    0x01010004L, 0x00010404L, 0x00000004L, 0x00010000L,
    0x00000400L, 0x01010400L, 0x01010404L, 0x00000400L,
    0x01000404L, 0x01010004L, 0x01000000L, 0x00000004L,
    0x00000404L, 0x01000400L, 0x01000400L, 0x00010400L,
    0x00010400L, 0x01010000L, 0x01010000L, 0x01000404L,
    0x00010004L, 0x01000004L, 0x01000004L, 0x00010004L,
    0x00000000L, 0x00000404L, 0x00010404L, 0x01000000L,
    0x00010000L, 0x01010404L, 0x00000004L, 0x01010000L,
    0x01010400L, 0x01000000L, 0x01000000L, 0x00000400L,
    0x01010004L, 0x00010000L, 0x00010400L, 0x01000004L,
    0x00000400L, 0x00000004L, 0x01000404L, 0x00010404L,
    0x01010404L, 0x00010004L, 0x01010000L, 0x01000404L,
    0x01000004L, 0x00000404L, 0x00010404L, 0x01010400L,
    0x00000404L, 0x01000400L, 0x01000400L, 0x00000000L,
    0x00010004L, 0x00010400L, 0x00000000L, 0x01010004L };

const unsigned long SP2[64] = {
    0x80108020L, 0x80008000L, 0x00008000L, 0x00108020L,
    0x00100000L, 0x00000020L, 0x80100020L, 0x80008020L,
    0x80000020L, 0x80108020L, 0x80108000L, 0x80000000L,
    0x80008000L, 0x00100000L, 0x00000020L, 0x80100020L,
    0x00108000L, 0x00100020L, 0x80008020L, 0x00000000L,
    0x80000000L, 0x00008000L, 0x00108020L, 0x80100000L,
    0x00100020L, 0x80000020L, 0x00000000L, 0x00108000L,
    0x00008020L, 0x80108000L, 0x80100000L, 0x00008020L,
    0x00000000L, 0x00108020L, 0x80100020L, 0x00100000L,
    0x80008020L, 0x80100000L, 0x80108000L, 0x00008000L,
    0x80100000L, 0x80008000L, 0x00000020L, 0x80108020L,
    0x00108020L, 0x00000020L, 0x00008000L, 0x80000000L,
    0x00008020L, 0x80108000L, 0x00100000L, 0x80000020L,
    0x00100020L, 0x80008020L, 0x80000020L, 0x00100020L,
    0x00108000L, 0x00000000L, 0x80008000L, 0x00008020L,
    0x80000000L, 0x80100020L, 0x80108020L, 0x00108000L };

const unsigned long SP3[64] = {
    0x00000208L, 0x08020200L, 0x00000000L, 0x08020008L,
    0x08000200L, 0x00000000L, 0x00020208L, 0x08000200L,
    0x00020008L, 0x08000008L, 0x08000008L, 0x00020000L,
    0x08020208L, 0x00020008L, 0x08020000L, 0x00000208L,
    0x08000000L, 0x00000008L, 0x08020200L, 0x00000200L,
    0x00020200L, 0x08020000L, 0x08020008L, 0x00020208L,
    0x08000208L, 0x00020200L, 0x00020000L, 0x08000208L,
    0x00000008L, 0x08020208L, 0x00000200L, 0x08000000L,
    0x08020200L, 0x08000000L, 0x00020008L, 0x00000208L,
    0x00020000L, 0x08020200L, 0x08000200L, 0x00000000L,
    0x00000200L, 0x00020008L, 0x08020208L, 0x08000200L,
    0x08000008L, 0x00000200L, 0x00000000L, 0x08020008L,
    0x08000208L, 0x00020000L, 0x08000000L, 0x08020208L,
    0x00000008L, 0x00020208L, 0x00020200L, 0x08000008L,
    0x08020000L, 0x08000208L, 0x00000208L, 0x08020000L,
    0x00020208L, 0x00000008L, 0x08020008L, 0x00020200L };

const unsigned long SP4[64] = {
    0x00802001L, 0x00002081L, 0x00002081L, 0x00000080L,
    0x00802080L, 0x00800081L, 0x00800001L, 0x00002001L,
    0x00000000L, 0x00802000L, 0x00802000L, 0x00802081L,
    0x00000081L, 0x00000000L, 0x00800080L, 0x00800001L,
    0x00000001L, 0x00002000L, 0x00800000L, 0x00802001L,
    0x00000080L, 0x00800000L, 0x00002001L, 0x00002080L,
    0x00800081L, 0x00000001L, 0x00002080L, 0x00800080L,
    0x00002000L, 0x00802080L, 0x00802081L, 0x00000081L,
    0x00800080L, 0x00800001L, 0x00802000L, 0x00802081L,
    0x00000081L, 0x00000000L, 0x00000000L, 0x00802000L,
    0x00002080L, 0x00800080L, 0x00800081L, 0x00000001L,
    0x00802001L, 0x00002081L, 0x00002081L, 0x00000080L,
    0x00802081L, 0x00000081L, 0x00000001L, 0x00002000L,
    0x00800001L, 0x00002001L, 0x00802080L, 0x00800081L,
    0x00002001L, 0x00002080L, 0x00800000L, 0x00802001L,
    0x00000080L, 0x00800000L, 0x00002000L, 0x00802080L };

const unsigned long SP5[64] = {
    0x00000100L, 0x02080100L, 0x02080000L, 0x42000100L,
    0x00080000L, 0x00000100L, 0x40000000L, 0x02080000L,
    0x40080100L, 0x00080000L, 0x02000100L, 0x40080100L,
    0x42000100L, 0x42080000L, 0x00080100L, 0x40000000L,
    0x02000000L, 0x40080000L, 0x40080000L, 0x00000000L,
    0x40000100L, 0x42080100L, 0x42080100L, 0x02000100L,
    0x42080000L, 0x40000100L, 0x00000000L, 0x42000000L,
    0x02080100L, 0x02000000L, 0x42000000L, 0x00080100L,
    0x00080000L, 0x42000100L, 0x00000100L, 0x02000000L,
    0x40000000L, 0x02080000L, 0x42000100L, 0x40080100L,
    0x02000100L, 0x40000000L, 0x42080000L, 0x02080100L,
    0x40080100L, 0x00000100L, 0x02000000L, 0x42080000L,
    0x42080100L, 0x00080100L, 0x42000000L, 0x42080100L,
    0x02080000L, 0x00000000L, 0x40080000L, 0x42000000L,
    0x00080100L, 0x02000100L, 0x40000100L, 0x00080000L,
    0x00000000L, 0x40080000L, 0x02080100L, 0x40000100L };

const unsigned long SP6[64] = {
    0x20000010L, 0x20400000L, 0x00004000L, 0x20404010L,
    0x20400000L, 0x00000010L, 0x20404010L, 0x00400000L,
    0x20004000L, 0x00404010L, 0x00400000L, 0x20000010L,
    0x00400010L, 0x20004000L, 0x20000000L, 0x00004010L,
    0x00000000L, 0x00400010L, 0x20004010L, 0x00004000L,
    0x00404000L, 0x20004010L, 0x00000010L, 0x20400010L,
    0x20400010L, 0x00000000L, 0x00404010L, 0x20404000L,
    0x00004010L, 0x00404000L, 0x20404000L, 0x20000000L,
    0x20004000L, 0x00000010L, 0x20400010L, 0x00404000L,
    0x20404010L, 0x00400000L, 0x00004010L, 0x20000010L,
    0x00400000L, 0x20004000L, 0x20000000L, 0x00004010L,
    0x20000010L, 0x20404010L, 0x00404000L, 0x20400000L,
    0x00404010L, 0x20404000L, 0x00000000L, 0x20400010L,
    0x00000010L, 0x00004000L, 0x20400000L, 0x00404010L,
    0x00004000L, 0x00400010L, 0x20004010L, 0x00000000L,
    0x20404000L, 0x20000000L, 0x00400010L, 0x20004010L };

const unsigned long SP7[64] = {
    0x00200000L, 0x04200002L, 0x04000802L, 0x00000000L,
    0x00000800L, 0x04000802L, 0x00200802L, 0x04200800L,
    0x04200802L, 0x00200000L, 0x00000000L, 0x04000002L,
    0x00000002L, 0x04000000L, 0x04200002L, 0x00000802L,
    0x04000800L, 0x00200802L, 0x00200002L, 0x04000800L,
    0x04000002L, 0x04200000L, 0x04200800L, 0x00200002L,
    0x04200000L, 0x00000800L, 0x00000802L, 0x04200802L,
    0x00200800L, 0x00000002L, 0x04000000L, 0x00200800L,
    0x04000000L, 0x00200800L, 0x00200000L, 0x04000802L,
    0x04000802L, 0x04200002L, 0x04200002L, 0x00000002L,
    0x00200002L, 0x04000000L, 0x04000800L, 0x00200000L,
    0x04200800L, 0x00000802L, 0x00200802L, 0x04200800L,
    0x00000802L, 0x04000002L, 0x04200802L, 0x04200000L,
    0x00200800L, 0x00000000L, 0x00000002L, 0x04200802L,
    0x00000000L, 0x00200802L, 0x04200000L, 0x00000800L,
    0x04000002L, 0x04000800L, 0x00000800L, 0x00200002L };

const unsigned long SP8[64] = {
    0x10001040L, 0x00001000L, 0x00040000L, 0x10041040L,
    0x10000000L, 0x10001040L, 0x00000040L, 0x10000000L,
    0x00040040L, 0x10040000L, 0x10041040L, 0x00041000L,
    0x10041000L, 0x00041040L, 0x00001000L, 0x00000040L,
    0x10040000L, 0x10000040L, 0x10001000L, 0x00001040L,
    0x00041000L, 0x00040040L, 0x10040040L, 0x10041000L,
    0x00001040L, 0x00000000L, 0x00000000L, 0x10040040L,
    0x10000040L, 0x10001000L, 0x00041040L, 0x00040000L,
    0x00041040L, 0x00040000L, 0x10041000L, 0x00001000L,
    0x00000040L, 0x10040040L, 0x00001000L, 0x00041040L,
    0x10001000L, 0x00000040L, 0x10000040L, 0x10040000L,
    0x10040040L, 0x10000000L, 0x00040000L, 0x10001040L,
    0x00000000L, 0x10041040L, 0x00040040L, 0x10000040L,
    0x10040000L, 0x10001000L, 0x10001040L, 0x00000000L,
    0x10041040L, 0x00041000L, 0x00041000L, 0x00001040L,
    0x00001040L, 0x00040040L, 0x10000000L, 0x10041000L };

static void desfunc(unsigned long *block, unsigned long *keys)
{
    register unsigned long fval, work, right, leftt;
    register int round;
    
    leftt = block[0];
    right = block[1];
    work = ((leftt >> 4) ^ right) & 0x0f0f0f0fL;
    right ^= work;
    leftt ^= (work << 4);
    work = ((leftt >> 16) ^ right) & 0x0000ffffL;
    right ^= work;
    leftt ^= (work << 16);
    work = ((right >> 2) ^ leftt) & 0x33333333L;
    leftt ^= work;
    right ^= (work << 2);
    work = ((right >> 8) ^ leftt) & 0x00ff00ffL;
    leftt ^= work;
    right ^= (work << 8);
    right = ((right << 1) | ((right >> 31) & 1L)) & 0xffffffffL;
    work = (leftt ^ right) & 0xaaaaaaaaL;
    leftt ^= work;
    right ^= work;
    leftt = ((leftt << 1) | ((leftt >> 31) & 1L)) & 0xffffffffL;
    
    for( round = 0; round < 8; round++ )
    {
        work  = (right << 28) | (right >> 4);
        work ^= *keys++;
        fval  = SP7[ work             & 0x3fL];
        fval |= SP5[(work >>  8) & 0x3fL];
        fval |= SP3[(work >> 16) & 0x3fL];
        fval |= SP1[(work >> 24) & 0x3fL];
        work  = right ^ *keys++;
        fval |= SP8[ work             & 0x3fL];
        fval |= SP6[(work >>  8) & 0x3fL];
        fval |= SP4[(work >> 16) & 0x3fL];
        fval |= SP2[(work >> 24) & 0x3fL];
        leftt ^= fval;
        work  = (leftt << 28) | (leftt >> 4);
        work ^= *keys++;
        fval  = SP7[ work             & 0x3fL];
        fval |= SP5[(work >>  8) & 0x3fL];
        fval |= SP3[(work >> 16) & 0x3fL];
        fval |= SP1[(work >> 24) & 0x3fL];
        work  = leftt ^ *keys++;
        fval |= SP8[ work             & 0x3fL];
        fval |= SP6[(work >>  8) & 0x3fL];
        fval |= SP4[(work >> 16) & 0x3fL];
        fval |= SP2[(work >> 24) & 0x3fL];
        right ^= fval;
    }
    
    right = (right << 31) | (right >> 1);
    work = (leftt ^ right) & 0xaaaaaaaaL;
    leftt ^= work;
    right ^= work;
    leftt = (leftt << 31) | (leftt >> 1);
    work = ((leftt >> 8) ^ right) & 0x00ff00ffL;
    right ^= work;
    leftt ^= (work << 8);
    work = ((leftt >> 2) ^ right) & 0x33333333L;
    right ^= work;
    leftt ^= (work << 2);
    work = ((right >> 16) ^ leftt) & 0x0000ffffL;
    leftt ^= work;
    right ^= (work << 16);
    work = ((right >> 4) ^ leftt) & 0x0f0f0f0fL;
    leftt ^= work;
    right ^= (work << 4);
    *block++ = right;
    *block = leftt;
}

/* Validation sets:
 *
 * Single-length key, single-length plaintext -
 * Key    : 0123 4567 89ab cdef
 * Plain  : 0123 4567 89ab cde7
 * Cipher : c957 4425 6a5e d31d
 *
 **********************************************************************/

void des_key(des_ctx *dc, unsigned char *key)
{
    deskey(key,EN0);
    cpkey(dc->ek);
    deskey(key,DE1);
    cpkey(dc->dk);
}

/* Encrypt several blocks in ECB mode.  Caller is responsible for
 short blocks. */
void des_enc(des_ctx *dc, unsigned char *Data)//, int blocks)
{
    unsigned long work[2];
    
    scrunch(Data,work);
    desfunc(work,dc->ek);
    unscrun(work,Data);
}

void des_dec(des_ctx *dc, unsigned char *Data)//, int blocks)
{
    unsigned long work[2];
    
    scrunch(Data,work);
    desfunc(work,dc->dk);
    unscrun(work,Data);
}

const unsigned char MINI_TCP_KEY[8] = {'k','a','e','r','0','0','0','6'};	//kaer0006
void MsgDesEncrypt(uint8 *src,uint16 len)
{
    uint16 n;
    uint8 buf[8];
    des_ctx dc;
    
    des_key(&dc,(unsigned char*)MINI_TCP_KEY);
    
    for (n = 0;n < (len>>3);n ++)
    {
        rt_memcpy(buf,&src[n<<3],8);
        des_enc(&dc,buf);
        rt_memcpy(&src[n<<3],buf,8);
    }
}


void MsgDesDecrypt(uint8 *src,uint16 len)
{
    uint16 n;
    uint8 buf[8];
    des_ctx dc;
    
    des_key(&dc,(unsigned char*)MINI_TCP_KEY);
    
    for (n = 0;n < (len>>3);n ++)
    {
        rt_memcpy(buf,&src[n<<3],8);
        des_dec(&dc,buf);
        rt_memcpy(&src[n<<3],buf,8);
    }
}

void Des_PsamEncrypt(uint8 *key,uint8 *encrypt_data)
{
    des_ctx dc;
    
    des_key(&dc,key);
    des_enc(&dc,encrypt_data);
}


//--------------------------------------------------------------------------
//π¶ƒ‹√Ë ˆ: 3desº”√‹‘ÀÀ„
// ‰»Î    : src –Ë“™º”√‹µƒ ˝æ›£¨dst º”√‹∫Ûµƒ ˝æ›   key 16◊÷Ω⁄√‹‘ø
// ‰≥ˆ    :
//--------------------------------------------------------------------------
void Des3_Encrypt(uint8 *src, uint8 *dst, uint16 src_len,uint8 *key)
{
    
    des_ctx dc_first;
    des_ctx dc_second;
    uint8 buf[8];
    int n;
    
    des_key(&dc_first,key);
    des_key(&dc_second,&key[8]);
    
    for (n = 0;n < (src_len>>3);n ++)
    {
        rt_memcpy(buf,&src[n<<3],8);
        
        des_enc(&dc_first,buf);
        des_dec(&dc_second,buf);
        des_enc(&dc_first,buf);
        
        rt_memcpy(&dst[n<<3],buf,8);
    }
}

//--------------------------------------------------------------------------
//π¶ƒ‹√Ë ˆ: 3desΩ‚√‹‘ÀÀ„
// ‰»Î    : src –Ë“™Ω‚√‹µƒ ˝æ›£¨dst Ω‚√‹∫Ûµƒ ˝æ›   key 16◊÷Ω⁄√‹‘ø
// ‰≥ˆ    :
//--------------------------------------------------------------------------
void Des3_Decrypt(uint8 *src, uint8 *dst, uint16 src_len,uint8 *key)
{
    
    des_ctx dc_first;
    des_ctx dc_second;
    uint8 buf[8];
    int n;
    
    des_key(&dc_first,key);
    des_key(&dc_second,&key[8]);
    
    for (n = 0;n < (src_len>>3);n ++)
    {
        rt_memcpy(buf,&src[n<<3],8);
        
        des_dec(&dc_first,buf);
        des_enc(&dc_second,buf);
        des_dec(&dc_first,buf);
        
        rt_memcpy(&dst[n<<3],buf,8);
    }
}

uint16 crc16_ccitt_table[] =
{
    0x0000, 0x1189, 0x2312, 0x329b, 0x4624, 0x57ad, 0x6536, 0x74bf,
    0x8c48, 0x9dc1, 0xaf5a, 0xbed3, 0xca6c, 0xdbe5, 0xe97e, 0xf8f7,
    0x1081, 0x0108, 0x3393, 0x221a, 0x56a5, 0x472c, 0x75b7, 0x643e,
    0x9cc9, 0x8d40, 0xbfdb, 0xae52, 0xdaed, 0xcb64, 0xf9ff, 0xe876,
    0x2102, 0x308b, 0x0210, 0x1399, 0x6726, 0x76af, 0x4434, 0x55bd,
    0xad4a, 0xbcc3, 0x8e58, 0x9fd1, 0xeb6e, 0xfae7, 0xc87c, 0xd9f5,
    0x3183, 0x200a, 0x1291, 0x0318, 0x77a7, 0x662e, 0x54b5, 0x453c,
    0xbdcb, 0xac42, 0x9ed9, 0x8f50, 0xfbef, 0xea66, 0xd8fd, 0xc974,
    0x4204, 0x538d, 0x6116, 0x709f, 0x0420, 0x15a9, 0x2732, 0x36bb,
    0xce4c, 0xdfc5, 0xed5e, 0xfcd7, 0x8868, 0x99e1, 0xab7a, 0xbaf3,
    0x5285, 0x430c, 0x7197, 0x601e, 0x14a1, 0x0528, 0x37b3, 0x263a,
    0xdecd, 0xcf44, 0xfddf, 0xec56, 0x98e9, 0x8960, 0xbbfb, 0xaa72,
    0x6306, 0x728f, 0x4014, 0x519d, 0x2522, 0x34ab, 0x0630, 0x17b9,
    0xef4e, 0xfec7, 0xcc5c, 0xddd5, 0xa96a, 0xb8e3, 0x8a78, 0x9bf1,
    0x7387, 0x620e, 0x5095, 0x411c, 0x35a3, 0x242a, 0x16b1, 0x0738,
    0xffcf, 0xee46, 0xdcdd, 0xcd54, 0xb9eb, 0xa862, 0x9af9, 0x8b70,
    0x8408, 0x9581, 0xa71a, 0xb693, 0xc22c, 0xd3a5, 0xe13e, 0xf0b7,
    0x0840, 0x19c9, 0x2b52, 0x3adb, 0x4e64, 0x5fed, 0x6d76, 0x7cff,
    0x9489, 0x8500, 0xb79b, 0xa612, 0xd2ad, 0xc324, 0xf1bf, 0xe036,
    0x18c1, 0x0948, 0x3bd3, 0x2a5a, 0x5ee5, 0x4f6c, 0x7df7, 0x6c7e,
    0xa50a, 0xb483, 0x8618, 0x9791, 0xe32e, 0xf2a7, 0xc03c, 0xd1b5,
    0x2942, 0x38cb, 0x0a50, 0x1bd9, 0x6f66, 0x7eef, 0x4c74, 0x5dfd,
    0xb58b, 0xa402, 0x9699, 0x8710, 0xf3af, 0xe226, 0xd0bd, 0xc134,
    0x39c3, 0x284a, 0x1ad1, 0x0b58, 0x7fe7, 0x6e6e, 0x5cf5, 0x4d7c,
    0xc60c, 0xd785, 0xe51e, 0xf497, 0x8028, 0x91a1, 0xa33a, 0xb2b3,
    0x4a44, 0x5bcd, 0x6956, 0x78df, 0x0c60, 0x1de9, 0x2f72, 0x3efb,
    0xd68d, 0xc704, 0xf59f, 0xe416, 0x90a9, 0x8120, 0xb3bb, 0xa232,
    0x5ac5, 0x4b4c, 0x79d7, 0x685e, 0x1ce1, 0x0d68, 0x3ff3, 0x2e7a,
    0xe70e, 0xf687, 0xc41c, 0xd595, 0xa12a, 0xb0a3, 0x8238, 0x93b1,
    0x6b46, 0x7acf, 0x4854, 0x59dd, 0x2d62, 0x3ceb, 0x0e70, 0x1ff9,
    0xf78f, 0xe606, 0xd49d, 0xc514, 0xb1ab, 0xa022, 0x92b9, 0x8330,
    0x7bc7, 0x6a4e, 0x58d5, 0x495c, 0x3de3, 0x2c6a, 0x1ef1, 0x0f78
};

//CCITT CRC16
short crc_checksum(uint8* message, int len)
{
    short crc_reg = 0;
    int i;
    
    for (i = 0;i < len;i ++){
        crc_reg = (crc_reg >> 8) ^ crc16_ccitt_table[(crc_reg ^ message[i]) & 0xff];
        crc_reg &= 0xffff;
    }
    
    return (short)crc_reg;
} 

/*
 int main(void)
 {	
	
	//u8 src_data[] = {0x06,0x00,0x00,0x00,0x01,0x53};
	
	//crc_checksum(src_data,6);
	
	u8 src_data[] = {0xdc ,0x2c ,0x26 ,0x12 ,0x22 ,0x35 ,0x22 ,0x35,
 0x35,0x22,0x35,0x22,0x12,0x26,0x2c,0xdc};
	
	u8 temp_data[16];
	
	u8 key[] = {'s','h','a','n','d','o','n','g','k','a','e','r','t','e','c','h'};
	u8 dst_data[16];
	
	Des3_Encrypt(src_data,dst_data,8,key);
	
	printf("encrypt  = %02x %02x %02x %02x %02x %02x %02x %02x\r\n",dst_data[0],dst_data[1],dst_data[2],dst_data[3],dst_data[4],dst_data[5],dst_data[6],dst_data[7]);
	
	
	Des3_Encrypt(&src_data[8],temp_data,8,key);
	
	printf("decrypt  = %02x %02x %02x %02x %02x %02x %02x %02x\r\n",temp_data[0],temp_data[1],temp_data[2],temp_data[3],temp_data[4],temp_data[5],temp_data[6],temp_data[7]);
 }
 */

//---------------------------------------------------------------------------------------
//end
//---------------------------------------------------------------------------------------
