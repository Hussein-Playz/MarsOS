; This is the beta version of MarsOS features are added here before they release
[bits 16]           
[org 0x7c00]        

start:              

    xor ax,ax           
    mov ds,ax           
    mov es,ax           
    mov bx,0x8000

    mov ax,0x13         
    int 0x10            

    mov ah,02           
    int 0x10            

    mov ah,0x02         
    mov bh,0x00         
    mov dh,0x06         
    mov dl,0x09         
    int 0x10

    mov si, start_os_intro              
    call _print_DiffColor_String        

    mov ah,0x02
    mov bh,0x00
    mov dh,0x10
    mov dl,0x06
    int 0x10

    mov si,press_key                    
    call _print_DiffColor_String       

    mov ax,0x00         
    int 0x16            


    mov ah, 0x02                    
    mov al, 1                       
    mov dl, 0x80                    
    mov ch, 0                       
    mov dh, 0                       
    mov cl, 2                       
    mov bx, _OS_Stage_2             
    int 0x13                        
    jmp _OS_Stage_2                 

    start_os_intro db '    Welcome to MarsOS!',0
    press_key db '   Press any key to Boot',0
    lol db '  ',0

    login_username db 'Username : ',0
    login_password db 'Password : ',0
    

    os_info db 10, 'OS: MarsOS, Bits: 16-Bit, version: =1.2.4 Bootable: = true',13,0

    press_key_2 db 10,'Press any key to go to Desktop...',0
    display_text db ' ',0
    window_text db 10,'Desktop', 0
    login_label db '#] Sign Up....(Double Click Enter Key To Skip Sign Up After Sign Up Boot Will Say Sign Up It Is Login)', 0




print_string:
    mov ah, 0x0E            

.repeat_next_char:
    lodsb                
    cmp al, 0                    
    je .done_print               
    int 0x10                     
    jmp .repeat_next_char        

.done_print:
    ret                         


_print_DiffColor_String:
        mov bl,1                
    mov ah, 0x0E

.repeat_next_char:
    lodsb
    cmp al, 0
    je .done_print
    add bl,6               
    int 0x10
    jmp .repeat_next_char

.done_print:
    ret


_print_GreenColor_String:
    mov bl,10
    mov ah, 0x0E

.repeat_next_char:
    lodsb
    cmp al, 0
    je .done_print
    int 0x10
    jmp .repeat_next_char

.done_print:
    ret

_print_WhiteColor_String:
    mov bl,15
    mov ah, 0x0E

.repeat_next_char:
    lodsb
    cmp al, 0
    je .done_print
    int 0x10
    jmp .repeat_next_char

.done_print:
    ret


_print_YellowColor_String:
    mov bl,14
    mov ah, 0x0E

.repeat_next_char:
    lodsb
    cmp al, 0
    je .done_print
    int 0x10
    jmp .repeat_next_char

.done_print:
    ret

    times ((0x200 - 2) - ($ - $$)) db 0x00     
    dw 0xAA55                                  



_OS_Stage_2 :

    mov al,2                    
    mov ah,0                    
    int 0x10                    

    mov cx,0                    
    mov ah,0x02
    mov bh,0x00
    mov dh,0x00
    mov dl,0x00
    int 0x10

    mov si,login_label            
    call print_string               

    mov ah,0x02
    mov bh,0x00
    mov dh,0x02
    mov dl,0x00
    int 0x10

    mov si,login_username         
    call print_string              

_getUsernameinput:

    mov ax,0x00             
    int 0x16                

    cmp ah,0x1C             
    je .exitinput           

    cmp ah,0x01             
    je _skipLogin           

    mov ah,0x0E             
    int 0x10

    inc cx                  
    cmp cx,5                
    jbe _getUsernameinput   
    jmp .inputdone          
.inputdone:
    mov cx,0                
    jmp _getUsernameinput   
    ret                     

.exitinput:
    hlt

    mov ah,0x02
    mov bh,0x00
    mov dh,0x03
    mov dl,0x00
    int 0x10

    mov si,login_password               
    call print_string                   

