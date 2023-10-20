;::::: BRICK BREAKER GAME ::::::::
;Created by Farzeen Qaiser and Mubeen Qaiser

brick struct
	brick_x dw 0
	brick_y dw 0
	brick_height dw 0
	brick_width dw 0
	brick_color dw 0
	hits dw 0
brick ends
 
.model small
.stack 100h
.data
;-----------	<x, y, height, width, color, hits> 	;colors:  yellow = 14, red = 12,
  blank_brick brick <20,90,10,30,11,1>    ; error handling (for special ball)

	brick_11 brick <20, 90, 10, 30, 11, 1>
	brick_12 brick <55, 90, 10, 30, 9, 1>
	brick_13 brick <90, 90, 10, 30, 11, 1>
	brick_14 brick <125, 90, 10, 30, 9, 1>
	brick_15 brick <160, 90, 10, 30, 11, 1>
	brick_16 brick <195, 90, 10, 30, 9, 1>
	brick_17 brick <230, 90, 10, 30, 11, 1>
	brick_18 brick <265, 90, 10, 30, 9, 1>

	brick_21 brick <40, 75, 10, 30, 12, 1>
	brick_22 brick <75, 75, 10, 30, 14, 1>
	brick_23 brick <110, 75, 10, 30, 12, 1>
	brick_24 brick <145, 75, 10, 30, 14, 1>
	brick_25 brick <180, 75, 10, 30, 12, 1>
	brick_26 brick <215, 75, 10, 30, 14, 1>
	brick_27 brick <250, 75, 10, 30, 12, 1>

	brick_31 brick <20, 60, 10, 30, 11, 1>
	brick_32 brick <55, 60, 10, 30, 9, 1>
	brick_33 brick <90, 60, 10, 30, 11, 1>
	brick_34 brick <125,60, 10, 30, 9, 1>
	brick_35 brick <160,60, 10, 30, 11, 1>
	brick_36 brick <195,60, 10, 30, 9, 1>
	brick_37 brick <230,60, 10, 30, 11, 1>
	brick_38 brick <265,60, 10, 30, 9, 1>

	brick_41 brick <40, 45, 10, 30, 12, 1>
	brick_42 brick <75, 45, 10, 30, 14, 1>
	brick_43 brick <110, 45, 10, 30, 12, 1>
	brick_44 brick <145, 45, 10, 30, 14, 1>
	brick_45 brick <180, 45, 10, 30, 12, 1>
	brick_46 brick <215, 45, 10, 30, 14, 1>
	brick_47 brick <250, 45, 10, 30, 12, 1>

	brick_51 brick <20, 30, 10, 30, 11, 1>
	brick_52 brick <55, 30, 10, 30, 9, 1>
	brick_53 brick <90, 30, 10, 30, 11, 1>
	brick_54 brick <125, 30, 10, 30, 9, 1>
	brick_55 brick <160, 30, 10, 30, 11, 1>
	brick_56 brick <195, 30, 10, 30, 9, 1>
	brick_57 brick <230, 30, 10, 30, 11, 1>
	brick_58 brick <265, 30, 10, 30, 9, 1>

  blank_brick2 brick <20,90,10,30,11,1>    ; error handling (for special ball)
;---

time_aux db 0

; ball settings
ball_x dw 90
ball_y dw 100
ball_size dw 5 			  ; width x height
ball_velocity_x dw 5	; default settings = 5
ball_velocity_y dw 1	; default settings = 1
ball_velocity_x_left dw -5
ball_velocity_x_right dw 5
draw_ball_x dw 0		  ;	for drawing round ball
draw_ball_y dw 0		  ;	for drawing round ball
ball_color db 12

b_up dw 0
b_down dw 0
b_left dw 0
b_right dw 0

old_ball_x dw 0			; for clearing old ball
old_ball_y dw 0			; for clearing old ball

window_width dw 310
window_height dw 200
window_bounds dw 10

; paddle initial position
paddle_x dw 140
paddle_y dw 180

; paddle charcteristics
paddle_height dw 5
paddle_width dw 60
paddle_color dw 6
paddle_velocity dw 10

; to clear the old paddle position
old_paddle_x dw 140
old_paddle_y dw 180

; used for hiting the ball in 3 different directions (left, right, up)
upper_limit dw 0
middle_limit2 dw 0
middle_limit1 dw 0
lower_limit dw 0
paddle_portion_length dw 20

names db 20 dup("$")

heart_lives dw 3

counter dw 0		    ; for while loops
counter2 db 0		    ; for while loops
output_counter db 0	; for myoutput proc

str1 db "Score:$"
score dw 0
dev_mode dw 0
temp_color dw 0
temp_counter dw 0
level2_switch dw 0
level3_switch dw 0
gameover_switch dw 0



str2 db "GAME OVER!$"
str3 db "NEW GAME$"
str4 db "RESUME$"
str5 db "INSTRUCTIONS$"
str6 db "HIGH SCORE$"
str7 db "EXIT$"
str8 db "BRICK BREAKER GAME$"
str9 db "ENTER YOUR NAME$"
str10 db "INSTRUCTIONS$"
str11 db "LEFT KEY:      MOVE PADDLE LEFT$"
str12 db "RIGHT KEY:     MOVE PADDLE RIGHT$"
str13 db "PRESS ESCAPE TO GO BACK$"
str14 db "LEVEL 1$"           ; for level selection menu
str15 db "LEVEL 2$"           ; for level selection menu
str16 db "LEVEL 3$"           ; for level selection menu
str17 db "NAME$"
str18 db "SCORES$"
str19 db "LEVEL$"

display_level db "LEVEL 0$"   ; for scorebar

; special object variables
object_x dw 0 
object_y dw 0 
object_color db 13
old_object_y dw 0
object_size dw 5
special_object_switch dw 0
special_brick_count dw 0

; file handling variables
fname db "scores.txt", 0
fhandle dw ?
string_scores db 4 dup('$')
string_level db 2 dup ('$')
string_highscores db 100 dup('$')

