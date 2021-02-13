// 2021/02/08: 目前暂且将AD5628的配置数据直接写进函数中

#include "common.h"
#include "spi.h"
#include "ad5628.h"

#define SPI_DATA_NUM 11

uint config_ad5628( uint *gpio_reg, uint *gpio2_reg, uint *gpio_in_reg ){

	printf("==> configuring AD5628\n");

	// uint status;

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

					// 0b00001000000000000000000000000001,
					// 0b00000100000000000000000011111111,
					// 0b00000110000000000000000011111111,
					// 0b00000011000010110110110000000000,
					// 0b00000011000100010010010000000000,
					// 0b00000011001001100110011000000000,
					// 0b00000011001100101010101000000000,
					// 0b00000011010010000000000000000000,
					// 0b00000011010110000000000000000000,
					// 0b00000011011010000000000000000000,
					// 0b00000011011100110011001100000000

					// 0b0000 1000 0000 000000000000 00000001,
					// 0b0000 0100 0000 000000000000 11111111,
					// 0b0000 0110 0000 000000000000 11111111,
					// 0b0000 0011 0000 101101101100 00000000,
					// 0b0000 0011 0001 000100100100 00000000,
					// 0b0000 0011 0010 011001100110 00000000,
					// 0b0000 0011 0011 001010101010 00000000,
					// 0b0000 0011 0100 100000000000 00000000,
					// 0b0000 0011 0101 100000000000 00000000,
					// 0b0000 0011 0110 100000000000 00000000,
					// 0b0000 0011 0111 001100110011 00000000

				};

//	step 1: setup SPI configuration & SPI data
	SPI_CONFIG *spi_config = (SPI_CONFIG*)malloc(sizeof(SPI_CONFIG));
	// setup_SPI(spi_config, CPOL, CPHA, A0, A1, "AD5628");
	setup_SPI_by_device_name(spi_config, "ad5628");

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

//	step 2: send data
	if( _SPI_SUCCESS_ != send_spi_data( gpio_reg, 
										gpio2_reg, 
										gpio_in_reg, 
										spi_config,
										spi_data ) ){
		printf("Error: failed to configure AD5628!\n");
		return _SPI_FAILURE_;
	}


//	free allocated memory
	spi_data_free(spi_data);
	free(spi_data);
	free(spi_config);

	printf("==> finished AD5628 configuration\n");

	return _SPI_SUCCESS_;
}