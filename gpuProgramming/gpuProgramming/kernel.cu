#include "kernel.cuh"

double getValue(int N, int M, int row, int col, double* List) {
	int index = row * M + col;
	return List[index];
}

double getRowIndex(int N, int M, int index) {
	return (int)(index / M);
}

int getColIndex(int N, int M, int index) {
	return (int)(index % M);
}

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

void Kernel(int N, int M, int K, double* A, double* B, double* C) {

	int index = 0;
	//gpuProgramming Properties -> CUDA C/C++ -> Command Line -> Additional Option
	//-Xcompiler "/openmp"

	omp_set_num_threads(2);

#pragma omp parallel for private(index)
	for (index = 0; index < N*K; index++) {
		getMulti(N, M, K, index, A, B, C);
	}
}