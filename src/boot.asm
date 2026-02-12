; very normal bootloader, basically straight from wiki

org 0x7c00
bits 16

start:
    cli
    cld
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    mov [dap_num_sectors], word 127 
    mov [dap_offset], word 0x7e00 
    mov [dap_segment], word 0x0000
    mov dword [dap_lba], 1          

    mov si, dap
    mov ah, 0x42
    mov dl, 0x80   
    int 0x13
    jc disk_error

    jmp 0x0000:0x7e00 

disk_error:
    mov ah, 0x0e
    mov al, 'E' ; means error
    int 0x10
    hlt

align 4
dap:
    db 0x10
    db 0
dap_num_sectors: dw 0
dap_offset:      dw 0
dap_segment:     dw 0
dap_lba:         dq 0

times 510-($-$$) db 0
dw 0xAA55
