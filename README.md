# FPGA Computing #

Research Project on FPGA Parallel Heterogeneous Computing

This is a subproject of [sunset1995/parallel_analysis](https://github.com/sunset1995/parallel_analysis).

## Introduction ##

The targeted board is Xilinx Virtex-5 ML506.  
The host program runs on Ubuntu Linux 14.04 LTS.

This project uses an Xillybus IP core for data transmission over an PCIe interface.  
One can download it for free from [xillybus.com](http://xillybus.com/) for academic purposes.  
For more information, please refer to [the licensing page](http://xillybus.com/licensing).

The RTL design is done with Xilinx ISE Design Suite 14.7.

## Results ##

| Data Size | Serial (Singlethread) | CPU Multithreading | GPGPU Accelerator (CUDA) | FPGA Accelerator |
|:---------:|----------------------:|-------------------:|-------------------------:|-----------------:|
| Small     | 0.179096 s            |                    |                          | 0.000534 s       |
| _Speedup_ | **1.000 x**           |                    |                          | **335.386 x**    |
| Large     | 15.873200 s           |                    |                          | 0.016104 s       |
| _Speedup_ | **1.000 x**           |                    |                          | **985.668 x**    |
