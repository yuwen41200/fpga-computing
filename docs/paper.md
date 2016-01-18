## 3. Feasibility Study: FPGA Parallel Heterogeneous Computing ##
https://github.com/yuwen41200/fpga-computing

## 3.1. Why FPGAs ? ##
FPGA is the abbreviation for "field programmable gate array." We consider FPGAs a suitable choice for heterogeneous computing because FPGAs are essentially massively parallel processors. Furthermore, fully customized hardware design can lead to maximized optimization. Past research has also showed that using FPGAs as accelerators can realize better performance than using GPGPUs. If the data transmission interface is also PCIe, then the cost is almost the same as GPGPUs.

## 3.2. Drawbacks ##
The performance of the circuit is highly dependent on the quality of the circuit design and the available resources on the FPGA development board. Though some EDA (electronic design automation) tools, like Xilinx SDAccel, support high-level synthesis that can convert OpenCL C/C++ codes into schematics, these techniques are not mature enough, and may lead to poor performance.

## 3.3. Proposed Implementation ##
• Employ RTL (register-transfer level) design by the
Verilog HDL (hardware description language)
• Use the Xillybus IP core for data transmission over
the PCIe interface
• Targeted board: Xilinx Virtex-5 ML506 Evaluation
Platform

• Use C++ for software design
• The host programs run on 64-bit Linux distributions

## PC ##

FPGA

## Problem Statement ##
color 1.1251024

← Hardware Version
↓ Software Version

## Kernel Instantiation ##

## FSM (Finite-State Machine) ##

## Data Interface ##

## Multithreading on Software ##

## Platform Specification ##
• Serial: Intel Core i5-3570 CPU @ 3.40GHz 4C4T,
8 GB Memory, Ubuntu 14.04 LTS 64-bit
• CPU: Intel Core i5-3570 CPU @ 3.40GHz 4C4T,
8 GB Memory, Ubuntu 14.04 LTS 64-bit,
using up to 4 threads
• GPGPU: Intel Core i7-3770 CPU @ 3.40Ghz 4C8T,
16 GB Memory, Windows 10 Enterprise 64-bit,
NVIDIA GeForce GTX 670
• FPGA: Intel Core i5-3570 CPU @ 3.40GHz 4C4T,
8 GB Memory, Ubuntu 14.04 LTS 64-bit,
Xilinx Virtex-5 ML506 Evaluation Platform

## Results ##
Data Size

Serial
(Singlethread)

CPU Multithreading
(OpenMP)

GPGPU Accelerator
(CUDA)

FPGA Accelerator

Small
(128 KiB)

0.179096 s

0.067667 s

0.891333 s

0.000534 s

Speedup

1.000 x

2.647 x

0.201 x

335.386 x

Large
(~12 MiB)

15.873200 s

4.678667 s

1.799333 s

0.016104 s

Speedup

1.000 x

3.393 x

8.822 x

985.668 x

## Attribution ##
Special thanks to Chun-Jen Tsai,
assistant professor at Dept. of C.S., NCTU
