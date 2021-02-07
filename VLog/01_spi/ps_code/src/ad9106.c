#include "common.h"
#include "ad9106.h"


void set_ad9106_reg( int *ad9106_data,
					 uint idx, 
					 uint addr, 
					 uint val,
					 uint data_size ){
	if( idx >= data_size-1 ){
		printf("Error: idx = %d is larger than data_size-1 = %d\n", idx, data_size-1);
		exit(0);
	}

	ad9106_data[idx] = 0;
	ad9106_data[idx] = (addr << 16) + val;
}

void ini_ad9106_cfg_data( int *ad9106_data, uint data_size ){

	uint addr, val;
	
	// 0x00 SPICONFIG
	addr 	= 0x00;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 0, addr, val, data_size);

	// 0x01 POWERCONFIG
	addr 	= 0x01;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 1, addr, val, data_size);

	// 0x02 CLOCKCONFIG
	addr 	= 0x02;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 2, addr, val, data_size);

	// 0x03 REFADJ
	addr 	= 0x03;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 3, addr, val, data_size);

	// 0x04 DAC4GAIN
	addr 	= 0x04;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 4, addr, val, data_size);

	// 0x05 DAC3GAIN
	addr 	= 0x05;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 5, addr, val, data_size);

	// 0x06 DAC2GAIN
	addr 	= 0x06;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 6, addr, val, data_size);

	// 0x07 DAC1GAIN
	addr 	= 0x07;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 7, addr, val, data_size);

	// 0x08 DACxRANGE
	addr 	= 0x08;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 8, addr, val, data_size);

	// 0x09 DAC4RSEY
	addr 	= 0x09;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 9, addr, val, data_size);

	// 0x0A DAC3RSEY
	addr 	= 0x0A;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 10, addr, val, data_size);

	// 0x0B DAC2RSEY
	addr 	= 0x0B;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 11, addr, val, data_size);

	// 0x0C DAC1RSEY
	addr 	= 0x0C;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 12, addr, val, data_size);

	// 0x0D CALCONFIG
	addr 	= 0x0D;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 13, addr, val, data_size);

	// 0x0E COMPOFFSET
	addr 	= 0x0E;
	val		= 0b1010;
	set_ad9106_reg(ad9106_data, 14, addr, val, data_size);
}

void print_ad9106_cfg_data( int *ad9106_data, uint data_size ){
	int i;
	for(i=0; i<data_size; i++ ){
		printf_bin(ad9106_data[i]);
	}
}

void ini_ad9106_ram_data( int *ad9106_ram, uint data_size ){

}