#include "mex.h" 
void crc32mex(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    mexPrintf("Hello, world!\n");
    
    unsigned char* message = ;

    int i, j;
    unsigned int byte, crc, mask;
    static unsigned int table[256];

    /* Set up the table, if necessary. */

    if (table[1] == 0) {
        for (byte = 0; byte <= 255; byte++) {
            crc = byte;
            for (j = 7; j >= 0; j--) { // Do eight times.
                mask = -(crc & 1);
                crc = (crc >> 1) ^ (0xEDB88320 & mask);
            }
            table[byte] = crc;
            printf("[%3d] %.8X\n",byte,crc);
        }
    }

    /* Through with table setup, now calculate the CRC. */

    i = 0;
    crc = 0xFFFFFFFF;
    while ((byte = message[i]) != 0) {
        crc = (crc >> 8) ^ table[(crc ^ byte) & 0xFF];
        i = i + 1;
    }
    crc = ~crc;
    
    mexPrintf("Goodbye, world!\n");
    mexPrintf("\nCRC-32 = \"%x\"\n",crc);

}
