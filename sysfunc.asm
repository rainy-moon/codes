[bits 32]
global _hlt
global _cli
global _sti
global _io_out8
global _io_out16
global _io_out32
global _io_in8
global _io_in16
global _io_in32
global _load_gdt
global _load_idt
global _WORDS
global _asm_inthandler21h
global _asm_inthandler27h
global _asm_inthandler2ch
global _stihlt
extern _inthandler21h
extern _inthandler27h
extern _inthandler2ch
[segment .text]

_hlt: ; void hlt()
	hlt
	ret

_cli: ; void cli()
	cli
	ret

_sti: ;void sti()
	sti
	ret
_stihlt: ;void stihlt()
	sti
	hlt
	ret
_io_out8: ; void io_out8(int port, int data)
	mov edx,[esp+4]
	mov eax,[esp+8]
	out dx,al
	ret

_io_out16: ; void io_out16(int port, int data)
	mov edx,[esp+4]
	mov eax,[esp+8]
	out dx,ax
	ret

_io_out32: ; void io_out32(int port, int data)
	mov edx,[esp+4]
	mov eax,[esp+8]
	out dx,eax
	ret

_io_in8: ; unsigned char io_in8(int port)
	mov edx,[esp+4]
	mov eax,0
	in al,dx
	ret

_io_in16: ; unsigned short io_in16(int port)
	mov edx,[esp+4]
	mov eax,0
	in ax,dx
	ret

_io_in32: ; unsigned int io_in32(int port)
	mov edx,[esp+4]
	in eax,dx
	ret
_load_gdt:; void load_gdt(int limit,int addr)
	mov ax,[esp+4]
	mov [esp+6],ax
	lgdt [esp+6]
	ret
_load_idt:; void load_idt(int limit,int addr)
	mov ax,[esp+4]
	mov [esp+6],ax
	lidt [esp+6]
	ret
_asm_inthandler21h: ;void asm_inthandler21h()
	push es
	push ds
	pushad
	mov eax,esp
	push eax
	mov ax,ss
	mov ds,ax
	mov es,ax
	call _inthandler21h
	pop eax
	popad
	pop ds
	pop es
	iretd
_asm_inthandler27h:;void asm_inthandler27h()
	push es
	push ds
	pushad
	mov eax,esp
	push eax
	mov ax,ss
	mov ds,ax
	mov es,ax
	call _inthandler27h
	pop eax
	popad
	pop ds
	pop es
	iretd
_asm_inthandler2ch:;void asm_inthandler2ch()
	push es
	push ds
	pushad
	mov eax,esp
	push eax
	mov ax,ss
	mov ds,ax
	mov es,ax
	call _inthandler2ch
	pop eax
	popad
	pop ds
	pop es
	iretd

	