_getPasswordinput:

    mov ax,0x00
    int 0x16

    cmp ah,0x1C
    je .exitinput
    
    cmp ah,0x01
    je _skipLogin

    inc cx

    cmp cx,5
    jbe _getPasswordinput
    
    jmp .inputdone

.inputdone:
    mov cx,0
    jmp _getPasswordinput
    ret
.exitinput:
    hlt


    mov ah,0x02
    mov bh,0x00
    mov dh,0x08
    mov dl,0x12
    int 0x10

    mov si, display_text        
    call print_string

    mov ah,0x02
    mov bh,0x00
    mov dh,0x9
    mov dl,0x10
    int 0x10

    mov si, os_info     
    call print_string

    mov ah,0x02
    mov bh,0x00
    mov dh,0x11
    mov dl,0x11
    int 0x10

    mov si, press_key_2     
    call print_string

    mov ah,0x00
    int 0x16


_skipLogin:

    mov ah, 0x03                    
    mov al, 1
    mov dl, 0x80
    mov ch, 0
    mov dh, 0
    mov cl, 3                       
    mov bx, _OS_Stage_3
    int 0x13

    jmp _OS_Stage_3

_OS_Stage_3:

    mov ax,0x13              
    int 0x10


    push 0x0A000                
    pop es                      
    xor di,di                   
    xor ax,ax                   
    mov ax,0x02                 

    mov dx,0                    

    add di,320                  
    imul di,10                  

    add di,10                   

_topLine_perPixel_Loop:

    mov [es:di],ax              

    inc di                      
    inc dx                      
    cmp dx,300                  
    jbe _topLine_perPixel_Loop  

    hlt                         

    xor dx,dx
    xor di,di
    add di,320
    imul di,190         
    add di,10           

    mov ax,0x01         

_bottmLine_perPixel_Loop:

    mov [es:di],ax

    inc di
    inc dx
    cmp dx,300
    jbe _bottmLine_perPixel_Loop
    hlt

    xor dx,dx
    xor di,di
    add di,320
    imul di,10           

    add di,10            

    mov ax,0x03          

_leftLine_perPixel_Loop:

    mov [es:di],ax

    inc dx
    add di,320
    cmp dx,180
    jbe _leftLine_perPixel_Loop

    hlt 
    xor dx,dx
    xor di,di
    add di,320
    imul di,10           

    add di,310           

    mov ax,0x06          

_rightLine_perPixel_Loop:

    mov [es:di],ax

    inc dx
    add di,320
    cmp dx,180
    jbe _rightLine_perPixel_Loop

    hlt


    xor dx,dx
    xor di,di

    add di,320
    imul di,27           

    add di,11            

    mov ax,0x05         

_belowLineTopLine_perPixel_Loop:

    mov [es:di],ax

    inc di
    inc dx
    cmp dx,298
    jbe _belowLineTopLine_perPixel_Loop

    hlt 

    mov ah,0x02
    mov bh,0x00
    mov dh,0x01         
    mov dl,0x02         
    int 0x10

    mov si,window_text              
    call _print_DiffColor_String

    hlt

    mov ah,0x02
    mov bh,0x00
    mov dh,0x02           
    mov dl,0x25           
    int 0x10

    mov ah,0x0E
    mov al,0x58           
    mov bh,0x00
    mov bl,4              
    int 0x10

    hlt
    mov ah,0x02
    mov bh,0x00
    mov dh,0x02           
    mov dl,0x23           
    int 0x10

    mov ah,0x0E
    mov al,0x5F           
    mov bh,0x00
    mov bl,9              
    int 0x10

    hlt

    mov ah,0x02
    mov bh,0x00
    mov dh,0x05   
    mov dl,0x09    
    int 0x10

    mov si, lol
    call _print_DiffColor_String

    hlt

    mov ah,0x02
    mov bh,0x00
    mov dh,0x12   
    mov dl,0x03  
    int 0x03

    times (1024 - ($-$$)) db 0x00

;this is the end of the code