.code

;--- draw pixel ---
draw_pixel macro row, col, color
MOV CX, col    ;column
MOV DX, row    ;row
MOV AL, color  ;color
MOV AH, 0CH 
INT 10H
endm
;------------------

;--- cursor reset ---
set_cursor macro row, columun
	mov bh, 0	
	mov ah, 2
	mov dh, row     ;row
	mov dl, columun    ;column
	int 10h
endm
;------------------

;--- print string ---
mymessage macro str0
	mov dx, offset str0
	mov ah, 9
	int 21h
endm 
;------------------

;--- print string ---
mymessage2 macro
	mov dx, si
	mov ah, 9
	int 21h
endm 
;------------------

;--- Draw box ---
draw_box macro top, bottom, left, right, color
	mov ah, 6
	mov al, 0
	mov bh, color     	; color
	mov ch, top     	; top row of window
	mov cl, left		; left most column of window
	mov dh, bottom     	; Bottom row of window
	mov dl, right     	; Right most column of window
	int 10h
endm

main proc
mov ax, @data
mov ds, ax
mov ax, 0

call username_input

;--- main menu ---
main_menu:
	;--- video mode (graphic) 
	mov ah, 0
	mov al, 13h    ;320x200
	int 10h	

	;--- set background black
	mov ax, 0
	mov ah, 0Bh
	mov bh, 00
	mov bl, 00
	int 10h	

	set_cursor 2, 10	; prints brick breaker game
	mymessage str8

	;--- Initial setup ---
	draw_box 5, 7, 10, 27, 11		; new game box
	draw_box 9, 11, 10, 27, 11		; resume box
	draw_box 13, 15, 10, 27, 11		; instructions box
	draw_box 17, 19, 10, 27, 11		; high scores box
	draw_box 21, 23, 10, 27, 11		; exit box

	set_cursor 6, 15		; new game
	mymessage str3

	set_cursor 10, 15		; resume
	mymessage str4

	set_cursor 14, 15		; instructions
	mymessage str5

	set_cursor 18, 15		; high scores
	mymessage str6

	set_cursor 22, 15		; exit
	mymessage str7
	;---------------------------------------

	;--- Interactive Setup ---
	newgame:
		draw_box 21, 23, 10, 27, 11		; exit box			  ; blue
		set_cursor 22, 15				      ; exit
		mymessage str7

		draw_box 5, 7, 10, 27, 10		    ; new game box		; green
		set_cursor 6, 15				        ; new game
		mymessage str3
		
		draw_box 9, 11, 10, 27, 11		  ; resume box		  ; blue
		set_cursor 10, 15				        ; resume
		mymessage str4
	
	call beep
	mov ah,0	; key input
	int 16h

	cmp ah, 48h
	je exit					  ;<---- select exit tab when up key is pressed
	cmp ah,	50h
	je resume				  ;<---- select resume tab when down key is pressed
	cmp al,	13
	je start_game			;<---- start game when Enter key is pressed

	resume:
		draw_box 5, 7, 10, 27, 11		    ; new game box		; blue
		set_cursor 6, 15				        ; new game
		mymessage str3

		draw_box 9, 11, 10, 27, 10		  ; resume box		  ; green
		set_cursor 10, 15               ; resume
		mymessage str4
		
		draw_box 13, 15, 10, 27, 11		  ; instructions box	; blue
		set_cursor 14, 15				        ; instructions
		mymessage str5	

	call beep
	mov ah,0	; key input
	int 16h

	cmp ah, 48h
	je newgame				  ;<---- select newgame tab when up key is pressed
	cmp ah,	50h
	je instructions			;<---- select instructions tab when down key is pressed
	cmp al, 13
	je resume_game			;<---- resume/unpause game when Enter key is pressed

	instructions:
		draw_box 9, 11, 10, 27, 11		  ; resume box		      ; blue
		set_cursor 10, 15				        ; resume
		mymessage str4

		draw_box 13, 15, 10, 27, 10		  ; instructions box	  ; green
		set_cursor 14, 15				        ; instructions
		mymessage str5	

		draw_box 17, 19, 10, 27, 11		  ; high scores box	    ; blue
		set_cursor 18, 15				        ; high scores
		mymessage str6

	call beep
	mov ah,0	; key input
	int 16h

	cmp ah, 48h
	je resume				    ;<---- select resume tab when up key is pressed
	cmp ah,	50h
	je highscores			  ;<---- select highscores tab when down key is pressed
	cmp al, 13
	je instructions_page

	highscores:
		draw_box 13, 15, 10, 27, 11		  ; instructions box	; blue
		set_cursor 14, 15				        ; instructions
		mymessage str5

		draw_box 17, 19, 10, 27, 10		  ; high scores box	  ; green
		set_cursor 18, 15				        ; high scores
		mymessage str6

		draw_box 21, 23, 10, 27, 11		  ; exit box			    ; blue
		set_cursor 22, 15				        ; exit
		mymessage str7

	call beep
	mov ah,0	; key input
	int 16h

	cmp ah, 48h
	je instructions			;<---- select instructions tab when up key is pressed
	cmp ah,	50h
	je exit					    ;<---- select exit tab when down key is pressed
  cmp al, 13
  je highscores_page

	exit:
		draw_box 17, 19, 10, 27, 11		  ; high scores box	  ; blue
		set_cursor 18, 15				        ; high scores
		mymessage str6

		draw_box 21, 23, 10, 27, 10		  ; exit box			    ; green
		set_cursor 22, 15				        ; exit
		mymessage str7

		draw_box 5, 7, 10, 27, 11		    ; new game box		  ; blue
		set_cursor 6, 15				        ; new game
		mymessage str3

	call beep
	mov ah,0	; key input
	int 16h

	cmp ah, 48h
	je highscores			;<---- select highscores tab when up key is pressed
	cmp ah,	50h
	je newgame				;<---- select newgame tab when down key is pressed
	cmp al, 13
	je exit_game			;<---- exit game when Enter key is pressed
	
	jmp newgame				;<------------ error handling (whenever a different key is pressed, other than arrow up and arrow down)
