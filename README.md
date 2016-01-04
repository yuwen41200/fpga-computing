# FPGA Computing #

Research Project on FPGA Parallel Heterogeneous Computing  
https://github.com/yuwen41200/fpga-computing/raw/master/docs/final.pdf

This is a subproject of [sunset1995/parallel_analysis](https://github.com/sunset1995/parallel_analysis).

## Introduction ##

The targeted board is Xilinx Virtex-5 ML506.  
The host program runs on Ubuntu Linux 14.04 LTS.

This project uses an Xillybus IP core for data transmission over an PCIe interface.  
One can download it for free from [xillybus.com](http://xillybus.com/) for academic purposes.  
For more information, please refer to [the licensing page](http://xillybus.com/licensing).

The RTL design is done with Xilinx ISE Design Suite 14.7.

## Results ##

| Data Size          | Serial<br>(Singlethread) | CPU Multithreading<br>(OpenMP) | GPGPU Accelerator<br>(CUDA) | FPGA Accelerator |
|:------------------:|-------------------------:|-------------------------------:|----------------------------:|-----------------:|
| Small<br>(128 KiB) | 0.179096 s               | 0.067667 s                     | 0.891333 s                  | 0.000534 s       |
| _Speedup_          | **1.000 x**              | **2.647 x**                    | **0.201 x**                 | **335.386 x**    |
| Large<br>(~12 MiB) | 15.873200 s              | 4.678667 s                     | 1.799333 s                  | 0.016104 s       |
| _Speedup_          | **1.000 x**              | **3.393 x**                    | **8.822 x**                 | **985.668 x**    |

## Platform Specification ##

+ Serial: Intel Core i5-3570 CPU @ 3.40GHz x 4/4, 8 GB Memory, Ubuntu 14.04 64-bit
+ CPU: Intel Core i5-3570 CPU @ 3.40GHz x 4/4, 8 GB Memory, Ubuntu 14.04 64-bit, using up to 4 threads
+ GPGPU: Intel Core i7-3770 CPU @ 3.40Ghz x 4/8, 16 GB Memory, Windows 10 64-bit, NVIDIA GeForce GTX 670
+ FPGA: Intel Core i5-3570 CPU @ 3.40GHz x 4/4, 8 GB Memory, Ubuntu 14.04 64-bit, ML506 Evaluation Platform
