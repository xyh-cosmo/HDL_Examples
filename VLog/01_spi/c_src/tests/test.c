#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/mman.h>
#include <math.h>

int get_bit(int a, int bit_num){
/*	if(bit_num <0){*/
/*		printf("==> Fatal Error: bit_num should not be negative!\n");*/
/*		return -1;*/
/*	}*/
	int mask = (1<<bit_num);
	int res = (a & mask)>>bit_num;
	
	return res;
}

int main(){
	unsigned int BaseAddr1 = 0x41200000;
	unsigned int BaseAddr2 = 0x41210000;
	int fd = open("/dev/mem", O_RDWR | O_SYNC);
	unsigned int *ptr1 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, BaseAddr1);
	unsigned int *ptr2 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, BaseAddr2);

	printf("*ptr1 = 0x%x\n",ptr1);
	printf("*ptr1+1 = 0x%x\n",ptr1+1);
	printf("*ptr1+2 = 0x%x\n",ptr1+2);
	printf("*ptr1+3 = 0x%x\n",ptr1+3);
	printf("*ptr2 = 0x%x\n",ptr2);
	
	int bit = get_bit(ptr2[0],0);
	printf("@ bit = %d\n", bit);
	
	// *(ptr1+8) = 0Xffffffff;

	int delay, delay_max = 2;

	int bit3,bit2,bit1,bit0;
	int cnt=0;
	int idx = 2;
	while(1){
		ptr1[idx] = 0b1100;
		for(delay=0; delay<delay_max; delay++);
		
		// bit2 = get_bit(ptr1[0],3);
		// printf(" #bit3 = %d\n",bit2);

		ptr1[idx] = 0;
		for(delay=0; delay<delay_max; delay++);
		
		// bit2 = get_bit(ptr1[0],3);
		// printf(" @bit3 = %d\n",bit2);
		
		// cnt++;
		// if(cnt > 10){
		// 	break;
		// }
	}




}
