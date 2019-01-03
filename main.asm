;fasm-server
;heroku fasm server
;Copyright © 2017 Nadeen Udantha
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

format ELF executable 3
entry main
 
segment readable writable executable

main:
        pop     eax
        pop     ebx
        pop     ecx
        mov     edx,ecx
        push    ecx
        push    ebx
        push    eax
        mov     eax,dword[edx]
        mov     bx,word[edx+4]
        mov     dword[srv_portz],eax
        mov     word[srv_portz+4],bx
        mov     esi,srv_portz
        call    strz.puts
        mov     esi,str_endl
        call    strz.puts
        mov     esi,srv_portz
        call    atoi
        mov     dword[srv_port],eax
        call    so.socket
        mov     dword[sso],eax
        mov     esi,str_001
        call    strz.puts
        mov     ebx,dword[srv_port]
        call    so.bind
        mov     esi,str_002
        call    strz.puts
        call    so.listen
        mov     esi,str_003
        call    strz.puts
.xc:
        call    so.accept
        mov     esi,str_004
        call    strz.puts
        ;call    client
        ;jmp     .xc
 exit:
        mov     eax,1
        xor     ebx,ebx
        int     0x80
.e:
        jmp     .e

so:
.sd1: dd 2,1,0
.sd2:
dd 0
dd ..soaddrz
dd 16
..soaddrz:
..sin_family dw 2
..sin_port   dd 5000
..sin_addr   rd 1
..__pad      rb 8
.sd3 dd 1024
.sd4 dd 0,0,0
.sm:
        mov     eax,102
        int     0x80
        ret
..z:
        ret
.socket:
        mov     ebx,0
        mov     ecx,.sd1
        call    .sm
        ret
.bind:
        ;shr     ebx,8
        mov     dword[..sin_port],ebx
        mov     ebx,1
        mov     ecx,.sd2
        mov     eax,102
        int     0x80
        mov     ebx,eax
        mov     eax,1
        int     0x80
.listen:
        mov     ebx,3
        mov     ecx,.sd3
        call    .sm
        cmp     eax,0
        je      ..z
        mov     ebx,eax
        add     ebx,200000
        mov     eax,1
        int     0x80
.accept:
        mov     ebx,4
        mov     ecx,.sd4
        call    .sm
        cmp     eax,0
        je      ..az
        mov     ebx,eax
        add     ebx,300000
        mov     eax,1
        int     0x80
..az:
        mov     eax,dword[.sd4]
        ret
strz:
.len:
        push    esi
        push    ecx
        mov     ecx,0
..lenz:
        mov     al,byte[esi]
        cmp     al,0
        je      ..lenzx
        inc     esi
        inc     ecx
        jmp     ..lenz
..lenzx:
        mov     eax,ecx
        pop     ecx
        pop     esi
        ret
.puts:
        push    eax
        call    strz.len
        mov     ecx,esi
        mov     edx,eax
        mov     eax,4
        mov     ebx,1
        int     0x80
        pop     eax
        ret

atoi:
        push    ecx
        push    edx
        mov     edx,esi
        xor     eax,eax
.zzz:
        xor     ecx,ecx
        mov     cl,byte[edx]
        inc     edx
        cmp     cl,'0'
        jb      .yyy
        cmp     cl,'9'
        ja      .yyy
        sub     cl,'0'
        imul    eax,10
        add     eax,ecx
        jmp     .zzz
.yyy:
        pop     edx
        pop     ecx
        ret

srv_portz rb 6
srv_port dd 0
sso dd ?
str_endl db 0x0a,0
str_001 db 'str_001',0xA,0
str_002 db 'str_002',0xA,0
str_003 db 'str_003',0xA,0
str_004 db 'str_004',0xA,0
