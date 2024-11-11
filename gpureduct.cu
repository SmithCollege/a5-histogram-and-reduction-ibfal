#include <iostream>
#include <math.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#define SIZE 10
#define BLOCK_SIZE 32

double get_clock() {
  struct timeval tv; int ok;
  ok = gettimeofday(&tv, (void *) 0);
  if (ok<0) { printf("gettimeofday error"); }
  return (tv.tv_sec * 1.0 + tv.tv_usec * 1.0E-6);
}

__global__ 
void reduction(int* input. int*out){//sum reduction
	__shared__ float partial[2*BLOCK_SIZE];
	
	unsigned int t = threadIdx.x;
	unsigned int start = 2*blockIdx.x*blockDim.x;
	partial[t]=input[start+t];
	partial[blockDim+t]=input[start+blockDim.x+t];
	
	for(unsigned int stride =1; stride<= blockDim.x; stride*=2){
		__syncthreads();
		if(t%stride ==0){
			partial[2*t]+= partial[2*t+stride];
		}
	}
	out[0]=	partial[2*t];
}

int sum(int * arr){
	int sum = 0;
	for (int i = 0; i < SIZE; i++) {
		sum += arr[i];
	}
	return sum;
}

int main (){
	int N = 15;
	int* values, *sum;
	cudaMallocManaged(&values, sizeof(int) * BLOCK_SIZE);
	cudaMallocManaged(&sum, sizeof(int));

	for (int i = 0; i < SIZE; i++) {
		values[i] = rand()%(N-0+1);
	}

	for (int i = 0; i < SIZE; i++) {
		printf("%d ", values[i]);
		}

	printf("\n");
	//cpu sum
	printf("%d\n ", sum(values));
	
	printf("\n");
	//gpu sum
	//need kernel here
	printf("%d\n", sum[0]);	

}
