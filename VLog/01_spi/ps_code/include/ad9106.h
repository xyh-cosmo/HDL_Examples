#ifndef _AD9106_H_
#define _AD9106_H_

#define SPI_CFG_DATA_NUM 	128
#define SPI_RAM_DATA_NUM	4096

#define AD9106_SRAM_ADDR_START	0x6000
#define AD9106_SRAM_ADDR_STOP	0x6fff

#define AD9106_TRIG_MASK_BIT	5

void set_ad9106_reg( int *reg,
					 uint idx, 
					 uint addr, 
					 uint val,
					 uint size );

uint ini_ad9106_cfg_data( int *cfg_data, uint size );
uint ini_ad9106_ram_data( int *ram_data, uint size );

void print_ad9106_cfg_data( int *cfg_data, uint data_size );
void print_ad9106_ram_data( int *ram_data, uint data_size );

// // 通过配置PAT_STATUS的RUN
// uint turn_on_ad9106( uint* gpio_reg );
// uint turn_off_ad9106( uint* gpio_reg );

// 修改gpio_reg[5]
void ad9106_trigger_on( uint* gpio_reg );
void ad9106_trigger_off( uint* gpio_reg );

uint config_ad9106( uint *gpio_reg, uint *gpio2_reg, uint *gpio_in_reg );

#endif