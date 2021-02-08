//	NOTE: all reserved bits are set to 1.

#include "common.h"
#include "spi.h"
#include "ad9106.h"

// 修改gpio_reg[5]
void ad9106_trigger_on( uint* gpio_reg ){
	*gpio_reg |= (1 << AD9106_TRIG_MASK_BIT);
}

void ad9106_trigger_off( uint* gpio_reg ){
	*gpio_reg &= ~(1 << AD9106_TRIG_MASK_BIT);
}

uint config_ad9106( uint *gpio_reg, uint *gpio2_reg, uint *gpio_in_reg ){

	uint status;

	int ad9106_cfg[SPI_CFG_DATA_NUM] = {0};
	int ad9106_ram[SPI_RAM_DATA_NUM] = {0};

	//	step 0: prepare configuration & waveform (ram) data
	uint cfg_data_size = ini_ad9106_cfg_data( ad9106_cfg, SPI_CFG_DATA_NUM );
	uint ram_data_size = ini_ad9106_ram_data( ad9106_ram, SPI_RAM_DATA_NUM );

//	step 1: setup SPI configuration & SPI data
	SPI_CONFIG *spi_config = (SPI_CONFIG*)malloc(sizeof(SPI_CONFIG));
	setup_SPI_by_device_name(spi_config, "ad9106");

	SPI_DATA *cfg_data = (SPI_DATA*)malloc(sizeof(SPI_DATA));
	SPI_DATA *ram_data = (SPI_DATA*)malloc(sizeof(SPI_DATA));

	spi_data_alloc(cfg_data, cfg_data_size);
	spi_data_alloc(ram_data, ram_data_size);

//	copy cfg_data & ram_data into SPI_DATA structures
	int idx;
	for( idx=0; idx<cfg_data_size; idx++ ){
		spi_data_set( 	cfg_data, 
						idx, 
						(ad9106_cfg[idx] >> 16), 
						(ad9106_cfg[idx] & 0x0000FFFF) 
						);
	}

	for( idx=0; idx<ram_data_size; idx++ ){
		spi_data_set( 	ram_data, 
						idx, 
						(ad9106_ram[idx] >> 16), 
						(ad9106_ram[idx] & 0x0000FFFF) 
						);
	}

	// print_ad9106_cfg_data( ad9106_cfg, 15 );  // for debug

//	step 2: send configuration data
	status = send_spi_data( gpio_reg, 
							gpio2_reg, 
							gpio_in_reg, 
							spi_config,
							cfg_data );

	if( status != _SPI_SUCCESS_ ){
		printf("Error: failed to configure AD9106 via SPI!\n");
		exit(0);
	}

//	step 2: send waveform data
	status = send_spi_data( gpio_reg, 
							gpio2_reg, 
							gpio_in_reg, 
							spi_config,
							ram_data );

	if( status != _SPI_SUCCESS_ ){
		printf("Error: failed to write waveform into AD9106 SRAM via SPI!\n");
		exit(0);
	}

//	free allocated memory
	spi_data_free(cfg_data);
	spi_data_free(ram_data);

	free(cfg_data);
	free(ram_data);
	free(spi_config);

	return status;
}