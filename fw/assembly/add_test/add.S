    .section .text
    .globl  _start
_start:
    /* test: t2 = t0 + t1  where t0=5, t1=7 -> expect 12 */
    li      t0, 5        /* operand A */
    li      t1, 7        /* operand B */
    add     t2, t0, t1   /* t2 <- t0 + t1 */

    /* expected value */
    li      t3, 12

    /* if t2 != expected -> fail */
    bne     t2, t3, fail

    /* success: write 1 to tohost and loop */
    la      t4, tohost
    li      t5, 1
    sw      t5, 0(t4)
    j       hang

fail:
    /* failure: write 2 to tohost and loop */
    la      t4, tohost
    li      t5, 2
    sw      t5, 0(t4)

hang:
    /* spin here forever so simulator doesn't run into random memory */
    j hang

    .section .data
    .align 4
    .global tohost
tohost:
    .word 0
