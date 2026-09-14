#include "mmu.h"
#include "asm.h"

.code16
.global start
start:
movb $0x03, %ah # instruction 0x03h (get cursor position) sets DH and DL with row and col respectivly
int $0x10
movb $0x13, %ah # instruction 0x13h (write string)
lea  startmsg, %bp # string pointer
movb $1, %al  # write mode, cursor moves
movb $0,    %bh # page number
mov $45, %cx # length of string
movb $7,    %bl # color
int $0x10

movb $0x00, %ah # instruction 0x00 (read keypress)
int $0x16

movb $0x00, %ah # switch to video mode
int $0x10

startmsg:
.string "Welcome to xv6@UIC. Press any key to continue"


# Change to 32-bit protected mode so we can run C code
cli
lgdt    gdtdesc
movl    %cr0, %eax
orl     $CR0_PE, %eax
movl    %eax, %cr0

ljmp    $(SEG_KCODE<<3), $start32
.code32  # Tell assembler to generate 32-bit code now.
start32:

movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
movw    %ax, %ds                # -> DS: Data Segment
movw    %ax, %ss                # -> SS: Stack Segment

mov     $0x1000, %esp
call splashmain

loop:
    jmp loop

hello: .string "xv6 @ UIC rocks!"

# Bootstrap GDT
.p2align 2                                # force 4 byte alignment
gdt:
  SEG_NULLASM                             # null seg
  SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)   # code seg
  SEG_ASM(STA_W, 0x0, 0xffffffff)         # data seg

gdtdesc:
  .word   (gdtdesc - gdt - 1)             # sizeof(gdt) - 1
  .long   gdt                             # address gdt