#ifndef KERNEL_CUH
#define KERNEL_CUH

#include <omp.h>
#include <cuda.h>
#include <cudnn.h>
#include "device_launch_parameters.h"

__host__ __device__
double getValue(int N, int M, int row, int col, double* List);

__host__ __device__
double getRowIndex(int N, int M, int index);

__host__ __device__
int getColIndex(int N, int M, int index);

__host__ __device__
void getMulti(int N, int M, int K, int index, double* A, double* B, double* C);

__global__
void Kernel(int N, int M, int K, double* A, double* B, double* C);

#endif