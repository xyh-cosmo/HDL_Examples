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

// void set_bit(uint *a, uint bit_num, uint bit_val ){

// }