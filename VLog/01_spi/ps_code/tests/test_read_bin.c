#include <stdio.h>
#include <stdlib.h>
#include "common.h"

int main( int argc, char *argv[] ){

	if( argc < 2 ){
		printf("usage: %s bin_data_file\n", argv[0]);
		return 0;
	}

	char fname[1024];
	sprintf(fname,"%s",argv[1]);

	FILE *fp = fopen(fname,"r");

	uint dat[11];	// data/bin_data.txt has 11 data

	char tmp[128];
	uint idx = 0;
	
	// while( fscanf(fp,"%i",&tmp) != EOF ){
	while( fscanf(fp,"%s",tmp) > 0 ){
		// dat[idx] = atoi(tmp);
		// printf_bin(dat[idx]);
		printf(" tmp = %s\n",tmp);
		idx++;
		if(idx == 11)
			break;
	}

	fclose(fp);

}