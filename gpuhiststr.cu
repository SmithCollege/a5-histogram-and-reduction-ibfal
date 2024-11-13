#include <iostream>
#include <math.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#define BLOCK_SIZE 128
#define SIZE 10
#define BUCKETS 2

double get_clock() {
  struct timeval tv; int ok;
  ok = gettimeofday(&tv, (void *) 0);
  if (ok<0) { printf("gettimeofday error"); }
  return (tv.tv_sec * 1.0 + tv.tv_usec * 1.0E-6);
}

__global__ void hist(unsigned char*array, long size, unsigned int*histo){
	int i = blockIdx.x *blockDim.x + threadIdx.x;
	int stride = blockDim.x * gridDim.x;
	
	if(i>=size){
		return;
	}
	while (i<size){
		int value = array[i];
		int bin = (value % BUCKETS);
		atomicAdd(&(histo[bin]),1);
		i+=stride;
	}
}

int main(){
	unsigned char * array =(unsigned char*)malloc(sizeof(char)*SIZE);
	unsigned int* histo = (unsigned int*)malloc(sizeof(int)*SIZE);

	for(int i=0; i<SIZE; i++){
		array[i]=i;
	}
	printf("\n");

	unsigned char*dArray;
	cudaMalloc(&dArray, SIZE);
	cudaMemcpy(dArray,array,SIZE,cudaMemcpyHostToDevice);

	unsigned int * dHist;
	cudaMalloc(&dHist,BUCKETS*sizeof(int));
	cudaMemset(dHist,0,BUCKETS*sizeof(int));

	dim3 block(32);
	dim3 grid((SIZE+block.x-1)/block.x);

	cudaDeviceSynchronize();
	double t0 = get_clock();
	hist<<<grid,block>>>(dArray,SIZE,dHist);
	cudaDeviceSynchronize();
	double t1 = get_clock();

	cudaMemcpy(histo,dHist,BUCKETS *sizeof(int),cudaMemcpyDeviceToHost);

	for (int i=0;i<BUCKETS; i++){
		printf(" %d |", histo[i]);
	}
	printf("\n");
	printf("Time: %f ns\n", (1000000000.0*(t1-t0)));
	printf("\n");
}
