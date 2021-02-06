#include <stdio.h>
#include <stdlib.h>
#include "common.h"
#include "spi.h"

uint setup_SPI( SPI_CONFIG * spi_cfg, 
				uint cpol, 
				uint cpha, 
				uint A0,
				uint A1,
				char *devname ){
	spi_cfg->cpol 	= cpol;
	spi_cfg->cpha 	= cpha;
	spi_cfg->A0		= A0;
	spi_cfg->A1		= A1;
	sprintf(spi_cfg->devname, "%s", devname);
	printf("SPI configuration for device: %s\n", spi_cfg->devname);
	printf("> SPI: CPOL = %d\n", spi_cfg->cpol);
	printf("> SPI: CPOL = %d\n", spi_cfg->cpol);
	printf("> SPI: A0   = %d\n", spi_cfg->A0);
	printf("> SPI: A1   = %d\n", spi_cfg->A1);
	return _SPI_SUCCESS_;
}

uint spi_data_alloc( SPI_DATA* spi_data, uint data_size ){

	spi_data->size			= data_size;
	spi_data->reg_addr  	= malloc(sizeof(uint)*data_size);
	spi_data->reg_val		= malloc(sizeof(uint)*data_size);
	spi_data->reg_addr_val	= malloc(sizeof(uint)*data_size);

	return _SPI_SUCCESS_;
}

uint spi_data_free( SPI_DATA *spi_data ){

	if( spi_data->reg_val != NULL ){
		free(spi_data->reg_val);
	}

	if( spi_data->reg_addr != NULL ){
		free(spi_data->reg_addr);
	}

	if( spi_data->reg_addr_val != NULL ){
		free(spi_data->reg_addr_val);
	}

	return _SPI_SUCCESS_;
}

uint spi_data_set( SPI_DATA *spi_data, uint idx, uint addr, uint val ){
	
	spi_data->reg_addr[idx] 	= addr;
	spi_data->reg_val[idx]		= val;
	spi_data->reg_addr_val[idx]	= (addr << 16) + val;

	return _SPI_SUCCESS_;
}

uint send_spi_data_32bits( 	uint* gpio_reg, 
							uint* gpio2_reg, 
							uint* gpio_in_reg, 
							SPI_CONFIG *spi_config,
							uint data ){

	uint A0 = spi_config->A0;
	uint A1 = spi_config->A1;
	uint cpol = spi_config->cpol;
	uint cpha = spi_config->cpha;
	uint rst;

	// step 1: prepare data, just write data into register pointed by gpio2_reg
	*gpio2_reg = data;

	// step 2: send a pluse to PL via changing state of a specific bit of reg_addr
	// sizeof(gpio_reg) = 5
	// *gpio_reg = {A0,A1,cpol,cpha,rst}
	rst = 0;
	*gpio_reg = (A0 << 4) + (A1 << 3) + (cpol << 2) + (cpha << 1) + rst;

	delay(100000);

	rst = 1;
	*gpio_reg = (A0 << 4) + (A1 << 3) + (cpol << 2) + (cpha << 1) + rst;

	// step 3: wait finish signal send by PL side
	int cnt=0, cnt_max = 0xffff;
	while(1){
		uint pl_status = get_bit(*gpio_in_reg, 0);

		if( pl_status == 1 ){
			printf("SPI: successfully send data: 0X%08X\n", data);
			return _SPI_SUCCESS_;
			// break;
		} else {
			cnt++;
		}

		if( cnt >= cnt_max ){
			printf("SPI: cnt exceeds cnt_max = 0xffff, failed to send data\n");
			return _SPI_FAILURE_;
		}
	}
	return _SPI_SUCCESS_;
}

uint send_spi_data( uint* gpio_reg, 
					uint* gpio2_reg, 
					uint* gpio_in_reg, 
					SPI_CONFIG *spi_config,
					SPI_DATA *spi_data ){
	uint i;
	for( i=0; i<spi_data->size; i++ ){
		send_spi_data_32bits( 	gpio_reg, 
								gpio2_reg,
								gpio_in_reg, 
								spi_config,
								spi_data->reg_addr_val[i] );
	}

	return _SPI_SEND_OK_;
}