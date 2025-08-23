# DSP48A1 FPGA Slice (Verilog)

This project implements a **behavioral Verilog model** of the **Xilinx Spartan-6 DSP48A1 slice**, widely used in math-intensive FPGA applications. The design supports parameterized pipelining, pre-adder/subtractor, multiplier, and post-adder/subtractor functionality.

## Features

* Supports both **synchronous** and **asynchronous resets**
* Parameterized registers:

  * A0REG, A1REG, B0REG, B1REG
  * CREG, DREG, MREG, PREG
  * OPMODEREG, CARRYINREG, CARRYOUTREG
* Flexible input routing:

  * `B_INPUT = DIRECT or CASCADE`
* Configurable carry-in selection:

  * `CARRYINSEL = OPMODE5 or CARRYIN`
* Modular design with **gray\_mux\_sync** and **gray\_mux\_async** for pipelining
* **Self-checking SystemVerilog testbench** with directed test patterns

## Verification

* Simulated in **QuestaSim / Vivado Simulator**
* Testbench includes 4 directed test paths verifying:

  * Reset operation
  * Pre-adder/subtractor
  * Multiplier
  * Post-adder with feedback and cascade paths
* 100 MHz clock constraint (Vivado XDC file)

## Tools

* **HDL**: Verilog / SystemVerilog
* **Simulation**: QuestaSim
* **Synthesis**: Xilinx Vivado
* **Target FPGA**: Spartan-6 / Artix-7 (xc7a200tffg1156-3)


## References

* Xilinx Spartan-6 DSP48A1 User Guide ([UG389](https://www.xilinx.com/support/documentation/user_guides/ug389.pdf))
  
