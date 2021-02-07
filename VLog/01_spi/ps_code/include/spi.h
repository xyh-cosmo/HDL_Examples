#include "common.h"

#ifndef _SPI_H_
#define _SPI_H_

#define _SPI_SUCCESS_	0
#define _SPI_FAILURE_ 	1

// #define _SPI_SEND_OK_	2
// #define _SPI_SEND_FAILED_ 3

typedef struct{
	uint cpol;
	uint cpha;
	uint A0;
	uint A1;
	char devname[1024];
} SPI_CONFIG;

typedef struct{
	uint size;
	uint *reg_addr;
	uint *reg_val;
	uint *reg_addr_val;
} SPI_DATA;


uint setup_SPI( SPI_CONFIG * spi_cfg, 
				uint cpol, 
				uint cpha, 
				uint A0,
				uint A1,
				char *devname );

uint setup_SPI_by_device_name( SPI_CONFIG * spi_cfg, char *devname );

uint spi_data_alloc( SPI_DATA *spi_data, uint data_size );
uint spi_data_free( SPI_DATA *spi_data );
uint spi_data_set( SPI_DATA *spi_data, uint idx, uint addr, uint val );

uint send_spi_data_32bits( 	uint* gpio_reg, 
							uint* gpio2_reg, 
							uint* gpio_in_reg, 
							SPI_CONFIG *spi_config,
							uint data );

uint send_spi_data( uint* gpio_reg, 
					uint* gpio2_reg, 
					uint* gpio_in_reg, 
					SPI_CONFIG *spi_config,
					SPI_DATA *spi_data );


#endif