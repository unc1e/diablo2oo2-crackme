format PE Console
include 'win32a.inc'
entry startPoint

section '.data' data readable writeable
	name	db 32 dup(0)
	serial	db 64 dup(0)
	namemsg db 'Enter your name (32 chars max and 5 chars min): ', 0
	scform	db '%s', 0
	prform	db 'Your serial: %s', 10, 0

section '.code' code executable
startPoint:
	invoke printf, namemsg
	invoke scanf, scform, name

	lea ebx, [name]
	lea esi, [serial]

	xor ecx, ecx
	xor edx, edx
	mov al, 0x05

	.whBegin1:
	mov cl, BYTE[ebx+edx]
	xor cl, 0x29
	add cl, al
	cmp cl, 0x41
	jl .next1
	cmp cl, 0x5a
	jg .next1
	.back1:
	mov BYTE[esi+edx], cl
	mov BYTE[esi+edx+1], 0x00
	inc dl
	dec al
	cmp al, 0x00
	je .next2
	jmp .whBegin1

	.next1:
	mov cl, 0x52
	add cl, al
	jmp .back1

	.next2:
	xor edx, edx
	mov eax, 0x05
	.back2:
	mov cl, BYTE[ebx+edx]
	xor cl, 0x27
	add cl, al
	add cl, 0x01
	cmp cl, 0x41
	jl .next3
	cmp cl, 0x5a
	jg .next3
	.back3:
	mov BYTE[esi+edx+5], cl
	mov BYTE[esi+edx+5+1], 0x00
	inc dl
	dec al
	cmp al, 0x00
	je .whEnd1
	jmp .back2

	.next3:
	mov cl, 0x4d
	add cl, al
	jmp .back3

	.whEnd1:
	xor ecx, ecx
	xor edx, edx

	.whBegin2:
	mov dl, BYTE[esi+ecx]
	cmp dl, 0x00
	je .whEnd2
	add dl, 5
	cmp dl, 0x5a
	jg .next5
	.back4:
	xor dl, 0x0c
	cmp dl, 0x41
	jl .next6
	cmp dl, 0x5a
	jg .next7
	.back5:
	mov BYTE[esi+ecx], dl
	inc ecx
	jmp .whBegin2

	.next5:
	sub dl, 0x0d
	jmp .back4

	.next6:
	mov dl, 0x4b
	add dl, cl
	jmp .back5

	.next7:
	mov dl, 0x4b
	sub dl, cl
	jmp .back5

	.whEnd2:
	invoke printf, prform, serial
	jmp startPoint

section '.idata'import data readable
library msvcrt, 'msvcrt.dll'

import msvcrt,\
       printf, 'printf',\
       scanf, 'scanf'

