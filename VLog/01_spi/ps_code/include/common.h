#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/mman.h>
#include <math.h>

#ifndef _COMMON_H_
#define _COMMON_H_

#define _SUCCESS_	0
#define _FAILURE_ 	1

// bit operations
#define setbit(x,y)  x|=(1<<y)
#define clrbit(x,y)  x&=~(1<<y)
#define reversebit(x,y) x^=(1<<y)
#define getbit(x,y)   ((x) >> (y)&1)

// on MacOS, clang might not recognize uint
#ifndef uint
	typedef unsigned int uint;
#endif


//	PS writes register via a pointer pointing to ADDR_GPIO_OUT
#define ADDR_GPIO_OUT	0x41200000

//	PS reads register via a pointer pointing to ADDR_GPIO_IN
#define ADDR_GPIO_IN	0x41210000

int get_bit(int a, int bit_num);
void delay(uint delay_max);

void print_as_bin(uint x);
void printf_bin(int num);

void read_bin_text();

#endif

