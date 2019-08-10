#ifndef KERNEL_CUH
#define KERNEL_CUH
#include <omp.h>

double getValue(int N, int M, int row, int col, double* List);

double getRowIndex(int N, int M, int index);

int getColIndex(int N, int M, int index);

void getMulti(int N, int M, int K, int index, double* A, double* B, double* C);

void Kernel(int N, int M, int K, double* A, double* B, double* C);

#endif