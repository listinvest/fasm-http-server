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
    xchg al,ah
    mov [ssport],ax
    call create_ssocket
    puts str_ssck
    call puti64
    putln
    cmp rax,0
    jl exit
    mov [ssck],rax
    call bind_ssocket
    puts str_bind
    call puti64
    putln
    cmp rax,0
    jne exit
    call listen_ssocket
    puts str_listen
    call puti64
    putln
    cmp rax,0
    jne exit
reaccept:
    call accept_ssocket
    mov [sck],rax
    puts str_accept
    call puti64
    putln
    puts str_connected
    mov eax,dword[sck]
    call puti32
    mov al,' '
    putc
    mov eax,dword[saddr]
    call puti32
    mov al,' '
    putc
    mov ax,[sport]
    call puti16
    putln
    jmp reaccept
accept_ssocket:
    push rdi
    push rsi
    push rdx
    push rcx
    mov rax,43
    mov rdi,[ssck]
    lea rsi,[saddrt]
    mov rdx,saddrt.length
    syscall
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    ret
listen_ssocket:
    push rsi
    push rcx
    push rdi
    mov rax,50
    mov rdi,[ssck]
    mov rsi,128
    syscall
    pop rdi
    pop rcx
    pop rsi
    ret
bind_ssocket:
    push rsi
    push rcx
    push rdx
    push rdi
    mov rax,49
    mov rdi,[ssck]
    lea rsi,[ssaddr]
    mov rdx,ssaddr.length
    syscall
    pop rdi
    pop rdx
    pop rcx
    pop rsi
    ret
create_ssocket:
    push rdi
    push rsi
    push rdx
    push rcx
    mov rax,41
    mov rdi,2
    mov rsi,1
    mov rdx,0
    syscall
    pop rcx
    pop rdx
    pop rsi
    pop rdi
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
    mov [putcx],al
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
puti16:
        push rcx
        mov rcx,4
        call putix
        pop rcx
        ret
puti32:
        push rcx
        mov rcx,8
        call putix
        pop rcx
        ret
puti64:
        push rcx
        mov rcx,16
        call putix
        pop rcx
        ret
putix:
        push rax
        push rbx
        mov rbx,rax
        mov rax,0
.next:
        mov al,bl
        and al,0Fh
        cmp al,9
        jg .chrz
        add al,'0'
        jmp .prnt
.chrz:
        add al,'A'
.prnt:
        call putc2
        shl rbx,4
        dec rcx
        cmp rcx,0
        jg .next
        pop rbx
        pop rax
        ret

segment readable writeable

rb 64

putcx db ?

ssaddr dw 2
ssport dw ?
db 0,0,0,0
rb 8
ssaddr.length = $-ssaddr

saddrt dw 2
sport dw ?
saddr db ?,?,?,?
rb 8
saddrt.length = $-saddrt

ssck dq ?
sck dq ?

rb 64

segment readable

str_main db 'main port=',0
str_ssck db 'socket=',0
str_bind db 'bind=',0
str_listen db 'listen=',0
str_accept db 'accept=',0
str_connected db 'connected ',0
