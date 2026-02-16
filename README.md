# Simple-Processor
## 📌 Project Overview
This project implements a basic multi-cycle processor using SystemVerilog. The processor features a 9-bit data width, 8 general-purpose registers (R0-R7), a simple ALU for arithmetic operations (addition and subtraction), and a Finite State Machine (FSM) based Control Unit. 

It is designed for educational purposes, demonstrating fundamental computer architecture concepts, RTL design, and simulation using Intel Quartus.

## 🏗️ System Architecture & Block Diagram
The system follows a standard structural design, separating the datapath from the control logic.
## 🗂 File Structure
`simproc.sv`: The top-level test environment connecting the PC, ROM, and Processor.

`proc.sv`: The main processor module instantiating the Datapath and Control Unit.

`datapath.sv`: Contains the registers (`R0`-`R7`, `IR`, `A`, `G`), the multiplexer bus, and the ALU.

`controlunit.sv`: The FSM (T0-T3) that decodes instructions and orchestrates datapath operations.

`procmodule.sv`: Primitives like N-bit registers (`regn`), multiplexers (`muxn`), and the ALU (`AddSub`).

`myROM.sv` & `my_ROM.mif`: Synchronous ROM module and its initialization file containing machine code.
## ⚙️ Instruction Set Architecture (ISA)
Instruction format (9-bit): `[Opcode: 3-bit] [Rx: 3-bit] [Ry: 3-bit]`

| Instruction | Opcode | Functionality | Clock Cycles |
| :--- | :---: | :--- | :---: |
| `mv Rx, Ry` | `000` | $R_x \leftarrow R_y$ | 2 (T0, T1) |
| `mvi Rx, #D` | `001` | $R_x \leftarrow D$ (loads immediate data from next memory address) | 2 (T0, T1) |
| `add Rx, Ry` | `010` | $R_x \leftarrow R_x + R_y$ | 4 (T0, T1, T2, T3) |
| `sub Rx, Ry` | `011` | $R_x \leftarrow R_x - R_y$ | 4 (T0, T1, T2, T3) |
## 🚀 How to Run and Simulate
1. Open Intel Quartus II and create a new project.

2. Add all `.sv` files to the project.

3. Ensure `my_ROM.mif` is in the root directory of the project.

4. Set `simproc` as the Top-Level Entity.

5. Compile the design.

6. Use ModelSim or Quartus Waveform `(.vwf)` to simulate the processor. Toggle the `Resetn` signal (0 then 1) at the start, and supply a clock signal to observe `BusWires` and `Done` signals.
