#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/mman.h>
#include <math.h>

// #include <stdio.h>
// #include <stdlib.h>
// #include <string.h>

#ifndef _COMMON_H_
#define _COMMON_H_

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

