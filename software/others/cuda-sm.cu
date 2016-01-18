#include "cuda_runtime.h"
#include <cstdio>
#include <iostream>
#include <algorithm>
#include <ctime>

using namespace std;

__global__ void blue(unsigned short *mat, int height, int width)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x
		, j = blockIdx.y * blockDim.y + threadIdx.y;
	if (i < height && j < width) {
		unsigned short mi = mat[i * width + j];
		for (int k = 0; k < 1024; k++)
			mi = mi + (mi >> 3);
		mat[i * width + j] = mi;
	}
}


int Video() {
	// Setup video capture device
	// Link it to the first capture device
	cudaError_t err;

	int i, j;
	clock_t cnt = 0, cnt_io = 0;

	unsigned short *hmat, *dmat = NULL;



	int rows = 256, cols = 256;
	int size = rows * cols * sizeof(unsigned short);
	hmat = (unsigned short *)malloc(size);
	for (i = 0; i < rows; i++)
		for (j = 0; j < cols; j++)
			hmat[i * cols + j] = i * cols + j;


	clock_t last = clock();

	dmat = NULL;
	err = cudaMalloc(&dmat, size); if (err != cudaSuccess) { puts("Error!"); return 1; }
	err = cudaMemcpy(dmat, hmat, size, cudaMemcpyHostToDevice);
	if (err != cudaSuccess)
	{
		fprintf(stderr, "Failed while Memcpying ! %s\n", cudaGetErrorString(err));
		return 1;
	}

	dim3 blk(32, 32);
	dim3 grid(rows / blk.x, cols / blk.y);
	blue << <grid, blk >> >(dmat, rows, cols);
	cnt += clock() - last;
	err = cudaGetLastError();
	if (err != cudaSuccess)
	{
		fprintf(stderr, "Failed launching kernel! %s\n", cudaGetErrorString(err));
		return 1;
	}

	err = cudaMemcpy(hmat, dmat, size, cudaMemcpyDeviceToHost);
	if (err != cudaSuccess)
	{
		fprintf(stderr, "Failed while Memcpying back! %s\n", cudaGetErrorString(err));
		return 1;
	}

	cnt += clock() - last;


	cout << endl << "Results from frame 0: " << endl;
	for (int i = 0; i < 256; ++i)
		for (int j = 0; j < 256; ++j)
			cout << hmat[i * cols + j] << " ";

	printf("Total = %fms\n", 1.0*cnt / (1.0*CLOCKS_PER_SEC / 1000.0));

	cudaFree(dmat);
	free(hmat);

	return 0;
}

int main()
{
	Video();
	while (1);
	return 0;
}
