//	NOTE: all reserved bits are set to 1.
//
//	这里只处理 AD9106寄存器的配置和SRAM数据的写入

#include "common.h"
#include "spi.h"
#include "ad9106.h"

void set_ad9106_reg( int *reg,
					 uint idx, 
					 uint addr, 
					 uint val,
					 uint data_size ){
	if( idx >= data_size-1 ){
		printf("Error: idx = %d is larger than data_size-1 = %d\n", idx, data_size-1);
		exit(0);
	}

	*(reg+idx) = 0;
	*(reg+idx) = (addr << 16) + val;
}

// 如果某些寄存器不需要配置，直接将相关代码注释即可
uint ini_ad9106_cfg_data( int *cfg_data, uint data_size ){

	uint addr, val;
	uint idx = 0;
	
	// 0x00 SPICONFIG
	addr 	= 0x00;
	val		= 0b0000001111000000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;	// 

	// 0x01 POWERCONFIG
	addr 	= 0x01;
	val		= 0b1111000111000000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x02 CLOCKCONFIG
	addr 	= 0x02;
	val		= 0b1111000000000000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x03 REFADJ
	addr 	= 0x03;
	val		= 0b1111000000001111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// // 0x04 DAC4GAIN
	// addr 	= 0x04;
	// val		= 0b0; // default setting
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x05 DAC3GAIN
	// addr 	= 0x05;
	// val		= 0b0; // default setting
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x06 DAC2GAIN
	// addr 	= 0x06;
	// val		= 0b0; // default setting
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x07 DAC1GAIN
	// addr 	= 0x07;
	// val		= 0b0; // default setting
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x08 DACxRANGE
	// addr 	= 0x08;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// 0x09 DAC4RSET
	addr 	= 0x09;
	val		= 0b1111111111101111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x0A DAC3RSET
	addr 	= 0x0A;
	val		= 0b1111111111101111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x0B DAC2RSET
	addr 	= 0x0B;
	val		= 0b1111111111101111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x0C DAC1RSET
	addr 	= 0x0C;
	val		= 0b1111111111101111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// // 0x0D CALCONFIG
	// addr 	= 0x0D;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x0E COMPOFFSET
	// addr 	= 0x0E;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// 0x1E PAT_STATUS
	addr 	= 0x1E;
	val		= 0b1111111111110001;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x1F PAT_TYPE
	// NOTE:在测试阶段，零时将PATTERN_RPT设置为0，一直输出波形
	addr 	= 0x1F;
	val		= 0b1111111111111110;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x20 PATTERN_DLY
	addr 	= 0x20;
	val		= 0x000E;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// NOTE：暂时将4个通道的OFFSET全部设置为0
	// 0x22 DAC4DOF
	addr 	= 0x22;
	val		= 0b0000000000001111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x23 DAC3DOF
	addr 	= 0x23;
	val		= 0b0000000000001111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x24 DAC2DOF
	addr 	= 0x24;
	val		= 0b0000000000001111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x25 DAC1DOF
	addr 	= 0x25;
	val		= 0b0000000000001111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x26 WAV4_3CONFIG
	addr 	= 0x26;
	val		= 0b1100110011001100;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x27 WAV2_1CONFIG
	addr 	= 0x27;
	val		= 0b1100110011001100;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x28 PAT_TIMEBASE ????
	addr 	= 0x28;
	val		= 0b1111000100010001;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x29 PAT_PERIOD
	addr 	= 0x29;
	val		= 0b0000000111111111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// // 0x2A DAC4_3PATx
	// addr 	= 0x2A;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x2B DAC2_1PATx
	// addr 	= 0x2B;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// 0x2C DOUT_START_DLY
	addr 	= 0x2C;
	val		= 0x0003;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x2D DOUT_CONFIG
	addr 	= 0x2D;
	val		= 0x0;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// // 0x2E DAC4_CST
	// addr 	= 0x2E;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x2F DAC3_CST
	// addr 	= 0x2F;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x30 DAC2_CST
	// addr 	= 0x30;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x31 DAC1_CST
	// addr 	= 0x31;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// 四个通道的增益设置为默认值
	// 0x32 DAC4_DGAIN
	addr 	= 0x32;
	val		= 0b0000000000001111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x33 DAC3_DGAIN
	addr 	= 0x33;
	val		= 0b0000000000001111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x34 DAC2_DGAIN
	addr 	= 0x34;
	val		= 0b0000000000001111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x35 DAC1_DGAIN
	addr 	= 0x35;
	val		= 0b0000000000001111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// // 0x36 SAW4_3CONFIG
	// addr 	= 0x36;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x37 SAW2_1CONFIG
	// addr 	= 0x37;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x38 -- 0x3D reserved ...

	// // 0x3E DDS_TW32
	// addr 	= 0x3E;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x3F DDS_TW1
	// addr 	= 0x3F;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x40 DDS4_PW
	// addr 	= 0x40;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x41 DDS3_PW
	// addr 	= 0x41;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x42 DDS2_PW
	// addr 	= 0x42;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x43 DDS1_PW
	// addr 	= 0x43;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// 0x44 TRIG_TW_SEL ???
	addr 	= 0x44;
	val		= 0b1111111111111101;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// // 0x45 DDSx_CONFIG
	// addr 	= 0x45;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x47 TW_RAM_CONFIG
	// addr 	= 0x47;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// 0x50 START_DLY4
	addr 	= 0x50;
	val		= 0b0000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x51 START_ADDR4
	addr 	= 0x51;
	val		= 0b0000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x52 STOP_ADDR4
	addr 	= 0x52;
	val		= 0b1111111111101111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x53 DDS_CYC4
	// addr 	= 0x53;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// 0x54 START_DLY3
	addr 	= 0x54;
	val		= 0b0000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x55 START_ADDR3
	addr 	= 0x55;
	val		= 0b0000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x56 STOP_ADDR3
	addr 	= 0x56;
	val		= 0b1111111111101111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// // 0x57 DDS_CYC3
	// addr 	= 0x57;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// 0x58 START_DLY2
	addr 	= 0x58;
	val		= 0b0000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x59 START_ADDR2
	addr 	= 0x59;
	val		= 0b0000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x5A STOP_ADDR2
	addr 	= 0x5A;
	val		= 0b1111111111101111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// // 0x5B DDS_CYC2
	// addr 	= 0x5B;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// 0x5C START_DLY1
	addr 	= 0x5C;
	val		= 0b0000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x5D START_ADDR1
	addr 	= 0x5D;
	val		= 0b0000;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// 0x5E STOP_ADDR1
	addr 	= 0x5E;
	val		= 0b1111111111101111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	// // 0x5F DDS_CYC1
	// addr 	= 0x5F;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;

	// // 0x60 CFG_ERROR
	// addr 	= 0x60;
	// val		= 0b1010;
	// set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	// idx++;


	// 0x1D RAMUPDATE
	addr 	= 0x1D;
	val		= 0b1111111111111111;
	set_ad9106_reg(cfg_data, idx, addr, val, data_size);
	idx++;

	return idx;
}


// SRAM_DATA[15:4] contains the 12-bit waveform data.
// SRAM_DATA[3:0] reserved.
//
// 为了调试方便，这个函数后面会改为从一个文件中直接读取波形数据
//
uint ini_ad9106_ram_data( int *ram_data, uint data_size ){

	uint addr, val;
	uint idx = 0;

	double pi = 3.14159;

	int cnt=0;
	for( addr = AD9106_SRAM_ADDR_START; addr <= AD9106_SRAM_ADDR_STOP; addr++ ){
		double x = cnt*2*pi/4095;
		double y = sin(x)+1.001;
		val = (int)( y/2.001 * (pow(2,8)-1) );
		*(ram_data+addr) = (addr << 16) + (val << 4);
		cnt++;
	}

	return idx;
}

void print_ad9106_cfg_data( int *ad9106_data, uint data_size ){
	int i;
	for(i=0; i<data_size; i++ ){
		printf_bin(ad9106_data[i]);
	}
}