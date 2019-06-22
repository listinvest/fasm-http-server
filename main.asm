;fasm-http-server
;️❤️💚💛fasm http server💜💙🧡
;Copyright © 2019 Nadeen Udantha
;<udanthan@gmail.com>
;This program is free software: you can redistribute it and/or modify 
;it under the terms of the GNU General Public License as published by
;the Free Software Foundation, either version 3 of the License, or
;(at your option) any later version.
;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.
;You should have received a copy of the GNU General Public License
;along with this program.  If not, see <http://www.gnu.org/licenses/>.

macro puts x
{
	push rsi
    lea rsi,[x]
    call puts2
    pop rsi
}
macro putc
{
    call putc2
}
macro putln
{
	push rax
	mov al,0ah
    call putc2
    pop rax
}

format ELF64 executable 3
entry main

segment readable executable

main:
    puts str_main
    mov rsi,[rsp+16]
    call puts2
    putln
    call atoi
    mov [ssport],ax
    call create_ssocket
    puts str_ssck
    call puti64
    cmp rax,0
    jl exit
    call bind_ssocket
    puts str_bind
    call puti64
    cmp rax,0
    jl exit
    mov [ssck],rax
    mov rax,[ssck]
    jmp exit
bind_ssocket:
    mov rsi,rax
    mov rax,49
    lea rdi,[ssaddr]
    mov rdx,8
    syscall
    ret
create_ssocket:
    mov rax,41
    mov rdi,2
    mov rsi,1
    mov rdx,0
    syscall
    ret
exit:
	mov rax,60
	mov rdi,0
	syscall
	jmp $
puts2:
    push rax
    push rdx
    push rdi
    push rcx
    mov rax,1
    call strlen
    mov rdi,1
    syscall
    pop rcx
    pop rdi
    pop rdx
    pop rax
    ret
strlen:
    push rsi
    push rax
    mov rdx,0
@@:
    mov al,byte[rsi+rdx]
    inc rdx
    cmp al,0
    jne @b
    dec rdx
    pop rax
    pop rsi
    ret
putc2:
    mov [putscx],al
    push rax
    push rdx
    push rdi
    push rsi
    push rcx
    lea rsi,[putcx]
    mov rax,1
    mov rdx,1
    mov rdi,1
    syscall
    pop rcx
    pop rsi
    pop rdi
    pop rdx
    pop rax
    ret
atoi:
        push    rcx
        push    rdx
        mov     rdx,rsi
        xor     rax,rax
@@:
        xor     rcx,rcx
        mov     cl,byte[rdx]
        inc     rdx
        cmp     cl,'0'
        jb      @f
        cmp     cl,'9'
        ja      @f
        sub     cl,'0'
        imul    rax,10
        add     rax,rcx
        jmp     @b
@@:
        pop     rdx
        pop     rcx
        ret
puti64:
        push rax
        push rbx
        push rsi
        lea rsi,[hexchars]
        mov rbx,rax
        mov rax,0
        mov al,bl
        mov al,byte[rsi+rax]
        call putc2
        pop rsi
        pop rbx
        pop rax
        ret

segment readable writeable

putcx db ?
ssaddr dw 2
ssport dw ?
db 0,0,0,0
rb 8

ssck dq ?

segment readable

str_main db 'main port=',0
str_ssck db 'server socket',0
str_bind db 'server bind',0

hexchars db '0123456789ABCDEF'

