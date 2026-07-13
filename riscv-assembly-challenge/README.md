# RISC-V Assembly Programming 

**MEDS Lab — Module 3: RISC-V Instruction Set Architecture**
Summer Training Programme 2026 • Cohort 4

## Overview

This repository contains the Grand Assignment for Module 3, covering array processing,
recursion, and instruction encoding/decoding in RV32I RISC-V assembly. All programs are
written for and tested in [Venus](https://venus.cs61c.org/), UC Berkeley's web-based
RISC-V simulator.

## Repository Structure

```
riscv-assembly-challenge/
├── README.md                      # This file
├── .gitignore
├── part1_array_ops.s              # Part 1: Array processing
├── part2_recursion.s              # Part 2: Recursive merge sort
├── part3_encoding.s               # Part 3: Instruction decoder
├── screenshots/                   # Venus screenshots showing output
└── docs/
    ├── ENCODING_WORKSHEET.md      # Hand-encoded instructions (R/I/S/B/U/J)
    ├── PRIVILEGED_SUMMARY.md      # Privileged spec self-study
    └── EXTENSION_SUMMARY.md       # "A" extension self-study
```

## How to Run

1. Open [https://venus.cs61c.org/](https://venus.cs61c.org/) in a browser.
2. Copy the contents of the desired `.s` file into the Editor tab.
3. Click **Assemble**, then switch to the **Simulator** tab.
4. Click **Run** to execute the full program, or **Step** to walk through it
   instruction-by-instruction.
5. Program output (printed values) appears in the console panel; array contents can be
   inspected directly in the **Memory** panel.

No installation or local toolchain is required — everything runs in-browser.

## Part 1 — Array Processing (`part1_array_ops.s`)

Given a signed integer array (including negative values), implements four functions, 
each following the calling convention `(a0 = array_ptr, a1 = size) → a0 = result`:

| Function | Description |
|---|---|
| `sum_array` | Returns the sum of all elements |
| `find_min` | Returns the minimum (signed) value |
| `find_max` | Returns the maximum (signed) value |
| `count_negative` | Returns the count of negative elements |

`main` calls each function in turn and prints its labeled result. All functions are leaf
functions, so none require a stack frame.

## Part 2 — Recursive Merge Sort (`part2_recursion.s`)

Implements genuine recursive merge sort on a array, sorting it in place and printing 
the result.

- `merge_sort(arr, left, right)` recursively splits the range in half, sorts each half,
  then merges them back together.
- The merge step copies each half into temporary `.data` scratch buffers
  (`subarray1`, `subarray2`) before writing the merged, sorted result back into the
  original array.
- Follows the RISC-V calling convention throughout: `ra` and all used `s`-registers
  (`s1`–`s11`) are saved in the prologue and restored in the epilogue, since `merge_sort`
  is non-leaf (it calls itself twice, plus performs the merge) and must protect `arr`,
  `left`, `right`, and `mid` across both recursive calls.
- Base case (`left >= right`) and the recursive case both route through a single shared
  epilogue label, rather than returning early with a mismatched stack.

## Part 3 — Instruction Encoding (`part3_encoding.s` + `docs/ENCODING_WORKSHEET.md`)

- `ENCODING_WORKSHEET.md` hand-encodes six instructions — one each of R, I, S, B, U, and
  J format — into 32-bit hex values, with the bit-field breakdown shown for each.
- `part3_encoding.s` loads those six hex values as raw `.word` data and, for each one,
  extracts `opcode`, `rd`, `funct3`, and `rs1` using shift-and-mask operations (`srli` +
  `andi`), printing each field. U-type and J-type instructions (identified by opcode)
  correctly skip printing `funct3`/`rs1`, since those formats don't encode those fields.

## Self-Study Deliverables (`docs/`)

- **`PRIVILEGED_SUMMARY.md`** — privilege levels (M/S/U), the key machine-mode CSRs
  (`mstatus`, `mtvec`, `mepc`, `mcause`, `mtval`), and the trap handling flow, based on
  the RISC-V Privileged Specification.
- **`EXTENSION_SUMMARY.md`** — the "A" (Atomic) extension: AMO and LR/SC instructions,
  why plain `lw`/`sw` is unsafe across multiple cores, and practical applications
  (spinlocks, safe counters, lock-free data structures).

## Notes

- All register usage follows the standard calling convention: `a0`–`a7` for
  arguments/return values, `t0`–`t6` for scratch values that don't need to survive a
  function call, `s0`–`s11` for values that must survive a call (saved/restored in
  prologue/epilogue).
- Every program ends with the exit syscall (`a0 = 10; ecall`).