;--- main menu end ---

instructions_page:

	;--- video mode (graphic) 
	mov ah, 0
	mov al, 13h    ;320x200
	int 10h	

	;--- set background black
	mov ax, 0
	mov ah, 0Bh
	mov bh, 00
	mov bl, 00
	int 10h	

	set_cursor 2, 10	; prints brick breaker game
	mymessage str8

	set_cursor 6, 13  
	mymessage str10 

	set_cursor 8, 4
	mymessage str11 

	set_cursor 10, 4
	mymessage str12

	set_cursor 22, 8
	mymessage str13

	mov ah, 00h				; checks which key is pressed
	int 16h

	cmp ah, 01h				; go to main menu when escape is pressed
	je main_menu

jmp instructions_page

highscores_page:

	;--- video mode (graphic) 
	mov ah, 0
	mov al, 13h    ;320x200
	int 10h	

	;--- set background black
	mov ax, 0
	mov ah, 0Bh
	mov bh, 00
	mov bl, 00
	int 10h	


	set_cursor 2, 10	; prints brick breaker game
	mymessage str8

	set_cursor 6, 4   ; prints "NAME"
	mymessage str17

	set_cursor 6, 16   ; prints "SCORES"
	mymessage str18

  set_cursor 6, 28   ; prints "LEVEL"
	mymessage str19

  call read_file
  mov si, offset string_highscores
  mov counter2, 8
  .while (counter2 < 12)
    set_cursor counter2, 4   ; prints Player names
    mymessage2

    call index_moving
    set_cursor counter2, 16   ; prints Player scores
    mymessage2

    call index_moving
    set_cursor counter2, 28   ; prints Player level#
    mymessage2

    call index_moving
    inc counter2
  .endw
  set_cursor 22, 8  ; prints "press escape to go back"
	mymessage str13
  
	mov ah, 00h				; checks which key is pressed
	int 16h

	cmp ah, 01h				; go to main menu when escape is pressed
	je main_menu


jmp highscores_page
start_game:

	;--- video mode (graphic) 
	mov ah, 0
	mov al, 13h    ;320x200
	int 10h	

	;--- set background black
	mov ax, 0
	mov ah, 0Bh
	mov bh, 00
	mov bl, 00
	int 10h	

	set_cursor 2, 10	; prints brick breaker game
	mymessage str8

	level1_label:
		draw_box 13, 15, 10, 27, 11		; level3 box			; blue
		set_cursor 14, 15				
		mymessage str16

		draw_box 5, 7, 10, 27, 10		  ; level1 box		  ; green
		set_cursor 6, 15				
		mymessage str14
		
		draw_box 9, 11, 10, 27, 11		; level2 box		  ; blue
		set_cursor 10, 15				
		mymessage str15

	call beep
	mov ah,0	; key input
	int 16h

	cmp ah, 48h
	je level3_label					;<---- select level3 tab when up key is pressed
	cmp ah,	50h
	je level2_label					;<---- select level2 tab when down key is pressed
	cmp al,	13
	je jump_level1					;<---- Enter level1 game

	level2_label:
		draw_box 5, 7, 10, 27, 11		  ; level1 box		; blue
		set_cursor 6, 15				
		mymessage str14

		draw_box 9, 11, 10, 27, 10		; level2 box		; green
		set_cursor 10, 15				
		mymessage str15
		
		draw_box 13, 15, 10, 27, 11		; level3 box	  ; blue
		set_cursor 14, 15				
		mymessage str16	

	call beep
	mov ah,0	; key input
	int 16h

	cmp ah, 48h
	je level1_label				;<---- select level1 tab when up key is pressed
	cmp ah,	50h
	je level3_label				;<---- select level3 tab when down key is pressed
	cmp al, 13
	je jump_level2				;<---- Enter level2 game

	level3_label:
		draw_box 9, 11, 10, 27, 11		; level2		    ; blue
		set_cursor 10, 15				
		mymessage str15

		draw_box 13, 15, 10, 27, 10		; level3 box	  ; green
		set_cursor 14, 15				
		mymessage str16	

		draw_box 5, 7, 10, 27, 11		  ; level1 box	   ; blue
		set_cursor 6, 15				
		mymessage str14

	call beep
	mov ah,0	; key input
	int 16h

	cmp ah, 48h
	je level2_label				;<---- select level2 tab when up key is pressed
	cmp ah,	50h
	je level1_label				;<---- select level1 tab when down key is pressed
	cmp al, 13
	je jump_level3				;<---- Enter level3 game

jmp start_game

;--- used for the "New Game" tab feature
;--- reset the game level 1 ---			; ERROR: once the brick is broken, I can't visaully redraw it.
jump_level1:
	call level_1
jmp skip_level
jump_level2:
	call level_2
jmp skip_level
jump_level3:
	call level_3
skip_level:
;----------------------

resume_game:		; label used to resume/unpause the game
	;video mode (graphic) 
	mov ah, 0
	mov al, 13h    ;320x200
	int 10h	

	call map		;<-------- call map here

