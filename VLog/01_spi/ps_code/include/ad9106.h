#ifndef _AD9106_H_
#define _AD9106_H_

#define AD9106_SRAM_ADDR_START	0x6000
#define AD9106_SRAM_ADDR_STOP	0x6fff

void set_ad9106_reg( int *reg,
					 uint idx, 
					 uint addr, 
					 uint val,
					 uint size );

uint ini_ad9106_cfg_data( int *cfg_data, uint size );
uint ini_ad9106_ram_data( int *ram_data, uint size );

void print_ad9106_cfg_data( int *cfg_data, uint data_size );
void print_ad9106_ram_data( int *ram_data, uint data_size );

#endif