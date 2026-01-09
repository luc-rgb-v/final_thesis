ENTRY(_start)

MEMORY
{
  IMEM (rx)  : ORIGIN = 0x80000000, LENGTH = 4K
  DMEM (rwx) : ORIGIN = 0x80010000, LENGTH = 2K
}

SECTIONS
{
  /* ================= IMEM ================= */
  .text : {
    _text_start = .;
    KEEP(*(.text._start))
    *(.text*)
    *(.rodata*)
    _text_end = .;
  } > IMEM

  /* ================= DMEM ================= */
  .data : {
    _data_start = .;
    *(.data*)
    _data_end = .;
  } > DMEM

  .bss (NOLOAD) : {
    _bss_start = .;
    *(.bss*)
    *(COMMON)
    _bss_end = .;
  } > DMEM

  /* Stack */
  _stack_size = 512;
  _stack_top = ORIGIN(DMEM) + LENGTH(DMEM);
  _stack_bottom = _stack_top - _stack_size;

  /DISCARD/ : {
    *(.eh_frame*)
    *(.gcc_except_table*)
    *(.comment*)
    *(.debug*)
  }
}


