[org 0x0100] 
 jmp start 
message: db 'hello world' ; string to be printed 
length: dw 11 ; length of the string 
; subroutine to clear the screen 
sleep:
push ax
push cx
mov cx,0x000F
sleepl1:
mov ax,0xFFFF
sleepl2:
dec ax
cmp ax, 0
ja sleepl2
dec cx
cmp cx, 0
ja sleepl1
pop cx
pop ax
ret
clrscr: push es 
 push ax 
 push di
mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov di, 0 ; point di to top left column 
nextloc: mov word [es:di], 0x0720 ; clear next char on screen 
 add di, 2 ; move to next screen location 
 cmp di, 4000 ; has the whole screen cleared 
 jne nextloc ; if no clear next position 
 pop di 
 pop ax 
 pop es 
 ret 
printstr: push bp 
 mov bp, sp 
 push es 
 push ax 
 push cx 
 push si 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov al, 80 ; load al with columns per row 
 mul byte [bp+10] ; multiply with y position 
 add ax, [bp+12] ; add x position 
 shl ax, 1 ; turn into byte offset 
 mov di, ax ; point di to required location 
 mov si, [bp+6] ; point si to string 
 mov cx, [bp+4] ; load length of string in cx 
 mov ah, [bp+8] ; load attribute in ah 
nextchar: mov al, [si] ; load next char of string 
 mov [es:di], ax ; show this char on screen 
 add di, 2
add si, 1 ; move to next char in string 
 loop nextchar ; repeat the operation cx times 
 pop di 
 pop si 
 pop cx 
 pop ax 
 pop es 
 pop bp 
 ret 10 
start: call clrscr ; call the clrscr subroutine 
 mov ax, 30 
 push ax ; push x position 
 mov ax, 20 
 push ax ; push y position 
 mov ax, 1 ; blue on black attribute 
 push ax ; push attribute 
 mov ax, message 
 push ax ; push address of message 
 push word [length] ; push message length 
 call printstr ; call the printstr subroutine 
call sleep
 mov ax, 30 
 push ax ; push x position 
 mov ax, 21
 push ax ; push y position 
 mov ax, 7 ; blue on black attribute 
 push ax ; push attribute 
 mov ax, message 
 push ax ; push address of message 
 push word [length] ; push message length 
 call printstr ; call the printstr subroutine 
 mov ax, 0x4c00 ; terminate program 
 int 0x21 