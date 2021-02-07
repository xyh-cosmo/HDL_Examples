#include <stdio.h>
#include <stdlib.h>
#include "common.h"

int binstr2int(char *str);

int main( int argc, char *argv[] ){

	// if( argc < 2 ){
	// 	printf("usage: %s bin_data_file\n", argv[0]);
	// 	return 0;
	// }

	// char fname[1024];
	// sprintf(fname,"%s",argv[1]);

	// FILE *fp = fopen(fname,"r");

	// uint dat[11];	// data/bin_data.txt has 11 data

	// char tmp[128];
	// uint idx = 0;
	
	// // while( fscanf(fp,"%i",&tmp) != EOF ){
	// while( fscanf(fp,"%s",tmp) > 0 ){
	// 	// dat[idx] = atoi(tmp);
	// 	// printf_bin(dat[idx]);
	// 	printf(" tmp = %s\n",tmp);
	// 	idx++;
	// 	if(idx == 11)
	// 		break;
	// }


	char str[1024] = "0b10101";
	int tmp;

	binstr2int(str);

	// fclose(fp);

}

int binstr2int(char *str){
	int str_len = strlen(str);
	char *tmp = (char *)malloc(sizeof(char)*str_len);
	printf("str_len = %d\n", str_len);
	int dat = 0;
	for( int i=2; i<str_len; i++ ){
		tmp[i] = str[i];
		// printf("str[%d] = %c\n",i, str[i]);
		printf("str[%d] = %c\n",i, str[i]);
		int x=0;
		if( tmp[i] == '1' ) x = 1;
		dat += (x << (str_len-i-1));
	}
	printf("tmp = %s\n",tmp);
	printf(" dat = %d\n", dat);
	// print_as_bin(dat);
	printf_bin(dat);
	free(tmp);

	return 0;
}