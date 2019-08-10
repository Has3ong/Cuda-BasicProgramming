#include <stdio.h>
#include <stdlib.h>

#include "kernel.cuh"

int main() {

	cudaSetDevice(0);

	int N, M, K;
	N = M = 3;
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

	int nTreads = N * K;
	Kernel  <<< 1, N * K >>> (N, M, K, A, B, C);

	cudaMemcpy(C, d_C, sizeof(double) * N * K, cudaMemcpyDeviceToHost);
	return 0;
}