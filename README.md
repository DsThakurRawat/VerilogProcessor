# 🧠 MIPS Processor (Verilog Implementation)

A **simple multi-cycle MIPS processor** implemented in **Verilog HDL**.  
This project demonstrates the working of a basic MIPS architecture — including **instruction fetch, decode, execute, memory, and write-back stages** — with instruction and data memory simulated using internal registers.

---

## ⚙️ Project Overview

This Verilog design implements a **miniature MIPS CPU** capable of executing a small set of instructions.  
It uses a **finite state machine (FSM)** to cycle through all major pipeline stages sequentially.

### Key Features
- 🧩 **Instruction Set Simulation** (Arithmetic, Branch, Jump, Memory)
- 🧮 **Register File** (32 × 8-bit)
- 💾 **Instruction Cache (I-Cache)** and **Data Cache (D-Cache)**
- 🔁 **Finite State Machine (FSM)**-based control flow
- 💡 **LED Output Register** displaying final result
- 🕒 **Clock-based operation** (`posedge clk`)

---

## 🧩 Instruction Set Implemented

| Opcode / Function | Type | Mnemonic | Description |
|--------------------|-------|-----------|--------------|
| `000000 100001` | R | **ADDU** | Add unsigned (`rd = rs + rt`) |
| `000000 101010` | R | **SLT** | Set less than (`rd = (rs < rt) ? 1 : 0`) |
| `000000 001000` | R | **JR** | Jump to register (`PC = RegisterFile[31]`) |
| `001001` | I | **ADDIU** | Add immediate unsigned (`rt = rs + imm`) |
| `000100` | I | **BEQ** | Branch if equal |
| `000101` | I | **BNE** | Branch if not equal |
| `010111` | I | **LW (Simulated)** | Load from data cache |
| `000011` | J | **JAL** | Jump and link |

---

## 🧠 Processor Architecture

### 🏗️ Main Components
- **Program Counter (PC)** – tracks current instruction  
- **Instruction Memory (`i_cache`)** – stores 14 preloaded instructions  
- **Data Memory (`d_cache`)** – simulates simple memory for load instructions  
- **Register File (`RegisterFile`)** – 32 general-purpose 8-bit registers  
- **State Machine (`state`)** – controls pipeline stages:
  1. Instruction Fetch  
  2. Instruction Decode  
  3. Operand Fetch  
  4. Execution  
  5. Memory / Write-back  
  6. Output Stage

---

## 🧮 Internal Workflow

```text
┌─────────────────────────────────────────────┐
│                  FSM STATES                 │
├─────────────────────────────────────────────┤
│ 0: Fetch        → Load instruction          │
│ 1: Decode       → Extract opcode, rs, rt... │
│ 2: ReadRegs     → Read operands             │
│ 3: Execute      → Perform ALU/Branch/Jump   │
│ 4: Memory       → Access data if required   │
│ 5: WriteBack    → Update registers          │
│ 6: Output       → Display result on LEDs    │
└─────────────────────────────────────────────┘
