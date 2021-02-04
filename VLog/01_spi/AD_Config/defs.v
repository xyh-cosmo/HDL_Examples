//	This file is to be included in the following verilog files:
//	1) spi_base.v 
//	2) spi_ad5628.v
//	3) spi_ad9106.v
//	4) spi_ltc2271.v
//
//	when this SPI name definition file is inclued, the SPI_BASE
//	can determine the values of A0 and A0 via the given 'SPI name'
//  so that the corresponding CS signal will be pulled down for the
//	READY to WORK SPI device.
//	
//	Note: CS signal si decoded by "CD74HC".

//	A0  A1
//	1	1	CS3 = 0, AD5628 will work
//	0	1	CS2 = 0, LTC2271A (U25) will work
//	1	0	CS1 = 0, AD9106 will work
//	0	0	CS4 = 0, LTC2271B (U26) will work


`ifndef _SPI_NAMES_
`define _SPI_NAMES_

parameter SPI_AD5628	= 4'd1;
parameter SPI_AD9106	= 4'd2;
parameter SPI_2271A		= 4'd3;
parameter SPI_2271B		= 4'd4;
parameter SPI_DEFAULT	= SPI_AD5628;

`endif
