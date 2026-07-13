# Summary of RISC-V Priviliged Architecture

### Privilige Levels

At any given time, a RISC-V hardware thread runs in one of three modes. They are defined as:

| Level | Encoding | Name | Abbreviation |
|---|---|---|---|
| 0 | 00 | User | U |
| 1 | 01 | Supervisor | S |
| 2 | 11 | Machine | M |

Privilige Levels are required for protection causing an exception to be raised, if a violation occurs when a current privilige level tries to perform a task not governed by it. The **Machine mode** has the highest authority and it is the only mandatory level for a RISC-V hardware platform. The other two are optional modes but are required for protection against incorrect application codes. Each prvilige level has a set priviliged ISA instructions.
Implementation provides one of three modes trading off reduced isolation for lower implementation cost. All hardware implementations must have M-mode as it is the only mode with unfettered access to the whole machine. Some may provide U-mode for protection of the system against the application code. S-mode is added to provide isolation between supervisor-level software and SEE.

| Number of Levels | Supported Modes | Intended Usage | 
|---|---|---|
| 1 | M | Simple Embedded Systems | 
| 2 | M, U | Secure Embedded Systems | 
| 3 | M, S, U | Systems running Unix-level OS |

### Key CSR's

**1. mstatus**

The *Machine Mode Status* register is a MXLEN-bit read/write register formatted for RV32 and RV 64.This register keeps record of and control's the hart's current operating state(Privilige Level).
Global interrupt enable bits are primarily used to gurantee atomicity with respect to interrupt handlers in the currentr privilige mode. When a hart is operating in a privilige mode *x*, interrupts are globally enabled when *x*IE=1 or disabled when this value is 0. The interrupts are globally disabled for a privilge level lower than the current privilige level and are enabled for privilige level greater than the current one irrespective of their global Interrupt enable values.

**2. mtvec**

The *Machine Trap Vector and Base address* register is an MXLEN-bit WARL read/write register that holds trap vector configuration, consisting of a vector base address (BASE) and a vector mode (MODE).
The mtvec register must always be implemented, but can contain a read-only value. If mtvec is writable, the set of values the register may hold can vary by implementation. When MODE=Direct, all traps into machine mode cause the pc to be set to the address in the BASE field.  When MODE=Vectored, all synchronous exceptions into machine mode cause the pc to be set to the address in the BASE field, whereas interrupts cause the pc to be set to the address in the BASE field plus four times the interrupt cause number. 

**3. mepc**

*Machine Exception Program Counter* is an MXLEN-bit read/write register. The low bit of mepc (mepc[0]) is always zero. On implementations that support only IALIGN=32, the two low bits (mepc[1:0]) are always zero. 
The mepc is a WARL register that must be able to hold all valid virtual addresses. When a trap is taken into M-mode, mepc is written with the virtual address of the instruction that was interrupted or that encountered the exception.

**4. mcause**

The *Machine Cause* register is an MXLEN-bit read-write register. When a trap is taken into M-mode, mcause is written with a code indicating the event that caused the trap. The Interrupt bit in the mcause register is set if the trap was caused by an interrupt. The Exception Code field contains a code identifying the last exception or interrupt. The Exception Code is a WLRL field, so is only guaranteed to hold supported exception codes. 

**5. mtval**

The *Machine Trap Value* register is an MXLEN-bit read-write register. When a trap is taken into M-mode, mtval is either set to zero or written with exception-specific information to assist software in handling the trap.
If mtval is written with a nonzero value when a breakpoint, address-misaligned, access-fault, page-fault, or hardware-error exception occurs on an instruction fetch, load, or store, then mtval will contain the faulting virtual address. On a breakpoint exception raised by an EBREAK instruction, mtval is written with either zero or the virtual address of the instruction

### Trap Handling Flow

When a trap occurs due to some illlegal instruction or an ecall/ebreak instruction, several things happen as a package. When a trap occurs, the hardware sets the mepc register to the address of the instruction that triggers the trap, the mcause register to the source of the trap, the relevant interrupt-enable bit to 0 to disable further interrupts, and the mtval register to additional information about the trap, with the program counter then redirected to the address held in the trap vector register.
The trap handler handles the situation by reading the mcause and responding appropriately. The MRET instruction is used to return from a trap in M-mode, and it restores the previous privilege mode and interrupt-enable state that were saved when the trap was taken, then sets the program counter back to the value in the exception program counter.