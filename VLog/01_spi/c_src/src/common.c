#include <stdio.h>
#include <stdlib.h>
#include "common.h"

int get_bit(int a, int bit_num){
	int mask = (1<<bit_num);
	int res = (a & mask)>>bit_num;
	
	return res;
}


void delay(uint delay_max){
	int delay;
	for(delay=0; delay<delay_max; delay++);
}

void print_as_bin(uint x){
	int bits[32] = {0};
	int i;
	for(i=31; i>=0; i--){
		bits[i] = (x&1<<i) >> i;
	}

	printf(" x = %d => 0b",x);
	for(i=0; i<32; i++){
		printf("%d",bits[i]);
		if(i >0 && (i+1)%4 == 0 && i <31)
			printf("_");
	}
	printf("\n");
}

// void set_bit(uint *a, uint bit_num, uint bit_val ){

// }