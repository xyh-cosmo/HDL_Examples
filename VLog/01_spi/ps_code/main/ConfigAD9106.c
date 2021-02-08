#include "common.h"
#include "spi.h"
#include "adc.h"
#include "ad9106.h"

#define SPI_CFG_DATA_NUM 		128
#define SPI_RAM_DATA_NUM	4096

int ad9106_cfg[SPI_CFG_DATA_NUM] = {0};
int ad9106_ram[SPI_RAM_DATA_NUM] = {0};


int main(){

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

	print_ad9106_cfg_data( ad9106_cfg, 15 );

//	step 2: create pointers
	int fd = open("/dev/mem", O_RDWR | O_SYNC);
	uint *ptr1 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_GPIO_OUT);
	uint *ptr2 = mmap(NULL, 10, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ADDR_GPIO_IN);

	uint *gpio_reg 		= ptr1;		// 0x41200000
	uint *gpio2_reg		= ptr1+2;	// 0x41200008
	uint *gpio_in_reg	= ptr2;		// 0x41210000


//	step 2: send configuration data
	send_spi_data(  gpio_reg, 
					gpio2_reg, 
					gpio_in_reg, 
					spi_config,
					cfg_data );

//	step 2: send waveform data
	send_spi_data(  gpio_reg, 
					gpio2_reg, 
					gpio_in_reg, 
					spi_config,
					ram_data );

//	free allocated memory
	spi_data_free(cfg_data);
	spi_data_free(ram_data);
	free(cfg_data);
	free(ram_data);

	free(spi_config);

	// munmap(ptr1,10);
	// munmap(ptr2,10);

	return 0;
}
