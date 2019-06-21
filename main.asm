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
    puts str_starting
    call create_ssocket
    cmp rax,0
    je exit
    puts str_ssck
    jmp exit
create_ssocket:
    mov rax,41
    mov rdi,2
    mov rsi,1
    mov rdi,0
    syscall
    ret
exit:
	mov rax,60
	xor rdi,rdi
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

ssck dd ?

segment readable

str_starting db 'starting server',0
str_ssck db 'server socket created',0
