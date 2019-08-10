#include <stdio.h>
#include <stdlib.h>

#include "kernel.cuh"

int main() {

	int N, M, K;
	N = M = 3;
	K = 1;

	double *A, *B, *C;

	A = (double *)malloc(sizeof(double) * N * M);
	B = (double *)malloc(sizeof(double) * M * K);
	C = (double *)malloc(sizeof(double) * N * K);

	for (int i = 0; i < N * M; i++) {
		A[i] = 1.;
	}
	for (int j = 0; j < M *K; j++) {
		B[j] = 1.;
	}
	for (int k = 0; k < N * K; k++) {
		C[k] = 0.;
	}

	Kernel(N, M, K, A, B, C);

	int index = 0;

	while (true) {
		for (int i = 0; i < K; i++) {
			printf("%f \t ", C[index]);
			index += 1;
		}

		printf("\n");
		if (N * K <= index) break;
	}
	return 0;
}