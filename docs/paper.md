## 3. Feasibility Study: FPGA Parallel Heterogeneous Computing ##
In this section, we are going to examine the effectiveness of FPGA parallel heterogeneous computing, especially for the purpose of video processing. All source codes for this section are available on [https://github.com/yuwen41200/fpga-computing].

## 3.1. Why FPGAs ? ##
FPGA is the abbreviation for _field programmable gate array_. We consider FPGAs a suitable choice for heterogeneous computing because FPGAs are essentially massively parallel processors. Furthermore, fully customized hardware design can lead to maximized optimization. Past research has also showed that using FPGAs as accelerators can realize better performance than using GPGPUs. If the data transmission interface is also PCIe, then the cost is almost the same as GPGPUs.

## 3.2. Drawbacks ##
The performance of the circuit is highly dependent on the quality of the circuit design and the available resources on the FPGA development board. Though some EDA (electronic design automation) tools, like Xilinx SDAccel, support high-level synthesis that can convert OpenCL C/C++ codes into schematics, these techniques are not mature enough, and may lead to poor performance.

## 3.3. Proposed Implementation ##
We employ RTL (register-transfer level) design by the Verilog HDL (hardware description language), and we use the Xillybus IP core [2] for data transmission over the PCIe interface. Our targeted board is Xilinx Virtex-5 ML506 Evaluation Platform (w/ XC5VSX50T FPGA). We use C++ for software design. The host programs run on 64-bit Linux distributions.

![img-demo1][img-demo1]  
![img-demo2][img-demo2]

## 3.4. Computation Platform ##
The PC-end (host) is on the left side, whereas the FPGA-end (device) is on the right side.

![img-demo0][img-demo0]

## 3.5. Problem Statement ##
We want to evaluate `color × 1.125 ^ 1024`.

## 3.6. Kernel Instantiation ##
We use a _generate block_ to instantiate 256 kernel modules, namely, 256 simultaneously running threads. Each kernel module calculates a single color value, so the FPGA can calculate at most 256 values at the same time.

## 3.7. FSM (Finite-State Machine) ##
There are 4 states: `IDLE_STATE`, `RECV_STATE`, `EXEC_STATE`, and `SEND_STATE`. After the program starts, the circuit goes to the second state. The second state waits and receives 256 color values, until then, it goes to the third state. The third state processes the 256 received values in parallel, then it goes to the last state. The last state waits and sends 256 new values back, and goes to the first state again.

![img-demo3][img-demo3]

## 3.8. Data Interface ##
To hosts, the device looks just like a file. So we can use low-level (POSIX) file I/O functions to read/write data from/to the device, i.e. the FPGA board.

## 3.9. Multithreading on Software ##
For best performance, there are also 2 threads implemented on the host. The first is used to send data, the other is used to receive data.

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

## 9. Endnotes ##
Special thanks to Chun-Jen Tsai, associate professor at Dept. of C.S., National Chiao Tung University, Taiwan. Prof. Tsai not only lent me experiment equipment, but gave me some advice on this topic.

## 10. References ##
[2] Xillybus Ltd. (2016). _An FPGA IP Core for Easy DMA over PCIe with Windows and Linux_ [Online]. Available: [http://xillybus.com/]

[https://github.com/yuwen41200/fpga-computing]: https://github.com/yuwen41200/fpga-computing
[img-demo1]: https://github.com/yuwen41200/fpga-computing/raw/master/docs/demo1.jpg
[img-demo2]: https://github.com/yuwen41200/fpga-computing/raw/master/docs/demo2.jpg
[img-demo0]: https://github.com/yuwen41200/fpga-computing/raw/master/docs/demo0.png
[img-demo3]: https://github.com/yuwen41200/fpga-computing/raw/master/docs/demo3.png
[http://xillybus.com/]: http://xillybus.com/
