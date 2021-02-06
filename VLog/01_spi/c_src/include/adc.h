#ifndef _ADC_H_
#define _ADC_H_


#define _SPI_SUCCESS_	0
#define _SPI_SEND_OK_	0
#define _SPI_FAILURE_ 	1

//	PS writes register via a pointer pointing to ADDR_GPIO_OUT
#define ADDR_GPIO_OUT	0x41200000

//	PS reads register via a pointer pointing to ADDR_GPIO_IN
#define ADDR_GPIO_IN	0x41210000

int get_bit(int a, int bit_num);

typedef struct{
	int cpol;
	int cpha;
	char devname[1024];
} SPI_CONFIG;

typedef struct{
	int size;
	int *reg_addr;
	int *reg_val;
	int *reg_addr_val;
} SPI_DATA;


int AD5628_do_config();
int AD9106_do_config();


int setup_SPI( SPI_CONFIG * spi_cfg, int cpol, int cpha, char *devname );
int spi_data_alloc( SPI_DATA *spi_data, int data_size );
int spi_data_free( SPI_DATA *spi_data );
int spi_data_set( SPI_DATA *spi_data, int idx, int addr, int val );

int send_spi_data_32bits( int addr_gpio_out, int addr_gpio_in, int data );
int send_spi_data( int addr_gpio_out, int addr_gpio_in, SPI_DATA *spi_data );


#endif