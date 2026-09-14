.code16
.globl start
start:
movb $0x13, %ah # instruction 0x13h (write string)
lea  hello, %bp # string pointer
movb 2, %al  # write mode, cursor moves
movb $0,    %bh # page number
mov $12, %cx # length of string
movb $8, %dh # row number
movb $0, %dl # col number
movb $7,    %bl # color
int $0x10

stop:
jmp stop

hello:
.string "Hello World!"

.org 0x1fe
.word 0xAA55
