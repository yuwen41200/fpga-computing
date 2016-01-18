## 3. Feasibility Study: FPGA Parallel Heterogeneous Computing ##
https://github.com/yuwen41200/fpga-computing

## 3.1. Why FPGAs ? ##
FPGA is the abbreviation for "field programmable gate array." We consider FPGAs a suitable choice for heterogeneous computing because FPGAs are essentially massively parallel processors. Furthermore, fully customized hardware design can lead to maximized optimization. Past research has also showed that using FPGAs as accelerators can realize better performance than using GPGPUs. If the data transmission interface is also PCIe, then the cost is almost the same as GPGPUs.

## 3.2. Drawbacks ##
The performance of the circuit is highly dependent on the quality of the circuit design and the available resources on the FPGA development board. Though some EDA (electronic design automation) tools, like Xilinx SDAccel, support high-level synthesis that can convert OpenCL C/C++ codes into schematics, these techniques are not mature enough, and may lead to poor performance.

## 3.3. Proposed Implementation ##
We employ RTL (register-transfer level) design by the Verilog HDL (hardware description language), and we use the Xillybus IP core [2] for data transmission over the PCIe interface. Our targeted board is Xilinx Virtex-5 ML506 Evaluation Platform. We use C++ for software design. The host programs run on 64-bit Linux distributions.

## 3.4. Computation Platform ##
The PC-end (host) is on the left side, whereas the FPGA-end (device) is on the right side.
![img-demo0][img-demo0]

## 3.5. Problem Statement ##
color &#x000D7; 1.125 ^ 1024

## 3.6. Kernel Instantiation ##

## 3.7. FSM (Finite-State Machine) ##

## 3.8. Data Interface ##

## 3.9. Multithreading on Software ##

## 3.10. Results ##
| Data Size | Serial<br>(Singlethread) | CPU Multithreading<br>(OpenMP) | GPGPU Accelerator<br>(CUDA) | FPGA Accelerator |
|:----:|-----:|-----:|-----:|-----:|
| Small<br>(128 KiB) | 0.179096 s | 0.067667 s | 0.891333 s | 0.000534 s |
| _Speedup_ | **1.000 x** | **2.647 x** | **0.201 x** | **335.386 x** |
| Large<br>(~12 MiB) | 15.873200 s | 4.678667 s | 1.799333 s | 0.016104 s |
| _Speedup_ | **1.000 x** | **3.393 x** | **8.822 x** | **985.668 x** |

## 3.11. Platform Specification ##
| Platform | Detailed Description |
|-----:|:-----|
| Serial<br>(Singlethread) | Intel Core i5-3570 CPU @ 3.40GHz 4C4T, 8 GB Memory, Ubuntu 14.04 LTS 64-bit |
| CPU Multithreading<br>(OpenMP) | Intel Core i5-3570 CPU @ 3.40GHz 4C4T, 8 GB Memory, Ubuntu 14.04 LTS 64-bit,<br>using up to 4 threads |
| GPGPU Accelerator<br>(CUDA) | Intel Core i7-3770 CPU @ 3.40Ghz 4C8T, 16 GB Memory, Windows 10 Enterprise 64-bit,<br>NVIDIA GeForce GTX 670 |
| FPGA Accelerator | Intel Core i5-3570 CPU @ 3.40GHz 4C4T, 8 GB Memory, Ubuntu 14.04 LTS 64-bit,<br>Xilinx Virtex-5 ML506 Evaluation Platform |

## 9. Endnote ##
Special thanks to Chun-Jen Tsai, associate professor at Dept. of C.S., N.C.T.U., Taiwan. Prof. Tsai not only lent me experiment equipment, but gave me some advice on this topic.

## 10. References ##
[2] Xillybus Ltd. (2016). _An FPGA IP Core for Easy DMA over PCIe with Windows and Linux_ [Online]. Available: http://xillybus.com/

[img-demo0]: https://github.com/yuwen41200/fpga-computing/raw/master/docs/demo0.png