;--- MAIN GAME LOOP ---
game_loop:
	mov ah, 2ch
	int 21h			; ch = hour, cl = minute, dh = second, dl = 1/100 seconds

	cmp dl, time_aux 
	je game_loop

	mov time_aux, dl	; update time

  ;--- paddle functionality ---
	call move_paddle
	call draw_paddle
  ;----------------------------

	;--- Dev Mode ---
	.if (dev_mode == 1)
		call control_ball
	.endif

  ;--- ball functionality ---
	call move_ball
	call clear_ball
	call draw_ball
  ;--------------------------

  ;--- special object ---
  .if (special_object_switch == 1)
    call draw_special_object
    call special_object
    call clear_special_object
  .endif
  ;-----------------------

	call score_bar        ; draws score bar 

	.if (score == 6)
		mov paddle_width, 60			    
        mov paddle_portion_length, 20	
        mov paddle_velocity, 10
        mov paddle_color, 6
	.endif
  ;--- move to level 2 when score == 38 ---
	.if (score >= 38) && (level2_switch == 0)		  ; 38 blocks, 1 score each	(38)
		call level_2
		inc score
		mov level2_switch, 1
		mov ball_color, 12
	.endif

  ;--- move to level 3 when score == 115 ---
	.if (score >= 115)	&& (level3_switch == 0)	; 38 blocks, 2 score ech  (115)
		call level_3
		inc score
		mov level3_switch, 1
	.endif

  ;--- move to Game Over screen when score == 192 ---
	.if (score >= 180)	; game end... you win	(192)
		jmp exit_game
	.endif

  ;--- move to Game Over screen when heart_lives == 0 ---
	.if (heart_lives < 1)	; 0 hearts, game over
		jmp exit_game 
	.endif

	;--- key inputs ---
	mov ah, 01h
	int 16h 
	jz skip_controls			; checks if key is pressed

		mov ah, 00h				  ; checks which key is pressed
		int 16h

		cmp al, 8				   ; exit when back space is pressed
		je exit_game

		cmp ah, 01h				  ; pause game when escape key is pressed/ go to menu
		je main_menu

		.if(al == "z")			  ; special ball activated
			mov ball_color, 13
		.elseif (al == "x")		; special ball deactivated
			mov ball_color, 12
		.elseif (al == "o")		; control ball activated
			mov dev_mode, 1	
		.elseif (al == "p")		; control ball deactivated
			mov dev_mode, 0			
		.endif

	skip_controls:
	;--------------------------------------

jmp game_loop

	exit_game:
	call exit_menu
  	call write_file

mov ah, 4ch
int 21h
main endp

;--- put colors in loop for resume to work --- (Important!!!!!)
level_1 proc
	mov si, offset brick_11
  ;--- 1 hit bricks ---
	.while (counter < 38)
		mov ax, 1	
		mov [si+10], ax     ; brick hits = 1

		inc counter
		add si, 12          ; move to next brick
	.endw
  ;--------------------
	mov counter, 0
	mov score, 0
	mov ball_x, 10
	mov ball_y, 105			; last digit should be 5
	mov ball_velocity_x, 5
	mov ball_velocity_y, 1
	mov heart_lives, 3

  mov paddle_x, 140				      
	mov paddle_width, 60			    
	mov paddle_portion_length, 20	
	mov paddle_velocity, 10

  mov si, offset brick_14
  mov ax, 13
  mov [si+8], ax
  mov si, offset brick_15
  mov ax, 13
  mov [si+8], ax
  mov si, offset brick_16
  mov ax, 13
  mov [si+8], ax

  mov string_level, "1"
  mov display_level[6], "1"
ret
level_1 endp

level_2 proc
	mov si, offset brick_11			;<---- set blocks to double hit

  ;--- 2 hit bricks
	mov counter, 0
	.while (counter < 38)			  ;<---- not sure should be equal to 38//////////////
		mov ax, 2	
		mov [si+10], ax       ; brick hits = 2

		mov ax, 14            ; 14 = yellow color
		mov [si+8], ax        ; brick color = yellow

		inc counter
		add si, 12            ; move to next brick
	.endw
	mov counter, 0
	mov ball_x, 20
	mov ball_y, 105					      ; last digit should be 5
	mov ball_velocity_x, 5			  ;<---- increase ball speed
	mov ball_velocity_y, 5
	inc heart_lives					      ;<---- increase health when move to next level
	mov paddle_x, 60				      ;<---- setting initial coordinates of the paddle
	mov paddle_width, 30			    ;<---- reduce size of paddle in level 2
	mov paddle_portion_length, 10	;<---- reduce size of paddle in level 2
	mov paddle_velocity, 20
    mov paddle_color, 6


	;---- to erase the old paddle and ball, redraw black screen ---
	;--- video mode (graphic) 
	mov ah, 0
	mov al, 13h    ;320x200
	int 10h	

	;--- set background black
	mov ax, 0
	mov ah, 0Bh
	mov bh, 00
	mov bl, 00
	int 10h	

	call map				;<----- redraws map after clearing level 1

  mov string_level, "2"
  mov display_level[6], "2"

ret
level_2 endp

level_3 proc
  call level_2					      ;<---- error handling: called level 2 for direct selection of level 3 (new game tab ---> level 3 tab)
	mov si, offset brick_11			;<---- set blocks to triple hit

  ;--- 3 hit blocks ---
	mov counter, 0
	.while (counter < 8)			  ;<---- lower 8 bricks are 3 hit bricks
		; reset brick hits
		mov ax, 3	
		mov [si+10], ax       ; brick hits = 3

		mov ax, 11            ; 11 = cyan
		mov [si+8], ax        ; brick color = cyan

		inc counter
		add si, 12            ; move to next brick
	.endw
	mov counter, 0
  ;--------------------

	;--- unbreakable blocks ---
	mov si, offset brick_21
	.while (counter < 4)			  ;<---- not sure should be equal to 38//////////////
		; reset brick hits
		mov ax, 100	
		mov [si+10], ax

		; set color	grey
		mov ax, 7
		mov [si+8], ax

		inc counter
		add si, 24
	.endw
  ;-------------------------

	mov counter, 0
	mov ball_x, 10
	mov ball_y, 105					      ; last digit should be 5
	mov ball_velocity_y, 5
	mov ball_velocity_x, 10			  ;<---- increase ball speed
	mov ball_velocity_x_left, -10
	mov ball_velocity_x_right, 10

	inc heart_lives					      ;<---- increase health when move to next level
	mov paddle_x, 100				      ;<---- setting initial coordinates of the paddle
	mov paddle_width, 60			    ;<---- reset size of paddle in level 3
	mov paddle_portion_length, 20	;<---- reset size of paddle in level 3
	mov paddle_velocity, 20
    mov paddle_color, 6

	;---- to erase the old paddle and ball, redraw black screen ---
	;--- video mode (graphic) 
	mov ah, 0
	mov al, 13h    ;320x200
	int 10h	

	;--- set background black
	mov ax, 0
	mov ah, 0Bh
	mov bh, 00
	mov bl, 00
	int 10h	

  ;--- special brick ---
	mov si, offset brick_11
	mov ax, 15
	mov [si+8], ax

	call map				;<----- redraws map after clearing level 2

  mov string_level, "3"
  mov display_level[6], "3"
