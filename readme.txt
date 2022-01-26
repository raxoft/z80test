Welcome to the Zilog Z80 CPU test suite.

This set of programs is intended to help the emulator authors reach the
desired level of the CPU emulation authenticity. Each of the included programs
performs an exhaustive computation using each of the tested Z80 instructions,
compares the results with values obtained from a real 48K Spectrum with Zilog Z80 CPU,
and reports any deviations detected.

The following variants are available:

- z80full - tests all flags and registers.
- z80doc - tests all registers, but only officially documented flags.
- z80flags - tests all flags, ignores registers.
- z80docflags - tests documented flags only, ignores registers.
- z80ccf - tests all flags after executing CCF after each instruction tested.
- z80ccfscr - visualise (random) behavior of flags after CCF instruction.
- z80memptr - tests all flags after executing BIT N,(HL) after each instruction tested.

The first four are the standard tests for CPU emulation. When building an emulator,
make sure the documented ones work first, then move on to the undocumented features.
The undocumented flags are not that hard to emulate and are now documented thoroughly,
but there are instructions which require special treatment, namely BIT N,(HL) and BIT N,(IX+d),
which depend on an internal register known as MEMPTR, and, quite surprisingly, SCF and CCF.

People couldn't agree on the behavior of bits 5 and 3 of the flags register after SCF and CCF.
And it turned out there was a reason for that. In 2012, it was discovered that the
behavior depends on whether the previous instruction modified the flags or not.
David Banks documented three different variants on his page here:
https://github.com/hoglet67/Z80Decoder/wiki/Undocumented-Flags#scfccf

The CCF variant of the Z80 test is thus designed to thoroughly test the authentic SCF/CCF
behavior after each Z80 instruction. Note that it assumes the genuine Zilog behavior
and it will fail half of the tests on CPUs which use other variant, so don't bother.

However, there were also reports that some CPUs exhibited random behavior after SCF and CCF.
For example, the NEC CPUs were originally believed to behave in a non-deterministic fashion.
Recent discoveries however proved that any CPU model is susceptible to random behavior,
depending on what board it is placed in, subject to external factors outside of the CPU.

The z80ccfscr test was thus created to detect such behavior. In an emulator, it will produce stable
pattern which at quick glance reveals which CPU variant it emulates (see reference images).
However, when run on a real machine, it will also show whether the CPU suffers from random
bus drift or not - if it does, some of the pixels will flicker randomly.
Note that it doesn't mean the board or the CPU is faulty, it just means that the
combination is not stable enough to execute SCF and CCF instructions in a deterministic way.
For the record, the Zilog CPUs were almost always stable in real machines, unlike some of the CPUs
from other manufacturers, but even those suffered from this randomness in some specific boards.

Finally, the MEMPTR variant of the test can be used to discover major problems in
the MEMPTR emulation - however note that the current set of test vectors was not
specifically designed to stress test MEMPTR, so many of the possible
problems are very likely left undetected. I may eventually add specific
MEMPTR tests in later releases.

Enjoy!

Patrik Rak
