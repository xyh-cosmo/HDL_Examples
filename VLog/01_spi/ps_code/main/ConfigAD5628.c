#include "common.h"
#include "spi.h"
#include "adc.h"
#include "ad5628.h"

int main(){
	
	int fd = open("/dev/mem", O_RDWR | O_SYNC);
	uint *ptr1 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_GPIO_OUT);
	uint *ptr2 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_GPIO_IN);

	uint *gpio_reg 		= ptr1;		// 0x41200000
	uint *gpio2_reg		= ptr1+2;	// 0x41200008
	uint *gpio_in_reg	= ptr2;		// 0x41210000

	config_ad5628( gpio_reg, gpio2_reg, gpio_in_reg );

	munmap(ptr1,10);
	munmap(ptr2,10);

	return 0;
}