ret
level_3 endp

map proc
	mov si, offset brick_11
	.while (counter < 38)	; 38 blocks
	call draw_block       ; draws the bricks with the right characteristics
	inc counter
	add si, 12
	.endw
	mov counter, 0
	;--- drawing end ---

ret
map endp

score_bar proc

	;--- scorebar ---
	draw_box 0, 2, 0, 50, 5
	;----------------

	;--- Score Display ---
	set_cursor 1, 15
	mymessage str1
	set_cursor 1, 21
	mov ax, score
	call myoutput
	;---------------------

	;--- lives ---
	set_cursor 1, 1
	mov al, 3   			      ; ASCII code of Character (Heart)
	mov bx,0
	mov bl,4   				      ; color
	mov cx,	heart_lives     ; repetition count
	mov ah,09h
	int 10h
	;-------------

	;--- Display Name ---
	set_cursor 0, 30
	mymessage names
	;--------------------

	;--- Display level ---
	set_cursor 2, 30
	mymessage display_level
	;--------------------

ret
score_bar endp

username_input proc

  ;--- video mode (graphic) 
	mov ah, 0
	mov al, 13h    ;320x200
	int 10h	

  ;--- set background black
	mov ax, 0
	mov ah, 0Bh
	mov bh, 00
	mov bl, 00
	int 10h	

	set_cursor 2, 10	; prints "brick breaker game"
	mymessage str8

	;--- user name input ---
	set_cursor 6, 11
	mymessage str9
	set_cursor 7, 11
	mov dx, offset names
	mov ah, 3fh
	int 21h
	;-----------------------

ret
username_input endp

move_paddle proc

	;--- key input ---
	mov ah, 01h
	int 16h 
	jz skip_controls		; checks if key is pressed

	mov ah, 00h				  ; checks which key is pressed
	int 16h

	cmp ah, 4bh				  ; checks for left key
	je left

	cmp ah, 4dh				  ; checks for right key
	je right

	jmp skip_controls
  ;------------------
	
	;--- moving paddle right ---
	right:
    call clear_paddle
    mov ax, paddle_x
    add ax, paddle_width
    ;cmp ax, window_width		; checks for right boundary collision
    .if (ax >= window_width)
      jmp skip_controls
    .endif
    mov ax, paddle_velocity
    add paddle_x, ax
    jmp skip_controls
	;---------------------------
	
	;--- moving paddle left ---
	left:
    call clear_paddle
    ;cmp paddle_x, 10			; checks for left boundary collision
    je skip_controls
    .if (paddle_x <= 10)
      jmp skip_controls
    .endif
    mov ax, paddle_velocity
    sub paddle_x, ax
	;---------------------------

	skip_controls:

ret
move_paddle endp

draw_paddle proc
	;--- drawing paddle after setting the position
	mov cx, paddle_x    ; (column)
	mov dx, paddle_y    ; (row)

	mov old_paddle_x, cx
	mov old_paddle_y, dx

	mov si, offset paddle_x
	call draw_block
	;--- drawing end

ret
draw_paddle endp

control_ball proc

	;--- key input
	mov ah,0
	int 16h
	
	cmp al, "w"
	je up

	cmp al,	"s"
	je down

	cmp al, "d"
	je right

	cmp al, "a"
	je left

	cmp al, "p"
	je devmode_off

	ret

	up:
	mov ax, ball_velocity_y
	sub ball_y, ax				; vertical movement
	ret

	down:
	mov ax, ball_velocity_y
	add ball_y, ax				; vertical movement
	ret

	left:
	mov ax, ball_velocity_x
	sub ball_x, ax				; horizontal movement
	ret

	right:
	mov ax, ball_velocity_x
	add ball_x, ax				; horizontal movement
	ret

	devmode_off:
	mov dev_mode, 0
	ret
control_ball endp

move_ball proc	

	.if (dev_mode == 0)
		mov ax, ball_velocity_x
		add ball_x, ax				; horizontal movement 

		mov ax, ball_velocity_y
		add ball_y, ax				; vertical movement
	.endif

;--- left border ---
	mov ax, window_bounds
	cmp ball_x, ax				; ball_x < 0 (ball is collided)
	jl NEG_VELOCITY_X
;---

;--- right border ---
	mov ax, window_width
	sub ax, ball_size
	sub ax, window_bounds
	cmp ball_x, ax				; ball_x > window_width (ball is collided)
	jg NEG_VELOCITY_X			
;---

;--- top border ---
	;mov ax, window_bounds
	cmp ball_y, 25				; to bounce off the score bar
	jl NEG_VELOCITY_Y			; ball_y < 0 (ball is collided)
;---

;--- bottom border ---
	mov ax, window_height
	sub ax, ball_size
	sub ax, window_bounds
	cmp ball_y, ax
	jg RESET_BALL			; ball_y > window height (ball is collided)
	;jg NEG_VELOCITY_Y
