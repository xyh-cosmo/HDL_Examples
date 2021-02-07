#include <stdio.h>
#include <stdlib.h>
#include "common.h"
#include "spi.h"
#include "misc.h"

int main( int argc, char *argv[] ){

	if( argc < 2 ){
		printf("usage: %s bin_data_file\n", argv[0]);
		return 0;
	}

	char fname[1024];
	sprintf(fname,"%s",argv[1]);

	FILE *fp = fopen(fname,"r");
	char tmp[128];

	int d;
	while( fscanf(fp,"%s",tmp) != EOF ){
	// while( fscanf(fp,"%s",tmp) > 0 ){
		binstr2int(tmp,&d);
		// print_as_bin(d);
		printf_bin(d);
	}

	fclose(fp);

}

