# Extension Summary

## "A"  Atomic Instructions

## What It Adds

The RISC-V "A" extension adds instructions that atomically read-modify-write memory, enabling safe synchronization between multiple RISC-V harts (hardware threads) sharing the same memory space. Every instruction covered in this module so far (lw, sw, etc.) assumes a single core is the only thing touching memory. Once multiple cores run concurrently, a plain lw → modify → sw sequence is unsafe: two cores could both read the same value before either writes back, causing one update to silently overwrite the other (a lost update / race condition). The A extension solves this by making read-modify-write sequences indivisible at the hardware level.

## Key Instructions

The extension provides two mechanisms:

**1. AMO (Atomic Memory Operations)**: combine a load, an operation, and a store into a single, uninterruptible instruction:

``` 
amoadd.w t0, t1, (a0)   # atomically: t0 = Mem[a0]; Mem[a0] = Mem[a0] + t1 
```

Other AMO variants include amoswap, amoand, amoor, amoxor, and signed/unsigned amomax/amomin, several of which mirror the same operations from RV32I's own R-type instructions (add, and, or, xor), just made atomic.

**2. LR/SC (Load-Reserved / Store-Conditional)**: a more flexible pair for read-modify-write sequences that don't fit a single fixed AMO operation:

```
retry:
    lr.w  t0, (a0)       # load, and register a reservation on this address
    addi  t0, t0, 1        # ordinary computation — not atomic by itself
    sc.w  t1, t0, (a0)      # store succeeds only if nothing else wrote here since lr.w
    bnez  t1, retry            # if the store failed, retry the whole sequence
```

lr.w loads a value and reserves the address; sc.w writes conditionally, succeeding only if no other hart wrote to that address in between. This "optimistic retry" pattern allows arbitrary computation between the load and the store, unlike a single AMO.

## Practical Applications

- **Spinlocks / mutexes**: amoswap.w.aq can atomically test-and-set a lock flag; amoswap.w.rl releases it.
- **Safe shared counters**: e.g., multiple cores incrementing a shared statistic without losing updates, the exact scenario a plain lw/add/sw sequence would get wrong.
- **Lock-free data structures**: LR/SC-based compare-and-swap loops underpin lock-free queues and stacks used in high-performance concurrent systems.
- **Memory-mapped I/O**: atomically setting, clearing, or toggling individual bits in a hardware device register without disturbing other bits another core or driver may be touching at the same time.