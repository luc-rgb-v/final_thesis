/* Define reset entry symbol */
ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 64K
}

SECTIONS
{
    /* Force location counter to reset address */
    . = ORIGIN(RAM);
    PROVIDE(_start = .);

    .text : ALIGN(4)
    {
        *(.text*)
        *(.rodata*)
    } > RAM

    .data : ALIGN(4)
    {
        *(.data*)
    } > RAM

    .bss (NOLOAD) : ALIGN(4)
    {
        *(.bss*)
        *(COMMON)
    } > RAM

    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
    PROVIDE(_stack_pointer = _stack_top);
}
