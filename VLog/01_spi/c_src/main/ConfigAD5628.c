#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/mman.h>
#include <math.h>

#include "common.h"
#include "spi.h"
#include "adc.h"

// SPI settings
#define CPOL 1
#define CPHA 0
#define A0 0
#define A1 0
#define SPI_DATA_NUM 11

int ad5628_data[11] = {
					0b11111000000000000000000000000001,
					0b11110100000000000000000011111111,
					0b11110110000000000000000011111111,
					0b11110011000010110110110000000000,
					0b11110011000100010010010000000000,
					0b11110011001001100110011000000000,
					0b11110011001100101010101000000000,
					0b11110011010010000000000000000000,
					0b11110011010110000000000000000000,
					0b11110011011010000000000000000000,
					0b11110011011100110011001100000000
				};

int main(){
	
//	step 1: setup SPI configuration & SPI data
	SPI_CONFIG *spi_config = (SPI_CONFIG*)malloc(sizeof(SPI_CONFIG));
	setup_SPI(spi_config, CPOL, CPHA, A0, A1, "AD5628");

	SPI_DATA *spi_data = (SPI_DATA*)malloc(sizeof(SPI_DATA));
	spi_data_alloc(spi_data, SPI_DATA_NUM);

	int idx;
	for( idx=0; idx<SPI_DATA_NUM; idx++ ){
		spi_data_set( 	spi_data, 
						idx, 
						(ad5628_data[idx] >> 16), 
						(ad5628_data[idx] & 0x0000FFFF) 
						);
	}

//	step 2: create pointers
	int fd = open("/dev/mem", O_RDWR | O_SYNC);
	uint *ptr1 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_GPIO_OUT);
	uint *ptr2 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_GPIO_IN);

	uint *gpio_reg 		= ptr1;		// 0x41200000
	uint *gpio2_reg		= ptr1+2;	// 0x41200008
	uint *gpio_in_reg	= ptr2;		// 0x41210000


//	step 2: send data
	send_spi_data(  gpio_reg, 
					gpio2_reg, 
					gpio_in_reg, 
					spi_config,
					spi_data );


//	free allocated memory
	spi_data_free(spi_data);
	free(spi_data);
	free(spi_config);

	munmap(ptr1,10);
	munmap(ptr2,10);

	return 0;
}