;---

	;--- paddle collision here ---
		mov bx, paddle_x
		add bx, paddle_width
		mov upper_limit, bx

		mov bx, paddle_x
		mov lower_limit, bx

		mov bx, paddle_x
		add bx, paddle_portion_length
		mov middle_limit1, bx

		mov bx, paddle_x
		add bx, paddle_width
		sub bx, paddle_portion_length
		mov middle_limit2, bx

		mov bx, ball_x

		mov ax, paddle_y
		sub ax, paddle_height

		.if (ball_y == ax) && (bx >= lower_limit) && (bx < middle_limit1)
			jmp move_left
		.elseif (ball_y == ax) && (bx > middle_limit2) && (bx <= upper_limit)
			jmp move_right
		.elseif	(ball_y == ax) && (bx >= middle_limit1) && (bx <= middle_limit2)
			jmp move_up
		.endif
	;--------------------------------------
	
	;--- brick collision ---
	mov si, offset brick_11
	mov counter, 0
	.while (counter < 38)

    ;--- setting criteria for the collision conditions ---
		mov ax, [si]        ; ax = brick_x 
		mov b_left, ax      ; b_left = brick_x
		add ax, [si+6]      ; ax/brick_x + brick_width
		mov b_right, ax     ; b_right = ax/brick_x + brick_width

		mov ax, [si+2]      ; ax = brick_y
		mov b_up, ax        ; b_up = brick_y
		add ax, [si+4]      ; brick_y + brick_height
		mov b_down, ax      ; b_down = brick_y + brick_height

		mov cx, [si+10]     ; cx = brick hits

    ;--- collision of upper part of the brick ---
		mov ax, ball_x
		add ax, 2
		mov bx, ball_y
		add bx, 5
		.if (bx <= b_down) && (bx >= b_up) && (ax >= b_left) && (ax <= b_right) && (cx >= 1)	;upper part
			neg ball_velocity_y
			call beep
			jmp break_brick
		.endif
    ;-------------------------------------------

    ;--- collision of left part of the brick ---
		mov ax, ball_x
		mov bx, ball_y
		add bx, 2
		.if (bx <= b_down) && (bx >= b_up) && (ax >= b_left) && (ax <= b_right) && (cx >= 1)	;left part
			neg ball_velocity_x
			call beep
			jmp break_brick
		.endif
    ;-------------------------------------------

    ;--- collision of lower part of the brick ---
		mov ax, ball_x
		add ax, 2
		mov bx, ball_y
		.if (bx <= b_down) && (bx >= b_up) && (ax >= b_left) && (ax <= b_right) && (cx >= 1)	;lower part
			neg ball_velocity_y
			call beep
			jmp break_brick
		.endif
    ;-------------------------------------------

    ;--- collision of right part of the brick ---
		mov ax, ball_x
		add ax, 5
		mov bx, ball_y
		add bx, 2
		.if (bx <= b_down) && (bx >= b_up) && (ax >= b_left) && (ax <= b_right) && (cx >= 1)	;right part
			neg ball_velocity_x
			call beep
			jmp break_brick
		.endif
    ;-------------------------------------------

	inc counter
	add si, 12
	.endw
	mov counter, 0
	ret

	NEG_VELOCITY_Y:
		call beep
		neg ball_velocity_y		; switch signs from positive to negative and vice versa
		ret
	NEG_VELOCITY_X:
		call beep
		neg ball_velocity_x		; switch signs from positive to negative and vice versa
		ret
	RESET_BALL:					  ; when ball hits the bottom
		call beep
		dec heart_lives
		mov ball_x, 20
		mov ball_y, 105			; last digit should be 5
		ret

	move_left:
		neg ball_velocity_y
		mov ax, ball_velocity_x_left
		mov ball_velocity_x, ax
		call beep
		ret
	move_right:
		neg ball_velocity_y
		mov ax, ball_velocity_x_right
		mov ball_velocity_x, ax
		call beep
		ret
	move_up:
		neg ball_velocity_y
		mov ball_velocity_x, 0
		call beep
		ret

	break_brick:
		mov ax, [si+8]
		mov di, si			; storing copy for special brick operation
		mov temp_color, ax

		.if (ax != 7)		; condition for unbreakable blocks. if it's an unbreakable block, don't increase score
			inc score
		;--- decrease brick hit ---
			mov ax, [si+10]       ; ax = brick hit
			dec ax                ; ax--
			mov [si+10], ax       ; brick hit = ax
		.endif

		.if (ax == 0)
			call draw_black_block	; draw black block over the map
			mov ax, 0
			mov [si+8], ax			; set that particular block to black color when redrawing ( for error handling in resuming/pausing the game )
		.elseif (ax == 1)
			call draw_red_block
			mov ax, 12
			mov [si+8], ax			; set that particular block to red color when redrawing ( for error handling in resuming/pausing the game )
		.elseif (ax == 2)
			call draw_green_block
			mov ax, 10
			mov [si+8], ax			; set that particular block to green color when redrawing ( for error handling in resuming/pausing the game )
		.endif

		.if (temp_color == 15) ; white color (special brick)

			mov cx, 5
				loop1:
				mov temp_counter, cx
					;mov si, di
					MOV AH, 00h  ; interrupts to get system time        
   					INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   					mov  ax, dx
   					xor  dx, dx
   					mov  cx, 8    
   					div  cx
					mov cx, dx
					loop2:
						add si, 12
					loop loop2

					call draw_black_block	; draw black block over the map
					mov ax, 0
					mov [si+8], ax
					mov [si+10], ax	
				mov cx, temp_counter
			loop loop1

		.endif

    .if (temp_color == 13)
        mov ax, [si]
        mov object_x, ax
        mov ax, [si+2]
        mov object_y, ax
        mov special_object_switch, 1
        inc special_brick_count 
		.endif

		;--- key inputs for special ball ---			; don't hit the first block :) the game will glitch :(
		.if (ball_color == 13)
			add si, 12
			call draw_black_block	; draw black block over the map
			mov ax, 0
			mov [si+8], ax
			mov [si+10], ax	
			sub si, 12
			sub si, 12
			call draw_black_block	; draw black block over the map
			mov ax, 0
			mov [si+8], ax
			mov [si+10], ax	
			add score, 2
		.endif
	;--------------------------------------
	;call beep
	ret
