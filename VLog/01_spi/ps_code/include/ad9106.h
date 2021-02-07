#ifndef _AD9106_H_
#define _AD9106_H_

void set_ad9106_reg( int *reg,
					 uint idx, 
					 uint addr, 
					 uint val,
					 uint size );

void ini_ad9106_cfg_data( int *regs, uint size );
void print_ad9106_cfg_data( int *ad9106_data, uint data_size );

void ini_ad9106_ram_data( int *ad9106_ram, uint size );

#endif