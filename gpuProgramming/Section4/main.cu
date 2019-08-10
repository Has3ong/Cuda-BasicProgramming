#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "kernel.cuh"

int main() {

	cudaSetDevice(0);

	int N, M, K;
	N = M = 10000;
	K = 1;

	double *A, *B, *C, *d_A, *d_B, *d_C;

	A = (double *)malloc(sizeof(double) * N * M);
	B = (double *)malloc(sizeof(double) * M * K);
	C = (double *)malloc(sizeof(double) * N * K);

	cudaMalloc(&d_A, sizeof(double) * N * M);
	cudaMalloc(&d_B, sizeof(double) * M * K);
	cudaMalloc(&d_C, sizeof(double) * N * K);

	for (int i = 0; i < N * M; i++) {
		A[i] = 1.;
	}
	for (int j = 0; j < M *K; j++) {
		B[j] = 1.;
	}
	for (int k = 0; k < N * K; k++) {
		C[k] = 0.;
	}

	cudaMemcpy(d_A, A, sizeof(double) * N * M, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, B, sizeof(double) * M * K, cudaMemcpyHostToDevice);
	cudaMemcpy(d_C, C, sizeof(double) * N * K, cudaMemcpyHostToDevice);

	cudaDeviceProp devProp;
	cudaGetDeviceProperties(&devProp, 0);
	int nThreads = (int)(devProp.maxThreadsPerBlock / 4);
	int nBlocks = 65535;

	//////////////////////////////////////////////////////////////////////////////////////////
	// Device Computing

	cudaEvent_t d_begin, d_end;

	cudaEventCreate(&d_begin);
	cudaEventCreate(&d_end);

	cudaEventRecord(d_begin);

	Kernel <<< nBlocks, nThreads > > > (N, M, K, d_A, d_B, d_C);

	cudaEventRecord(d_end);


	cudaMemcpy(C, d_C, sizeof(double) * N * K, cudaMemcpyDeviceToHost);

	cuEventSynchronize(d_end);

	float timeValue;
	cudaEventElapsedTime(&timeValue, d_begin, d_end);

	printf("The time of Device:\t %f \n", timeValue);


	//////////////////////////////////////////////////////////////////////////////////////////
	// Host Computing

	double *h_C;
	h_C = (double *)malloc(sizeof(double) * N * K);

	clock_t start = clock(), diff;
	
	for (int i = 0; i < N * K; i++) {
		int index = i;
		h_C[index] = 0.;
		getMulti(N, M, K, index, A, B, h_C);
	}
	
	diff = clock() - start;

	int milisec = diff * 1000 / CLOCKS_PER_SEC;

	printf("The time of Host:\t %d \n", milisec);

	//////////////////////////////////////////////////////////////////////////////////////////
	// Host Computing End

	printf("C[100]:\t %f \n", C[100]);
	printf("h_C[100]:\t %f \n", h_C[100]);

	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

	free(A);
	free(B);
	free(C);

	return 0;
}