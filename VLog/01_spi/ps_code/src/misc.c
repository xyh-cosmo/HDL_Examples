#include "common.h"
#include "misc.h"

int binstr2int(char *str, int *x){

	int str_len = strlen(str);
	char tmp[128];

	strncpy(tmp,str,2);
	if( strcmp(tmp, "0b") == 0 || strcmp(tmp, "0B") == 0 ){
		memset(tmp,0,128);
		strcpy(tmp,str+2);
	} else {
		printf("Error: *str = %s\n", str);
		return _FAILURE_;
	}

	*x = 0;
	int i_max = str_len-2;
	for( int i=0; i<i_max; i++ ){
		if( tmp[i] == '1' ){
			*x += 1 << (i_max-i-1);
		}
	}

	return _SUCCESS_;
}