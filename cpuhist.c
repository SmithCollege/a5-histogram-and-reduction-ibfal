#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int main(){
	float hist[23]={1.0,2.1,1.9,4.8,3.1,4.1,1.0,1.0,3.1,3.1,4.1,1.9,1.0,2.1,3.1,3.1,3.1,1.9,1.2,1.0,1.9,2.1,3.8}; 

	int results[5] = {0};

	for (int i=0; i<6; ++i){
		for (int j=0; j < 23;j++){
			if((hist[j]<=i)&&(hist[j]>i-1)){
				results[i]++;
			}
		}
	}
	printf("\n");
	for (int i = 1; i< 6; i++){
		printf(" %d |", results[i]);
	}
	printf("\n");
}
