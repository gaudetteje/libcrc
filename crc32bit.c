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

    i = 0;
    crc = 0xFFFFFFFF;
    while (message[i] != 0) {
        byte = message[i]; // Get next byte.
        crc = crc ^ byte;
        printf("\nCRC of %x = %x\n",byte,crc);
        for (j = 7; j >= 0; j--) { // Do eight times.
            mask = -(crc & 1);
            printf("[%d] %x\n",j,mask);
            crc = (crc >> 1) ^ (0xEDB88320 & mask);
            }
        i = i + 1;
    }
    return ~crc;
}
