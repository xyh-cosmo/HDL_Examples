#ifndef _COMMON_H_
#define _COMMON_H_

//	PS writes register via a pointer pointing to ADDR_GPIO_OUT
#define ADDR_GPIO_OUT	0x41200000

//	PS reads register via a pointer pointing to ADDR_GPIO_IN
#define ADDR_GPIO_IN	0x41210000

int get_bit(int a, int bit_num);
void delay(uint delay_max);

#endif