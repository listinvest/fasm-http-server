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
    lea rsi,[x]
    call puts2
}

format ELF64 executable 3
entry main

segment readable executable

main:
    mov rax,rsp
    mov rsi,[rax+16]
    call puts2
    call create_ssocket
    cmp rax,0
    jl exit
    puts str_ssck
    call bind_ssocket
    cmp rax,0
    jl exit
    mov [ssck],rax
    puts str_bind
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
    mov al,[rsi+rdx]
    inc rdx
    cmp al,0
    jne @b
    dec rdx
    pop rax
    pop rsi
    ret

segment readable writeable

ssaddr dw 2
ssport dw ?
db 0,0,0,0
rb 8

ssck dq ?

segment readable

str_starting db 'starting server',$0d,0
str_ssck db 'server socket created',$0d,0