move_ball endp

special_object proc

    mov ax, object_y
    mov old_object_y, ax

		mov ax, 1
		add object_y, ax				; horizontal movement 

  	mov bx, paddle_x
		add bx, paddle_width
		mov upper_limit, bx

		mov bx, object_x

		mov ax, paddle_y
		sub ax, paddle_height

		.if (object_y == ax) && (bx >= lower_limit) && (bx <= upper_limit)  ; when the object is caught by the paddle
      .if (special_brick_count == 1)          ; extend paddle
          mov paddle_width, 120			    
          mov paddle_portion_length, 40	
          mov paddle_velocity, 10
          mov paddle_color, 13
          mov special_object_switch, 0
        .elseif (special_brick_count == 2)    ; special ball
          mov ax, 13
          mov ball_color, al
          mov special_object_switch, 0
        .elseif (special_brick_count == 3)    ; increment heart
          inc heart_lives
          mov special_object_switch, 0
        .endif
    .elseif (object_y == 200)           ; when the object is missed, turn off the switch
      mov special_object_switch, 0
		.endif

ret
special_object endp

draw_special_object proc

  MOV CX, object_x			;--- column
	MOV DX, old_object_y			;--- row


	CLEAR_object_HORIZONTAL:
	MOV AL, 0  ;black color
	MOV AH, 0CH 
	INT 10H
	inc cx
	mov ax, CX
	sub ax, object_x
	cmp ax, object_size
	jng CLEAR_object_HORIZONTAL
	mov cx, object_x
	inc DX
	mov ax, DX

	sub ax, old_object_y
	cmp ax, object_size
	jng CLEAR_object_HORIZONTAL
ret

ret
draw_special_object endp

clear_special_object proc
	;--- clear ball
  mov cx, object_x
	MOV DX, object_y    ;(row)

	CLEAR_object_HORIZONTAL:
	MOV AL, 13  ;black color
	MOV AH, 0CH 
	INT 10H
	inc cx
	mov ax, CX
	sub ax, object_x
	cmp ax, object_size
	jng CLEAR_object_HORIZONTAL
	mov cx, object_x
	inc DX
	mov ax, DX

	sub ax, object_y
	cmp ax, object_size
	jng CLEAR_object_HORIZONTAL
ret
clear_special_object endp

draw_ball proc
	MOV CX, ball_x			;--- column
	MOV DX, ball_y			;--- row

	MOV old_ball_x, cx		; used to delete the old ball position
	MOV old_ball_y, dx		; used to delete the old ball position

	;--- draw circle ball
	mov ax, ball_y
	mov draw_ball_y, ax
	mov bx, ball_x
	mov draw_ball_x, bx

	add draw_ball_x, 2
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color

	inc draw_ball_y
	mov draw_ball_x, bx
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color

	inc draw_ball_y
	mov draw_ball_x, bx
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color

	inc draw_ball_y
	mov draw_ball_x, bx
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color


	inc draw_ball_y
	mov draw_ball_x, bx
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color

	inc draw_ball_y
	mov draw_ball_x, bx
	add draw_ball_x, 2
	draw_pixel draw_ball_y, draw_ball_x, ball_color
	inc draw_ball_x
	draw_pixel draw_ball_y, draw_ball_x, ball_color

ret
draw_ball endp

clear_paddle proc
	;--- clear paddle
	MOV CX, old_paddle_x    ; (column)
	MOV DX, old_paddle_y    ; (row)
	
	CLEAR_PADDLE_HORIZONTAL:
	MOV AL, 0  ; black color
	MOV AH, 0CH 
	INT 10H
	inc cx
	mov ax, CX
	sub ax, old_paddle_x
	cmp ax, paddle_width
	jng CLEAR_PADDLE_HORIZONTAL
	mov cx, paddle_x
	inc DX
	mov ax, DX

	sub ax, old_paddle_y
	cmp ax, paddle_height
	jng CLEAR_PADDLE_HORIZONTAL
ret
clear_paddle endp

clear_ball proc
	;--- clear ball
	MOV CX, old_ball_x    ;(column)
	MOV DX, old_ball_y    ;(row)

	CLEAR_BALL_HORIZONTAL:
	MOV AL, 0  ;black color
	MOV AH, 0CH 
	INT 10H
	inc cx
	mov ax, CX
	sub ax, old_ball_x
	cmp ax, ball_size
	jng CLEAR_BALL_HORIZONTAL
	mov cx, old_ball_x
	inc DX
	mov ax, DX

	sub ax, old_ball_y
	cmp ax, ball_size
	jng CLEAR_BALL_HORIZONTAL

ret
clear_ball endp

draw_block proc
	mov cx, [si]			;--- column
	mov dx, [si+2]			;--- row

	DRAW_brick_HORIZONTAL:
	mov AL, [si+8]  		;--- color
	mov AH, 0CH 
	INT 10H
	inc cx
	mov ax, cx
	sub ax, [si]			;--- brick_x
	cmp ax, [si+6]			;--- brick width
	jng DRAW_brick_HORIZONTAL
	mov cx, [si]			;--- brick_x
	inc dx
	mov ax, dX

	sub ax, [si+2]			;--- brick_y
	cmp ax, [si+4]			;--- brick height
	jng DRAW_brick_HORIZONTAL
ret
draw_block endp

draw_black_block proc
	mov cx, [si]			;--- column
	mov dx, [si+2]			;--- row

	DRAW_brick_HORIZONTAL:
	mov AL, 0  		;--- color
	mov AH, 0CH 
	INT 10H
	inc cx
	mov ax, cx
	sub ax, [si]			;--- brick_x
	cmp ax, [si+6]			;--- brick width
	jng DRAW_brick_HORIZONTAL
	mov cx, [si]			;--- brick_x
	inc dx
	mov ax, dX

	sub ax, [si+2]			;--- brick_y
	cmp ax, [si+4]			;--- brick height
	jng DRAW_brick_HORIZONTAL
