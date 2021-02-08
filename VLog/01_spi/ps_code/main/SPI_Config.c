//	目前还未将这个文件改动为实际设计的样子！！！

#include "common.h"
#include "spi.h"
#include "ad9106.h"
#include "adc.h"

int main( int argc, char *argv[] ){

	if( argc < 4 ){
		printf("usage: %s dev_name reg_addr reg_val\n", argv[0]);
		return 0;
	}

	char devname[128];
	sprintf(devname, "%s", argv[1]);

	uint reg_addr = atoi(argv[2]);
	uint reg_val  = atoi(argv[3]);
	
//	step 1: setup SPI configuration & SPI data
	SPI_CONFIG *spi_config = (SPI_CONFIG*)malloc(sizeof(SPI_CONFIG));
	setup_SPI_by_device_name(spi_config, devname);
	
//	step 2: create pointers
	int fd = open("/dev/mem", O_RDWR | O_SYNC);
	uint *ptr1 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_GPIO_OUT);
	uint *ptr2 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_GPIO_IN);

	uint *gpio_reg 		= ptr1;		// 0x41200000
	uint *gpio2_reg		= ptr1+2;	// 0x41200008
	uint *gpio_in_reg	= ptr2;		// 0x41210000

	config_via_spi(reg_addr, reg_val, spi_config, gpio_reg, gpio2_reg, gpio_in_reg);

	free(spi_config);
	munmap(ptr1,10);
	munmap(ptr2,10);

	return 0;
}
