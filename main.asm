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

format ELF64 executable 3
entry main

segment readable executable

main:
    lea  rsi,[msg]
    call puts
exit:
	mov	 rax,60
	xor  rdi,rdi
	syscall
	jmp  $
puts:
    mov  rax,1
    mov  rdx,6
    mov  rdi,1
    syscall
    ret

segment readable

msg db 'Hello!',0


