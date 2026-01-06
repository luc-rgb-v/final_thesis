ENTRY(_start)

MEMORY
{
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 64K
}

SECTIONS
{
  .text : {
    KEEP(*(.text._start))   /* force start.S first */
    *(.text*)
    *(.rodata*)
  } > RAM

  .data : {
    *(.data*)
  } > RAM

  .bss : {
    *(.bss*)
    *(COMMON)
  } > RAM

  . = ALIGN(8);
  _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