ret
draw_black_block endp

draw_red_block proc
	mov cx, [si]			;--- column
	mov dx, [si+2]			;--- row

	DRAW_brick_HORIZONTAL:
	mov AL, 12  		;--- color
	mov AH, 0CH 
	INT 10H
	inc cx
	mov ax, cx
	sub ax, [si]			;--- brick_x
	cmp ax, [si+6]			;--- brick width
	jng DRAW_brick_HORIZONTAL
	mov cx, [si]			;--- brick_x
	inc dx
	mov ax, dX

	sub ax, [si+2]			;--- brick_y
	cmp ax, [si+4]			;--- brick height
	jng DRAW_brick_HORIZONTAL
ret
draw_red_block endp

draw_green_block proc
	mov cx, [si]			;--- column
	mov dx, [si+2]			;--- row

	DRAW_brick_HORIZONTAL:
	mov AL, 10  		;--- color
	mov AH, 0CH 
	INT 10H
	inc cx
	mov ax, cx
	sub ax, [si]			;--- brick_x
	cmp ax, [si+6]			;--- brick width
	jng DRAW_brick_HORIZONTAL
	mov cx, [si]			;--- brick_x
	inc dx
	mov ax, dX

	sub ax, [si+2]			;--- brick_y
	cmp ax, [si+4]			;--- brick height
	jng DRAW_brick_HORIZONTAL
ret

draw_green_block endp

exit_menu proc
	;--- video mode (graphic) 
	mov ah, 0
	mov al, 13h    ;320x200
	int 10h	

	;--- set background black ---
	mov ax, 0
	mov ah, 0Bh
	mov bh, 00
	mov bl, 00
	int 10h	

	;--- Game Over message ---
	set_cursor 10, 15
	mymessage str2

	;--- Score display --=
		set_cursor 13, 16
		mymessage str1
		mov ax, score
		call myoutput 
	;---------------------
ret
exit_menu endp

write_file proc
  ;--- open an existing file ---
    mov ah, 3dh
    mov dx, offset fname
    mov al, 2
    int 21h
    mov fhandle, ax

  ;--- set cursor to the end of the file ---
    mov ah, 42h
    mov bx, fhandle
    mov cx, 0
    mov dx, 0
    mov al, 2
    int 21h

  ;--- write name ---
    mov si, offset names
    call string_size
    mov ah, 40h
    mov bx, fhandle
    mov dx, offset names
    int 21h

  ;--- write score ---
    call integerToString
    mov si, offset string_scores
    call string_size
    mov ah, 40h
    mov bx, fhandle
    mov dx, offset string_scores
    int 21h

  ;--- write level ---
    mov si, offset string_level
    call string_size
    mov ah, 40h
    mov bx, fhandle
    mov dx, offset string_level
    int 21h

  ;--- close a file ---
    mov ah, 3eh
    mov bx, fhandle
    int 21h
   
ret
write_file endp

read_file proc
  ;open an existing file
    mov ah, 3dh
    mov dx, offset fname
    mov al, 2
    int 21h
    mov fhandle, ax

  ; read file
    mov ah, 3fh
    mov dx, offset string_highscores
    mov cx, 100
    mov bx, fhandle
    int 21h 

  ; output string
    ;mov dx, offset string_highscores
    ;mov ah, 09h
    ;int 21h

  ; close a file
    mov ah, 3eh
    mov bx, fhandle
    int 21h
ret
read_file endp

index_moving proc
	;mov si, offset string_highscores
	   
    loop1: 
      inc si
      mov ax, [si]
      cmp al, "$"
      jne skip
        inc si
        jmp stop
      skip:
	  jmp loop1
	stop:
ret
index_moving endp

myoutput proc

OUTPUT:
	;MOV AX, enteredNumber ; before calling make sure to mov the number in ax or al register depending on the type
	mov dx, 0
	mov bx, 10
	L1:
		mov dx, 0
		cmp ax, 0
		je DISP
		div bx
		mov cx, dx
		push cx
		inc output_counter
		mov ah, 0
	jmp L1

DISP:
	cmp output_counter, 0
	je EXIT
	pop dx
	add dx, 48
	mov ah, 02h
	int 21h
	dec output_counter
jmp DISP

EXIT:
;---Output End---

ret
myoutput endp

integerToString proc
	mov si, offset string_scores
	mov ax, score
	mov dx, 0
	mov bx, 10
	L1:
		mov dx, 0
		cmp ax, 0
		je DISP
		div bx
		mov cx, dx
		push cx
		inc output_counter
		mov ah, 0
	jmp L1

DISP:
	cmp output_counter, 0
	je EXIT
	pop dx
	add dx, 48
	mov [si], dl
	inc si
	dec output_counter
jmp DISP

EXIT:
ret
integerToString endp

string_size proc
  ;mov si, offset msg
  mov cx, 0 
  mov ax, 0
  
  name_count: 
  inc cx
  mov al, [si]
  cmp ax, "$" 
  je skip_count 
  inc si
  jmp  name_count
  skip_count:
  mov ax, 0
ret
string_size endp

delay proc

	;mov cx, 119999
	;mov cx, 1
	mov bx, 0
	loop1:

	inc bx
	loop loop1
	mov bx, 0
ret
delay endp

beep proc

	push ax
	push cx
	push dx
	push bx
	push sp
	push bp
	push si
	push di

	mov al, 182
	out 43h, al
	mov ax, 4560

	out 42h, al
	mov al, ah
	out 42h, al
	in al, 61h

	or al, 00000011b
	out 61h, al
	mov bx, 10

	pause1:
		mov cx, 3000
	pause2:
	dec cx
	jne pause2
	dec bx
	jne pause1
	in al, 61h

	and al,11111100b
	out 61h, al

	pop di
	pop si
	pop bp
	pop sp
	pop bx
	pop dx
	pop cx
	pop ax
ret
beep endp
end