#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define SIZE 1000

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
	int* values = malloc(sizeof(int) * SIZE);

	for (int i = 0; i < SIZE; i++) {
		values[i] = rand()%(10-0+1);//this ensures boundaries for how high the numbers can be generated.
	}

	for (int i = 0; i < SIZE; i++) {
		printf("%d ", values[i]);
		}

	printf("\n");
	//sum
	double t0 = get_clock();
	printf("%d\n ", sum(values));
	double t1 = get_clock();
	printf("Time sum: %f ns\n", (1000000000.0*(t1-t0)));
	printf("\n");
		
	//product
	t0 = get_clock();
	printf("%d\n ", product(values));
	t1 = get_clock();
	printf("Time product: %f ns\n", (1000000000.0*(t1-t0)));
	printf("\n");
	
	//min
	t0 = get_clock();
	printf("%d\n ", min(values));
	t1 = get_clock();
	printf("Time min: %f ns\n", (1000000000.0*(t1-t0)));
	printf("\n");
	
	//max
	t0 = get_clock();
	printf("%d\n ", max(values));
	t1 = get_clock();
	printf("Time max: %f ns\n", (1000000000.0*(t1-t0)));
			  
}
