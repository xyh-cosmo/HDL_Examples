#include <stdio.h>
#include <stdlib.h>
#include "adc.h"

int get_bit(int a, int bit_num){
	int mask = (1<<bit_num);
	int res = (a & mask)>>bit_num;
	
	return res;
}

int setup_SPI( SPI_CONFIG * spi_cfg, int cpol, int cpha, char *devname ){
	spi_cfg->cpol = cpol;
	spi_cfg->cpha = cpha;
	sprintf(spi_cfg->devname, "%s", devname);
	printf("SPI configuration for device: %s\n", spi_cfg->devname);
	printf("> SPI: CPOL = %d\n", spi_cfg->cpol);
	printf("> SPI: CPHA = %d\n", spi_cfg->cpha);
	return _SPI_SUCCESS_;
}

int spi_data_alloc( SPI_DATA* spi_data, int data_size ){

	// spi_data 				= (SPI_DATA*)malloc(sizeof(SPI_DATA));
	spi_data->size			= data_size;
	// printf("--> allocating memory for spi_data->reg_addr\n");
	spi_data->reg_addr  	= malloc(sizeof(int)*data_size);

	// printf("--> allocating memory for spi_data->reg_val\n");
	spi_data->reg_val		= malloc(sizeof(int)*data_size);

	// printf("--> allocating memory for spi_data->reg_addr_val\n");
	spi_data->reg_addr_val	= malloc(sizeof(int)*data_size);

	return _SPI_SUCCESS_;
}

int spi_data_free( SPI_DATA *spi_data ){

	if( spi_data->reg_val != NULL ){
		free(spi_data->reg_val);
	}

	if( spi_data->reg_addr != NULL ){
		free(spi_data->reg_addr);
	}

	if( spi_data->reg_addr_val != NULL ){
		free(spi_data->reg_addr_val);
	}

	// if( spi_data != NULL ){
	// 	free(spi_data);
	// }

	// spi_data = NULL;
	return _SPI_SUCCESS_;
}

int spi_data_set( SPI_DATA *spi_data, int idx, int addr, int val ){
	
	int tmp = (addr << 16) + val;
	spi_data->reg_addr[idx] 	= addr;
	spi_data->reg_val[idx]		= val;
	spi_data->reg_addr_val[idx]	= tmp;

	// printf("setting spi_data[%3d] = 0X%08X\n", idx, tmp);

	return _SPI_SUCCESS_;
}

int send_spi_data_32bits( int addr_gpio_out, int addr_gpio_in, int data ){
	// step 1: prepare data

	// step 2: send a pluse to PL via changing state of a specific bit of reg_addr

	// step 3: wait finish signal send by PL side
	return _SPI_SUCCESS_;
}

int send_spi_data( int addr_gpio_out, int addr_gpio_in, SPI_DATA *spi_data ){
	int i;
	for( i=0; i<spi_data->size; i++ ){
		send_spi_data_32bits( addr_gpio_out, addr_gpio_in, spi_data->reg_addr_val[i] );
	}

	return _SPI_SEND_OK_;
}