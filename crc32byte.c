#include "stdio.h"

unsigned int crc32(unsigned char *message);


int main(int argc, char *argv[]) {

    unsigned char msg[] = "12345678";
    int n;
    
    for (n=0;n<17;n++) {
        //msg[n] = (unsigned char *) n;
        printf("msg[%d] = %x\n",n, msg[n]);
    }
    //char * data;
    
    unsigned int crc;
    
/*    data = argv[1];
    printf("%s\n",data);
    msg = (unsigned char*) atoi(data);
    printf("%x\n",msg);
*/    
    crc = crc32(msg);

    printf("\nCRC-32 = \"%x\"\n",crc);
    
return 0;
}

unsigned int crc32(unsigned char *message) {
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
    return ~crc;
}
