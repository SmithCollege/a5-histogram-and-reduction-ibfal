#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define SIZE 10

double get_clock() {
  struct timeval tv; int ok;
  ok = gettimeofday(&tv, (void *) 0);
  if (ok<0) { printf("gettimeofday error"); }
  return (tv.tv_sec * 1.0 + tv.tv_usec * 1.0E-6);
}

int sum(int * arr){
	int sum = 0;
	for (int i = 0; i < SIZE; i++) {
		sum += arr[i];
	}
	return sum;
}

int product(int * arr){
	int p = arr[0];
	for (int i = 1; i < SIZE; i++) {
		p *= arr[i];
	}
	return p;
}

int min(int * arr){
	int m = arr[0];
	for (int i = 1; i < SIZE; i++) {
		if (arr[i]< m){
			m = arr[i];
		}			
	}
	return m;
}

int max(int * arr){
	int m = arr[0];
	for (int i = 1; i < SIZE; i++) {
		if (arr[i]> m){
			m = arr[i];
		}			
	}
	return m;
}
int main (){
	int N = 15;
	int* values = malloc(sizeof(int) * SIZE);

	for (int i = 0; i < SIZE; i++) {
		values[i] = rand()%(N-0+1);
	}

	for (int i = 0; i < SIZE; i++) {
		printf("%d ", values[i]);
		}

	printf("\n");
	//sum
	printf("%d\n ", sum(values));	
	//product
	printf("%d\n ", product(values));
	//min
	printf("%d\n ", min(values));
	//max
	printf("%d\n ", max(values));
			  
}
