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
void reduction(int* input, int*out){//sum reduction
	__shared__ float partial[2*BLOCK_SIZE];
	
	unsigned int t = threadIdx.x;
	unsigned int start = 2*blockIdx.x*blockDim.x;
	partial[t]=input[start+t];
	partial[blockDim.x + t]=input[start + blockDim.x + t];
	
	for(unsigned int stride =1; stride<= blockDim.x; stride*=2){
		__syncthreads();
		if(t%stride ==0){
			partial[2*t]+= partial[2*t+stride];
			out[0]= partial[2*t];
		}
	}	
}

int main (){
	int N = 15;
	int* values, *dv, *sum, *ds;
	values = (int*)malloc(N*sizeof(int));
	sum = (int*)malloc(1*sizeof(int));
	cudaMallocManaged(&dv, N*sizeof(int));
	cudaMallocManaged(&ds, 1*sizeof(int));

	for (int i = 0; i < SIZE; i++) {
		values[i] = rand()%(N-0+1);
	}
	//to print array
	//for (int i = 0; i < SIZE; i++) {
		//printf("%d ", values[i]);
		//}

	//printf("\n");
	
	//cpu sum
	int s = 0;
	for (int i = 0; i < SIZE; i++) {
		s += values[i];
	}
	printf("%d\n ", s);
	printf("\n");
	
	//gpu sum
	cudaMemcpy(dv, values, N*sizeof(int), cudaMemcpyHostToDevice); 
	double t0 = get_clock();
	reduction<<<1, BLOCK_SIZE>>>(dv,ds);
	cudaDeviceSynchronize();
	double t1 = get_clock();
	
	cudaMemcpy(sum, ds, 1*sizeof(int), cudaMemcpyDeviceToHost);
	//need kernel here
	printf("%d\n", sum[0]);	

	printf("\n");
	printf("Time: %f ns\n", (1000000000.0*(t1-t0)));
}
