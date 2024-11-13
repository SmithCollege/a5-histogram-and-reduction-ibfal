#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define SIZE 10
#define BUCKETS 5


double get_clock() {
  struct timeval tv; int ok;
  ok = gettimeofday(&tv, (void *) 0);
  if (ok<0) { printf("gettimeofday error"); }
  return (tv.tv_sec * 1.0 + tv.tv_usec * 1.0E-6);
}

int main(){
	int *hist = malloc(sizeof(int) * SIZE);
	int results[BUCKETS]= {0};

	for (int i = 0; i < SIZE; i++) {
		hist[i] = i;
		}
	double t0 = get_clock();
		for (int j=0; j < SIZE;j++){
			if((hist[j]<SIZE)){
				int bin=(hist[j]%BUCKETS);
				results[bin]++;
			}
		}
	double t1 = get_clock();
	
	printf("\n");
	for (int i = 0; i< BUCKETS; i++){
		printf(" %d |", results[i]);
	}
	printf("\n");
	printf("Time: %f ns\n", (1000000000.0*(t1-t0)));
	printf("\n");
}
