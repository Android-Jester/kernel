global _start
	
section .text
_start:
	mov rax, 0
	mov rdi, 1
	mov rsi, msg
	mov rdx, msglen
	syscall

	mov rax, 60
	mov rdi, 0
	syscall

section .rodata
msg: db "Hello World\0"
msglen: equ $ - msg