_WORDS: ;0x00-0x7f 128words 
	DB 0x3C,0x52,0x91,0x91,0x91,0x9D,0x81,0x42,0x3C,0x00,0x00,0xDB,0xDB,0x00,0x00,0x00, ;加载/等待指针（圆圈）
	DB 0x80,0xC0,0xE0,0xD0,0xE8,0xF4,0xFE,0xFF,0xFF,0xF0,0xC4,0x90,0x04,0x0E,0x06,0x00, ;箭头指针（三角）
	TIMES 14*16 DB 0
	TIMES 16*16 DB 0
	
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,; ,0
	DB 0x00, 0x00, 0x00, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00,;!,1
	DB 0x00, 0x12, 0x36, 0x24, 0x48, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,;",2
	DB 0x00, 0x00, 0x00, 0x24, 0x24, 0x24, 0xFE, 0x48, 0x48, 0x48, 0xFE, 0x48, 0x48, 0x48, 0x00, 0x00,;#,3
	DB 0x00, 0x00, 0x10, 0x38, 0x54, 0x54, 0x50, 0x30, 0x18, 0x14, 0x14, 0x54, 0x54, 0x38, 0x10, 0x10,;$,4
	DB 0x00, 0x00, 0x00, 0x44, 0xA4, 0xA8, 0xA8, 0xA8, 0x54, 0x1A, 0x2A, 0x2A, 0x2A, 0x44, 0x00, 0x00,;%,5
	DB 0x00, 0x00, 0x00, 0x30, 0x48, 0x48, 0x48, 0x50, 0x6E, 0xA4, 0x94, 0x88, 0x89, 0x76, 0x00, 0x00,;&,6
	DB 0x00, 0x60, 0x60, 0x20, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,;',7
	DB 0x00, 0x02, 0x04, 0x08, 0x08, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x08, 0x08, 0x04, 0x02, 0x00,;(,8
	DB 0x00, 0x40, 0x20, 0x10, 0x10, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x10, 0x10, 0x20, 0x40, 0x00,;),9
	DB 0x00, 0x00, 0x00, 0x00, 0x10, 0x10, 0xD6, 0x38, 0x38, 0xD6, 0x10, 0x10, 0x00, 0x00, 0x00, 0x00,;*,10
	DB 0x00, 0x00, 0x00, 0x00, 0x10, 0x10, 0x10, 0x10, 0xFE, 0x10, 0x10, 0x10, 0x10, 0x00, 0x00, 0x00,;+,11
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x60, 0x60, 0x20, 0xC0,;,,12
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,;-,13
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x60, 0x60, 0x00, 0x00,;.,14
	DB 0x00, 0x00, 0x01, 0x02, 0x02, 0x04, 0x04, 0x08, 0x08, 0x10, 0x10, 0x20, 0x20, 0x40, 0x40, 0x00,;/,15
	DB 0x00, 0x00, 0x00, 0x18, 0x24, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x24, 0x18, 0x00, 0x00,;0,16
	DB 0x00, 0x00, 0x00, 0x10, 0x70, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x7C, 0x00, 0x00,;1,17
	DB 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x42, 0x04, 0x04, 0x08, 0x10, 0x20, 0x42, 0x7E, 0x00, 0x00,;2,18
	DB 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x04, 0x18, 0x04, 0x02, 0x02, 0x42, 0x44, 0x38, 0x00, 0x00,;3,19
	DB 0x00, 0x00, 0x00, 0x04, 0x0C, 0x14, 0x24, 0x24, 0x44, 0x44, 0x7E, 0x04, 0x04, 0x1E, 0x00, 0x00,;4,20
	DB 0x00, 0x00, 0x00, 0x7E, 0x40, 0x40, 0x40, 0x58, 0x64, 0x02, 0x02, 0x42, 0x44, 0x38, 0x00, 0x00,;5,21
	DB 0x00, 0x00, 0x00, 0x1C, 0x24, 0x40, 0x40, 0x58, 0x64, 0x42, 0x42, 0x42, 0x24, 0x18, 0x00, 0x00,;6,22
	DB 0x00, 0x00, 0x00, 0x7E, 0x44, 0x44, 0x08, 0x08, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x00, 0x00,;7,23
	DB 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x42, 0x24, 0x18, 0x24, 0x42, 0x42, 0x42, 0x3C, 0x00, 0x00,;8,24
	DB 0x00, 0x00, 0x00, 0x18, 0x24, 0x42, 0x42, 0x42, 0x26, 0x1A, 0x02, 0x02, 0x24, 0x38, 0x00, 0x00,;9,25
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00,;:,26
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x10, 0x20,;;,27
	DB 0x00, 0x00, 0x00, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x00, 0x00,;<,28
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE, 0x00, 0x00, 0x00, 0xFE, 0x00, 0x00, 0x00, 0x00, 0x00,;=,29
	DB 0x00, 0x00, 0x00, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x00, 0x00,;>,30
	DB 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x62, 0x02, 0x04, 0x08, 0x08, 0x00, 0x18, 0x18, 0x00, 0x00,;?,31
	DB 0x00, 0x00, 0x00, 0x38, 0x44, 0x5A, 0xAA, 0xAA, 0xAA, 0xAA, 0xB4, 0x42, 0x44, 0x38, 0x00, 0x00,;@,32
	DB 0x00, 0x00, 0x00, 0x10, 0x10, 0x18, 0x28, 0x28, 0x24, 0x3C, 0x44, 0x42, 0x42, 0xE7, 0x00, 0x00,;A,33
	DB 0x00, 0x00, 0x00, 0xF8, 0x44, 0x44, 0x44, 0x78, 0x44, 0x42, 0x42, 0x42, 0x44, 0xF8, 0x00, 0x00,;B,34
	DB 0x00, 0x00, 0x00, 0x3E, 0x42, 0x42, 0x80, 0x80, 0x80, 0x80, 0x80, 0x42, 0x44, 0x38, 0x00, 0x00,;C,35
	DB 0x00, 0x00, 0x00, 0xF8, 0x44, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x44, 0xF8, 0x00, 0x00,;D,36
	DB 0x00, 0x00, 0x00, 0xFC, 0x42, 0x48, 0x48, 0x78, 0x48, 0x48, 0x40, 0x42, 0x42, 0xFC, 0x00, 0x00,;E,37
	DB 0x00, 0x00, 0x00, 0xFC, 0x42, 0x48, 0x48, 0x78, 0x48, 0x48, 0x40, 0x40, 0x40, 0xE0, 0x00, 0x00,;F,38
	DB 0x00, 0x00, 0x00, 0x3C, 0x44, 0x44, 0x80, 0x80, 0x80, 0x8E, 0x84, 0x44, 0x44, 0x38, 0x00, 0x00,;G,39
	DB 0x00, 0x00, 0x00, 0xE7, 0x42, 0x42, 0x42, 0x42, 0x7E, 0x42, 0x42, 0x42, 0x42, 0xE7, 0x00, 0x00,;H,40
	DB 0x00, 0x00, 0x00, 0x7C, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x7C, 0x00, 0x00,;I,41
	DB 0x00, 0x00, 0x00, 0x3E, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x88, 0xF0,;J,42
	DB 0x00, 0x00, 0x00, 0xEE, 0x44, 0x48, 0x50, 0x70, 0x50, 0x48, 0x48, 0x44, 0x44, 0xEE, 0x00, 0x00,;K,43
	DB 0x00, 0x00, 0x00, 0xE0, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x42, 0xFE, 0x00, 0x00,;L,44
	DB 0x00, 0x00, 0x00, 0xEE, 0x6C, 0x6C, 0x6C, 0x6C, 0x54, 0x54, 0x54, 0x54, 0x54, 0xD6, 0x00, 0x00,;M,45
	DB 0x00, 0x00, 0x00, 0xC7, 0x62, 0x62, 0x52, 0x52, 0x4A, 0x4A, 0x4A, 0x46, 0x46, 0xE2, 0x00, 0x00,;N,46
	DB 0x00, 0x00, 0x00, 0x38, 0x44, 0x82, 0x82, 0x82, 0x82, 0x82, 0x82, 0x82, 0x44, 0x38, 0x00, 0x00,;O,47
	DB 0x00, 0x00, 0x00, 0xFC, 0x42, 0x42, 0x42, 0x42, 0x7C, 0x40, 0x40, 0x40, 0x40, 0xE0, 0x00, 0x00,;P,48
	DB 0x00, 0x00, 0x00, 0x38, 0x44, 0x82, 0x82, 0x82, 0x82, 0x82, 0xB2, 0xCA, 0x4C, 0x38, 0x06, 0x00,;Q,49
	DB 0x00, 0x00, 0x00, 0xFC, 0x42, 0x42, 0x42, 0x7C, 0x48, 0x48, 0x44, 0x44, 0x42, 0xE3, 0x00, 0x00,;R,50
	DB 0x00, 0x00, 0x00, 0x3E, 0x42, 0x42, 0x40, 0x20, 0x18, 0x04, 0x02, 0x42, 0x42, 0x7C, 0x00, 0x00,;S,51
	DB 0x00, 0x00, 0x00, 0xFE, 0x92, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x38, 0x00, 0x00,;T,52
	DB 0x00, 0x00, 0x00, 0xE7, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x42, 0x3C, 0x00, 0x00,;U,53
	DB 0x00, 0x00, 0x00, 0xE7, 0x42, 0x42, 0x44, 0x24, 0x24, 0x28, 0x28, 0x18, 0x10, 0x10, 0x00, 0x00,;V,54
	DB 0x00, 0x00, 0x00, 0xD6, 0x92, 0x92, 0x92, 0x92, 0xAA, 0xAA, 0x6C, 0x44, 0x44, 0x44, 0x00, 0x00,;W,55
	DB 0x00, 0x00, 0x00, 0xE7, 0x42, 0x24, 0x24, 0x18, 0x18, 0x18, 0x24, 0x24, 0x42, 0xE7, 0x00, 0x00,;X,56
	DB 0x00, 0x00, 0x00, 0xEE, 0x44, 0x44, 0x28, 0x28, 0x10, 0x10, 0x10, 0x10, 0x10, 0x38, 0x00, 0x00,;Y,57
	DB 0x00, 0x00, 0x00, 0x7E, 0x84, 0x04, 0x08, 0x08, 0x10, 0x20, 0x20, 0x42, 0x42, 0xFC, 0x00, 0x00,;Z,58
	DB 0x00, 0x1E, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x1E, 0x00,;[,59
	DB 0x00, 0x00, 0x40, 0x40, 0x20, 0x20, 0x10, 0x10, 0x10, 0x08, 0x08, 0x04, 0x04, 0x04, 0x02, 0x02,;\,60
	DB 0x00, 0x78, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x78, 0x00,;],61
	DB 0x00, 0x1C, 0x22, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,;^,62
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,;_,63
	DB 0x00, 0x60, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,;`,64
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x1E, 0x22, 0x42, 0x42, 0x3F, 0x00, 0x00,;a,65
	DB 0x00, 0x00, 0x00, 0xC0, 0x40, 0x40, 0x40, 0x58, 0x64, 0x42, 0x42, 0x42, 0x64, 0x58, 0x00, 0x00,;b,66
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1C, 0x22, 0x40, 0x40, 0x40, 0x22, 0x1C, 0x00, 0x00,;c,67
	DB 0x00, 0x00, 0x00, 0x06, 0x02, 0x02, 0x02, 0x1E, 0x22, 0x42, 0x42, 0x42, 0x26, 0x1B, 0x00, 0x00,;d,68
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x7E, 0x40, 0x40, 0x42, 0x3C, 0x00, 0x00,;e,69
	DB 0x00, 0x00, 0x00, 0x0F, 0x11, 0x10, 0x10, 0x7E, 0x10, 0x10, 0x10, 0x10, 0x10, 0x7C, 0x00, 0x00,;f,70
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3E, 0x44, 0x44, 0x38, 0x40, 0x3C, 0x42, 0x42, 0x3C,;g,71
	DB 0x00, 0x00, 0x00, 0xC0, 0x40, 0x40, 0x40, 0x5C, 0x62, 0x42, 0x42, 0x42, 0x42, 0xE7, 0x00, 0x00,;h,72
	DB 0x00, 0x00, 0x00, 0x30, 0x30, 0x00, 0x00, 0x70, 0x10, 0x10, 0x10, 0x10, 0x10, 0x7C, 0x00, 0x00,;i,73
	DB 0x00, 0x00, 0x00, 0x0C, 0x0C, 0x00, 0x00, 0x1C, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x44, 0x78,;j,74
	DB 0x00, 0x00, 0x00, 0xC0, 0x40, 0x40, 0x40, 0x4E, 0x48, 0x50, 0x68, 0x48, 0x44, 0xEE, 0x00, 0x00,;k,75
	DB 0x00, 0x00, 0x00, 0x70, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x7C, 0x00, 0x00,;l,76
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE, 0x49, 0x49, 0x49, 0x49, 0x49, 0xED, 0x00, 0x00,;m,77
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xDC, 0x62, 0x42, 0x42, 0x42, 0x42, 0xE7, 0x00, 0x00,;n,78
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3C, 0x42, 0x42, 0x42, 0x42, 0x42, 0x3C, 0x00, 0x00,;o,79
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xD8, 0x64, 0x42, 0x42, 0x42, 0x44, 0x78, 0x40, 0xE0,;p,80
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1E, 0x22, 0x42, 0x42, 0x42, 0x22, 0x1E, 0x02, 0x07,;q,81
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xEE, 0x32, 0x20, 0x20, 0x20, 0x20, 0xF8, 0x00, 0x00,;r,82
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3E, 0x42, 0x40, 0x3C, 0x02, 0x42, 0x7C, 0x00, 0x00,;s,83
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x10, 0x7C, 0x10, 0x10, 0x10, 0x10, 0x10, 0x0C, 0x00, 0x00,;t,84
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC6, 0x42, 0x42, 0x42, 0x42, 0x46, 0x3B, 0x00, 0x00,;u,85
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE7, 0x42, 0x24, 0x24, 0x28, 0x10, 0x10, 0x00, 0x00,;v,86
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xD7, 0x92, 0x92, 0xAA, 0xAA, 0x44, 0x44, 0x00, 0x00,;w,87
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x6E, 0x24, 0x18, 0x18, 0x18, 0x24, 0x76, 0x00, 0x00,;x,88
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE7, 0x42, 0x24, 0x24, 0x28, 0x18, 0x10, 0x10, 0xE0,;y,89
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7E, 0x44, 0x08, 0x10, 0x10, 0x22, 0x7E, 0x00, 0x00,;z,90
	DB 0x00, 0x03, 0x04, 0x04, 0x04, 0x04, 0x04, 0x08, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x03, 0x00,;{,91
	DB 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,;|,92
	DB 0x00, 0x60, 0x10, 0x10, 0x10, 0x10, 0x10, 0x08, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x60, 0x00,;},93
	DB 0x30, 0x4C, 0x43, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,;~,94
	DB 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x24, 0x42, 0x81, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00;△,95

	


