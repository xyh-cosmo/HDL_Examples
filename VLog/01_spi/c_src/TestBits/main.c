/*
    a demo shows how to operate on a single bit of an int number.
*/

#include <stdio.h>
#include <stdlib.h>

int main(){
//    printf("Hello World!\n");

    int mask = 0;
    int a = 0;
    int b = 0;

    mask = (1<<1);
    a |= mask;
    printf(" a = %d\n",a);

    mask = (1<<3);
    a |= mask;
    printf(" a = %d\n",a);

//    mask = (0<<2) + (1<<1);
    mask = (1<<3);
    b = a & mask;
    printf(" b = %d\n",b);

    int nbits = 11;
    int x = 0b10101010111;
    int i,j;
    int x_bin[nbits];

    for( i=0; i<nbits; i++ ){

        x_bin[i] = 0;

        int x_mask = (1<<i);
        int tmp = x & x_mask;

        printf("0b");
        for(j=0; j<nbits; j++){
            if(j==i){
                int tmp_masked = tmp >> i;
                printf("%d",tmp_masked);
                x_bin[j] = tmp_masked;
            }else{
                printf("0");
            }
        }
        printf("\n");
    }

    printf("0B");
    for(i=nbits-1; i>=0; i--){
        printf("%d",x_bin[i]);

        if(i==0)
            printf("\n");
    }


    return 0;
}
