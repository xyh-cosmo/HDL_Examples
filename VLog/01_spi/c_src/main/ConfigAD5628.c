#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/mman.h>
#include <math.h>
#include "adc.h"

#define CPOL 1
#define CPHA 0
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
	setup_SPI(spi_config, CPOL, CPHA, "AD5628");

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
	unsigned int *ptr1 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, BaseAddr1);
	unsigned int *ptr2 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, BaseAddr2);

	unsigned int *gpio 		= ptr1;
	unsigned int *gpio2		= ptr1+2;
	unsigned int *gpio_in	= ptr2;


//	step 2: send a pluse to PL side


//	step 3: check PL response
	while(1){
		int pl_status = get_bit(gpio_in,0);

	}


//	free allocated memory
	spi_data_free(spi_data);
	free(spi_data);
	free(spi_config);

	return 0;
}
