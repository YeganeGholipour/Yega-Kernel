%macro isr_err_stub 1
isr_stub_%+%1:
    ; push interrupt number
    push dword %1

    ; push registers
    pusha

    ; push segment registers
    push ds
    push es
    push fs
    push gs

    ; load kernel data segment selector into DS/ES/FS/GS
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; pass pointer to registers struct
    mov eax, esp
    push eax

    call exception_handler

    add esp, 4       ; remove arg to handler
    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8       ; remove int_no + dummy err_code
    
    iret 
%endmacro

%macro isr_no_err_stub 1
isr_stub_%+%1:
    ; push dummy error code
    push dword 0

    ; push interrupt number
    push dword %1

    ; push registers
    pusha

    ; push segment registers
    push ds
    push es
    push fs
    push gs

    ; load kernel data segment selector into DS/ES/FS/GS
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; pass pointer to registers struct
    mov eax, esp
    push eax

    call exception_handler

    add esp, 4       ; remove arg to handler
    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8       ; remove int_no + dummy err_code

    iret
%endmacro

extern exception_handler

isr_no_err_stub 0
isr_no_err_stub 1
isr_no_err_stub 2
isr_no_err_stub 3
isr_no_err_stub 4
isr_no_err_stub 5
isr_no_err_stub 6
isr_no_err_stub 7
isr_err_stub    8
isr_no_err_stub 9
isr_err_stub    10
isr_err_stub    11
isr_err_stub    12
isr_err_stub    13
isr_err_stub    14
isr_no_err_stub 15
isr_no_err_stub 16
isr_err_stub    17
isr_no_err_stub 18
isr_no_err_stub 19
isr_no_err_stub 20
isr_no_err_stub 21
isr_no_err_stub 22
isr_no_err_stub 23
isr_no_err_stub 24
isr_no_err_stub 25
isr_no_err_stub 26
isr_no_err_stub 27
isr_no_err_stub 28
isr_no_err_stub 29
isr_err_stub    30
isr_no_err_stub 31

global isr_stub_table

isr_stub_table:
%assign i 0
%rep    32
    dd isr_stub_%+i
%assign i i+1
%endrep