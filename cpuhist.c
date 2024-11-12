#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int main(){
	float * hist[10];
	// make hist the array with all the values already in it. 

	float results[10] = {0};
	//whatever size array we have, dont need the values its jsut an empty array. 

	for (int i=0; i<topvalue; ++i){//make i add by an certain amount?
		for (int j=0; j < sizeofarr;j++){
			if(hist[j]<=i){
				results[i]++;
			}
		}
	}
	printf("\n");
	printHistogram(results, 10);
	
}
