#include "kernel.cuh"

__host__ __device__
double getValue(int N, int M, int row, int col, double* List) {
	int index = row * M + col;
	return List[index];
}

__host__ __device__
double getRowIndex(int N, int M, int index) {
	return (int)(index / M);
}

__host__ __device__
int getColIndex(int N, int M, int index) {
	return (int)(index % M);
}

__host__ __device__
void getMulti(int N, int M, int K, int index, double* A, double* B, double* C) {
	C[index] = 0.;

	int row = getRowIndex(N, K, index);
	int col = getColIndex(N, K, index);

	for (int i = 0; i < M; i++) {
		double a = getValue(N, M, row, i, A);
		double b = getValue(M, K, i, col, B);

		C[index] += a * b;
	}
}

__global__
void Kernel(int N, int M, int K, double* A, double* B, double* C) {

	int id = blockDim.x * blockIdx.x + threadIdx.x;

	if (id < N * K) {
		getMulti(N, M, K, id, A, B, C);
	}
}