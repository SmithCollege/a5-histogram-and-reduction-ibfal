#include <iostream>
#include <math.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#define BLOCK_SIZE 128
#define SIZE 25000

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
	
	for(unsigned int stride =blockDim.x; stride>=1; stride>>=1){
		__syncthreads();
		if(t<stride){
			partial[t]+= partial[t+stride];
			out[0]= partial[t];
		}
	}	
} 

int main (){
	int* values, *dv, *sum, *ds;
	values = (int*)malloc(SIZE*sizeof(int));
	sum = (int*)malloc(1*sizeof(int));
	cudaMallocManaged(&dv, SIZE*sizeof(int));
	cudaMallocManaged(&ds, 1*sizeof(int));

	for (int i = 0; i < SIZE; i++) {
		values[i] = rand()%(10-0+1);
	}
	
	//gpu sum
	cudaMemcpy(dv, values, SIZE*sizeof(int), cudaMemcpyHostToDevice); 
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
