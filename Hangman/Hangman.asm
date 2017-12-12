TITLE Hangman    (hangman.asm)
; Description:    A two-player ASCII art hangman game
; Authors: The Fighting Rutabagas featuring
;        Tersa Motbaynor Almaw
;        Andrew McNeill
;        Jude Battista

INCLUDE Irvine32.inc    

.data

;Test data
guessSugar BYTE "The current guess is: ",0
playerNameSugar BYTE "The player's name is: ",0
targetWordSugar BYTE "The target word is: ",0
winningScoreSugar BYTE "The winning score is: ",0
wordMaxLengthSugar BYTE "The max word length is: ",0

;Production data
defaultMaxAnswerLength DWORD 16
currentRound DWORD 1
currentRoundmessage BYTE "Current Round:",0

promptNamePlayer1 BYTE "Player 1 you will start as the guesser, please enter your name: ",0
promptNamePlayer2 BYTE "Player 2 you will start as the executioner, please enter your name: ",0
player1Name BYTE 16 DUP(0)
player2Name BYTE 16 DUP(0)
nameMaxLength DWORD 16

p1GuesserBool BYTE 1
p2GuesserBool BYTE 1
P1GuesserTag BYTE "    Guesser!",0
P2GuesserTag BYTE "Guesser!    ",0
executionerTag BYTE "Executioner!",0
P1TagCoordX BYTE 22
P1TagCoordY BYTE 1

P2TagCoordX BYTE 76
P2TagCoordY BYTE 1

promptWordMaxLength BYTE "Input the maximum length of the words you wish to play with today: ",0
wordMaxLength DWORD 16

promptWinningScore BYTE "Input the score you would like to play to: ",0
winningScore BYTE 0

promptTargetWord BYTE "Executioner, input the target word: ",0
targetWord BYTE 100 DUP(0)
displayWord BYTE 100 DUP(0)
targetWordLength DWORD 0
displayWordX BYTE 60
displayWordY BYTE 10

promptNextRound BYTE "Press any key to start the next round",0

promptGuess BYTE "Guesser, input the letter you would like to guess: ",0
currentGuess BYTE 0
messageAlreadyGuessed BYTE "That letter was already guessed.",0
getGuessX BYTE 0
getGuessY BYTE 21

failState DWORD 0
successState DWORD 0
maxFailure DWORD 6
messageFail BYTE "With a horrible snap, your virtual avatar's neck gives way to gravity's ceaseless urging.",0
messageSuccess BYTE "They laughed at you, but you always knew those neck curls would prove useful. The rope gives way before your neck does and you live to play again.",0
statusMessageX BYTE 0
statusMessageY BYTE 22

player1Score BYTE 0
player2Score BYTE 0
messageVictory0 BYTE " defeats ",0 
messageVictory1 BYTE " by a final score of ",0
messageVictory2 BYTE " to ", 0


alphabet BYTE "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
alphaLeft BYTE "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
guessesX BYTE 27
guessesY BYTE 16

; ascii data, start x and y coordinates 
starty byte 0
startx byte 0

.code
DrawHangman proc uses edx eax ebx ecx
; gallows

; torque
    mov dh, starty  
    mov dl, startx 
    add dl, 7

    call Gotoxy
    mov al, 5Fh
    call WriteChar

    inc dl
    call Gotoxy
    mov al, 5Fh
    call WriteChar

    inc dl
    call Gotoxy
    mov al, 5Fh
    call WriteChar

    inc dl
    call Gotoxy
    mov al, 5Fh
    call WriteChar

    inc dl
    call Gotoxy
    mov al, 5Fh
    call WriteChar
    
    inc dl
    call Gotoxy
    mov al, 5Fh
    call WriteChar
	
    ; loop for the gallow
    mov ecx, 9
    mov dh, starty
    mov dl, startx
    add dl,13
    mov al, 7Ch

L1:

    inc dh
    call Gotoxy
    call WriteChar                            ;7Ch
LOOP L1

    
; continue of the hanger
    mov dh, starty
    add dh, 9
    mov dl, startx
    add dl, 9

    call Gotoxy
    mov al, 5Fh
    call WriteChar

    mov dh, starty
    add dh, 9
    mov dl, startx
    add dl, 10

    call Gotoxy
    mov al, 5Fh
    call WriteChar

    mov dh, starty
    add dh, 9
    mov dl, startx
    add dl, 11

    call Gotoxy
    mov al, 5Fh
    call WriteChar

    mov dh, starty
    add dh, 9
    mov dl, startx
    add dl, 12

    call Gotoxy
    mov al, 5Fh
    call WriteChar

    mov dh, starty
    add dh, 9
    mov dl, startx
    add dl, 14

    call Gotoxy
    mov al, 5Fh
    call WriteChar

    
    mov dh, starty
    add dh, 9
    mov dl, startx
    add dl, 15

    call Gotoxy
    mov al, 5Fh
    call WriteChar

    mov dh, starty
    add dh, 9
    mov dl, startx
    add dl, 16

    call Gotoxy
    mov al, 5Fh
    call WriteChar

    mov dh, starty
    add dh, 9
    mov dl, startx
    add dl, 17

    call Gotoxy
    mov al, 5Fh
    call WriteChar


; head 
    xor ebx, ebx
    mov ecx, failState
    inc ebx                ;We want to draw the head if failState >= 1
    cmp ecx, ebx
    jl fini                ;If failState < 1 skip to the end

    mov dh, starty        ;Otherwise, draw the head
    add dh, 2
    mov dl, startx
    add dl, 6
     
    call Gotoxy
    mov al, 4Fh 
    call WriteChar 

; body
    inc ebx                ;We want to draw the body if failState >= 2
    cmp ecx, ebx
    jl fini                ;If failState < 2, jump to the end
    
    mov dh, starty        ;Otherwise, draw the body parts 
    add dh, 3
    mov dl, startx 
    add dl, 6

    call Gotoxy
    mov al, 7Ch
    call WriteChar

; second body part
    mov dh, starty
    add dh, 4 
    mov dl, startx 
    add dl, 6
    
    call Gotoxy
    mov al, 7Ch
    call WriteChar

        
; first left leg part
    inc ebx                ;We want to draw the body if failState >= 3
    cmp ecx, ebx         
    jl fini                ;If failState < 3, jump to the end
    
    mov dh, starty      ;Otherwise, draw the first and second right arm (as one)
    add dh, 5
    mov dl, startx
    add dl, 5

    call Gotoxy
    mov al, 2Fh
    call WriteChar

; second left leg part
    mov dh, starty 
    add dh, 6
    mov dl, startx
    add dl, 4

    call Gotoxy
    mov al, 2Fh
    call WriteChar

; left foot 
    mov dh, starty 
    add dh, 6
    mov dl, startx
    add dl, 3

    call Gotoxy
    mov al, 5Fh
    call WriteChar

; first right leg part
    inc ebx                ;We want to draw the body if failState >= 4
    cmp ecx, ebx         
    jl fini                ;If failState < 4, jump to the end

    mov dh, starty        ;Otherwise, draw the first and second right leg (as one)
    add dh, 5
    mov dl, startx 
    add dl, 7

    call Gotoxy
    mov al, 5Ch
    call WriteChar

; second right leg part
    mov dh, starty 
    add dh, 6
    mov dl, startx
    add dl, 8

    call Gotoxy
    mov al, 5Ch
    call WriteChar


; right foot  
    mov dh, starty
    add dh, 6
    mov dl, startx
    add dl, 9

    call Gotoxy
    mov al, 5Fh
    call WriteChar
    

; left first arm 
    inc ebx             ;We want to draw the body if failState >= 5
    cmp ecx, ebx        
    jl fini             ;If failState < 5, jump to the end
    
    mov dh, starty         ;Otherwise, draw the first and second left arm (as one)
    add dh, 3
    mov dl, startx
    add dl, 5

    call Gotoxy
    mov al, 2Fh
    call WriteChar

; left second arm 
    mov dh, starty 
    add dh, 4
    mov dl, startx
    add dl, 4

    call Gotoxy
    mov al, 2Fh
    call WriteChar

; right first arm        
    inc ebx                ;We want to draw the body if failState >= 6
    cmp ecx, ebx         
    jl fini                ;If failState < 6, jump to the end
    
    mov dh, starty         ;Otherwise, draw the first and second right arm (as one)
    add dh, 3 
    mov dl, startx 
    add dl, 7

    call Gotoxy
    mov al, 5Ch
    call WriteChar

; right second arm             
    mov dh, starty
    add dh, 4 
    mov dl, startx 
    add dl, 8

    call Gotoxy
    mov al, 5Ch
    call WriteChar


fini:
; creates void space for the "press any key to continue" 
    mov dh, starty
    add dh, 20
    mov dl, startx
    add dl, 20

    call Gotoxy
    mov al, 20h
    call WriteChar
    call crlf 

    ret 
DrawHangman endp



;CallAndResponseString uses eax, ecx, and edx
;It requires three parameters pushed to the stack:
;    address of the prompt you wish to display
;    address where you wish to store the answerAddress
;    max length of the answer
;It then displays the prompt and stores the answer
CallAndResponseString proc USES eax ecx edx,
    promptAddress:DWORD,
    answerAddress:DWORD,
    answerMaxSize:DWORD

    mov edx, promptAddress
    call WriteString
    mov edx, answerAddress
    mov ecx, answerMaxSize
    call ReadString
    ret
CallAndResponseString endp

;CallAndResponseInt uses eax, ecx, and edx
;It requires three parameters pushed to the stack:
;    address of the prompt you wish to display
;    address where you wish to store the answerAddress
;    max length of the answer
;It then displays the prompt and stores the answer
;Usable on values up to 255
CallAndResponseInt proc USES eax ecx edx,
    promptAddress:DWORD,
    answerAddress:DWORD

    mov edx, promptAddress
    call WriteString
    call ReadInt
    mov ecx, answerAddress
    mov [ecx], al
    ret
CallAndResponseInt endp


;Uses CallAndResponse to store the name for each player
GetNames proc
    push nameMaxLength
    push OFFSET player1Name
    push OFFSET promptNamePlayer1
    Call CallAndResponseString
    
    push nameMaxLength
    push OFFSET player2Name
    push OFFSET promptNamePlayer2
    Call CallAndResponseString
    ret
GetNames endp

;Uses CallAndResponse to store the maximum word length for this session
GetWordMaxLength proc
    push OFFSET wordMaxLength
    push OFFSET promptWordMaxLength
    call CallAndResponseInt
    ret
GetWordMaxLength endp

;Uses CallAndResponse to store the winning score for this session
GetWinningScore proc
    push OFFSET winningScore
    push OFFSET promptWinningScore
    call CallAndResponseInt
    ret
GetWinningScore endp

;Stores the target word and its length for this round
GetTargetWord proc uses eax ecx edx esi
	call ClearStatusMessage
	mov dl, statusMessageX
	mov dh, statusMessageY
	call Gotoxy
    mov edx, OFFSET promptTargetWord
    call WriteString
    mov edx, OFFSET targetWord
    mov ecx, wordMaxLength
    call ReadString
    mov targetWordLength, eax    ;Store the length of the word
    mov ecx, eax                ;copy the word length to our loop counter
    xor esi, esi                ;zero our index
    mov al, 5fh                    ;load al with the ASCII code for underscore
CreateDisplayWord:
    mov displayWord[esi], al    ;...and write it to displayWord
    and targetWord[esi], 0DFh    ;And while we're at it, let's make targetWord uppercase for ease of comparison
    inc esi                        ;increment index
loop CreateDisplayWord
	mov ecx, 25
	mov esi, 0
ClearGuesses:					;Get rid of all guessed data
	mov al, alphabet[esi]		;Copy the index value from alphabet
	mov alphaLeft[esi], al		;And dump it into the index of alphLeft
	inc esi						;increment index
loop ClearGuesses
    ret
GetTargetWord endp

;Clears the primary status message by overwriting it with spaces
;Inelegant, but effective!
ClearStatusMessage proc uses ecx edx
	mov dl, statusMessageX		;Goto the status message coords
	mov dh, statusMessageY
	call Gotoxy
	mov al, 20h					;Load a blank space into our WriteChar buffer
	mov ecx, 200				;Load loop counter
ClearMessage:
	call WriteChar
	inc dl
	call Gotoxy
Loop ClearMessage
	ret
ClearStatusMessage endp

ClearGuessMessage proc uses ecx edx
	mov dl, statusMessageX		;Goto the status message coords
	mov dh, statusMessageY
	dec dh						;If we ever have a 0 y-val for statusMessage, this will be a problem!
	call Gotoxy
	mov al, 20h					;Load a blank space into our WriteChar buffer
	mov ecx, 200				;Load loop counter
ClearMessage:
	call WriteChar
	inc dl
	call Gotoxy
Loop ClearMessage
	ret
ClearGuessMessage endp

;Clears the auxiliary message sometimes used in conjunction with the status message
ClearAuxMessage proc uses ecx edx
	mov dl, statusMessageX		;Goto the status message coords
	mov dh, statusMessageY
	inc dh						;And then go down one line
	call Gotoxy
	mov al, 20h					;Load a blank space into our WriteChar buffer
	mov ecx, 200				;Load loop counter
ClearMessage:
	call WriteChar
	inc dl
	call Gotoxy
Loop ClearMessage
	ret
ClearAuxMessage endp

;Gets a letter from the guesser and store it in currentGuess
GetGuess proc uses eax edx
    ;First we need to get the guess from the user
	mov dh, getGuessY	;Move to the input coordinates
	mov dl, getGuessX
	call Gotoxy
    mov edx, OFFSET promptGuess
    call WriteString
    call ReadChar            ;store the guess in al
    and al, 0DFh            ;render the letter uppercase
    mov currentGuess, al    ;store the uppercase letter in currentGuess
	call ClearGuessMessage
    ret
GetGuess endp

OutputGuesses proc USES eax ebx ecx esi
	mov dh, guessesY		;Move to the guesses output coordinates
	inc dh					;Leave room for the box around the guesses
	mov dl, guessesX
	inc dl					;Leave room for the box around the guesses
	call Gotoxy
    mov ecx, 26             ;Need to check 26 letters
    xor esi, esi            ;Zero our index
    xor ebx, ebx            ;We will need a zero register
WalkAlphaleft:
    mov al, alphabet[esi]    
    mov ah, alphaLeft[esi]
    cmp ah, al                ;Compare the letter at the index in both 'bet and 'left
    cmove eax, ebx             ;If they're the same, the letter has not been guessed so we want to output... nothing
    call WriteChar            ;Output the either the letter or nothing
    mov al, 20h                ;Output a space
    call WriteChar
    inc esi                    ;increment loop counter
loop WalkAlphaleft
    ret
OutputGuesses endp

OutputDisplayWord proc uses eax ecx edx esi
	mov dl, displayWordX		;Set coordinates at which to write the display word
	mov dh, displayWordY		
	Call Gotoxy
    mov ecx, targetWordLength    ;load our loop counter
    xor esi, esi                ;clear our index
WalkDisplayWord:                ;walk the display word and output each character
    mov al, displayWord[esi]
    call WriteChar
    inc esi
loop WalkDisplayWord
    ret
OutputDisplayWord endp

DisplayUI proc
	mov dh, 0
    mov dl, 35
    call Gotoxy

    mov ECX, 40
    mov al, 3Dh
TOPnameBoxes:
    call WriteChar
    inc dl
LOOP TOPnameBoxes

    mov dh, 2
    mov dl, 35
    call Gotoxy
    mov ECX, 40
    mov al, 3Dh
    BOTnameBoxes:
    call WriteChar
    inc dl
LOOP BOTnameBoxes    
    
    mov dh, 1
    mov dl, 35
    call Gotoxy
    mov al, 7Ch
    call WriteChar

    mov dl, 52
    call Gotoxy
    call WriteChar

    mov dl, 55
    call Gotoxy
    call WriteChar

    mov dl, 58
    call Gotoxy
    call WriteChar

    mov dl, 74
    call Gotoxy
    call WriteChar


    mov dh, 1
    mov dl, 41
    call Gotoxy
    mov edx, OFFSET player1Name
    call WriteString

    mov dh, 1
    mov dl, 62
    call Gotoxy
    mov edx, OFFSET player2Name
    call WriteString

; Gallows/hangman
    mov startx, 42
    mov starty, 5
    call DrawHangman
; box around guessed letters
    mov dh, guessesy
    mov dl, guessesX
    Call Gotoxy
    mov al, 3Dh
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar


    add dl, 2
    Call Gotoxy
    Call WriteChar

    mov dh, 17
    mov dl, 26
    Call Gotoxy
    mov al, 7ch
    Call WriteChar

    add dl, 54
    Call Gotoxy
    Call WriteChar

    mov dh, 18
    mov dl, 27
    Call Gotoxy
    mov al, 3Dh
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

    add dl, 2
    Call Gotoxy
    Call WriteChar

; Output guesses
    mov dh, 17
    mov dl, 28
    Call Gotoxy
    call OutputGuesses

    mov dh, 20
    mov dl, 0
    Call Gotoxy
    
    mov dh, 0
    mov dl, 0
    Call Gotoxy
    mov edx, OFFSET currentRoundmessage
    call WriteString

    mov dh, 0
    mov dl, 14
    Call Gotoxy
    mov eax, currentRound
    call WriteDec
DisplayUI endp

DisplayScore proc
    mov dh, 1
    mov dl, 53
    call Gotoxy
	xor eax, eax
    mov al, player1Score
    call WriteDec

    mov dh, 1
    mov dl, 56
    call Gotoxy
	xor eax, eax
    mov al, player2Score
    call WriteDec

    mov dh, 20
    mov dl, 0
    call Gotoxy
    ret
DisplayScore endp

CheckGuess proc USES eax ebx ecx edx edi esi
	call ClearStatusMessage
	call ClearAuxMessage
    xor eax, eax                ;clear eax
    xor edx, edx                ;clear edx
    xor edi, edi                ;clear edi, will be our running total of characters in the target word matched by guess
    mov al, currentGuess
    ;First we need to see if the letter has already been guessed
    mov bl, al                    ;Use bl to compare the guess to the index character in alphaLeft
    sub al, 41h                    ;Subtract 41h from the guess's ASCII code to convert the code to an index on alphaLeft        
    cmp    bl, alphaLeft[eax]

    je Unguessed                ;If they're the same (ZF set), the letter has not been previously guessed.
	mov dl, statusMessageX		;Move to the status message coordinates
	mov dh, statusMessageY
	inc dh
	call Gotoxy
    mov edx, OFFSET messageAlreadyGuessed    ;otherwise the letter has been previously guessed
    call WriteString            ;So tell them
    jmp finish                    ;and exit -- If we combine GetGuess with CheckGuess, we can instead jump back and ask for another guess
Unguessed:    
    mov alphaLeft[eax], 0        ;Zero the guesses letter in alphaLeft
    xor ebx, ebx                ;clear ebx
    mov ecx, targetWordLength    ;load our loop counter
    xor esi, esi                ;zero our index
    add al, 41h                    ;restore our index to its ASCII char equivalent
    ;Next we need to see if the target word contains any instances of the guess
WalkTargetWord:
    cmp targetWord[esi], al        ;compare the letter in targetWord with the guess in al
    sete dl                        ;If there's a match, set dl to 1, otherwise dl is 0
    mov bl, displayWord[esi]    ;load bl with the character in displayWord
    cmove ebx, eax                ;if the guess is correct, replace the default value in bl
    mov displayWord[esi], bl    ;load either the correct guess or the default character back into displayWord
    xor ebx, ebx                ;clear ebx
    add di, dx                    ;Add the success bit to our running total
    xor edx, edx                ;clear our success marker
    inc esi
loop WalkTargetWord
    cmp edi, 1                    ;Check to see if we found any matches
    setb bl                        ;If no matches, set bl
    setl bl
    add failState, ebx            ;Add 1 to failState if we found no matches
    add successState, edi        ;Add any successes to the success state
    ;call WriteChar
finish:
    ret
CheckGuess endp

;Note that we use branching logic here.
;Should work to fix this
CheckState proc uses eax ebx edx
	call ClearStatusMessage
	
	mov dl, statusMessageX			;Go to the status message coordinates
	mov dh, statusMessageY
	call Gotoxy
    mov eax, failState            	;load the failure count into eax
    cmp eax, maxFailure            	;and compare it with the maximum failure count
    jl NoFail          				;If we're below the max, check if we have succeeded
    mov edx, OFFSET messageFail   	;Otherwise prep the failure message
									;Guesser has failed so we need to increment the executioner's score
	mov bl, player1Score			;load player1's score
	add bl, p2GuesserBool			;if player1 is executioner, then p2 is the guesser and the bool = 1, so p1 gets a point added
	mov player1Score, bl			;store p1 score	
	mov bl, player2Score			;load p2 score
	add bl, p1GuesserBool			;if p2 is executioner, then p1 is the guesser and the bool = 1, so p2 adds a point
	mov player2Score, bl
    jmp Output                    	;And skip to the output step
NoFail:
    mov eax, successState        		;Load the current number of successfully guessed letters
    cmp eax, targetWordLength    		;and compare it with the total number of letters in the word
    jl Fini                        		;If the correct letters are fewer than the total letters, we ain't done yet. Skip to the end
    mov edx, OFFSET messageSuccess      ;Otherwise, the guesser has won so load the success message
    mov bl, player1Score				;Guesser has succeeded and needs a point
	add bl, p1GuesserBool				;If player 1 was the guesser, the bool will be one, otherwise it will be zero
	mov player1Score, bl				
	mov bl, player2Score
	add bl, p2GuesserBool
	mov player2Score, bl
    ;jmp Output                    		;Don't currently need to jump to Output, but if this order changes we may
Output:
    call WriteString            		;Output fail or success message
    call Crlf
Fini: 
    ret
CheckState endp

roleAssignment proc uses eax ebx ecx edx
	xor ecx, ecx
	mov al, player1Score 						;add together players scores to determine round
	add al, player2Score
	mov dl, P1TagCoordX
	mov dh, P1TagCoordY
	Call Gotoxy
	
	;mov ebx, OFFSET executionerTag				;load executioner tag address into ebx
	;cmovne edx, ebx								;if zero flag is clear then the round is even (Our round count is score+1)
	mov edx, OFFSET executionerTag				;default to Executioner
	;so Player 1 is the executioner
	mov ebx, OFFSET P1GuesserTag				;load the guesser tag into ebx
	test al, 1			 						;Bitwise and with the score and 1. Will set the zero flag if the score is even
												;Will clear the zero flag if the score is odd
	cmove edx, ebx								;if the zero flag is set then the round is odd so p1 is the guesser
	call WriteString							
	mov p1GuesserBool, 0						;clear the flag for player1 being the guesser
	test al, 1									;rerun test
	sete p1GuesserBool							;if the round is odd, we want to set the flag for p1 being the guesser
	
	mov dl, P2TagCoordX
	mov dh, P2TagCoordY
	Call Gotoxy
	
	;mov ebx, OFFSET P2GuesserTag
	;cmove edx, ebx
	mov edx, OFFSET executionerTag				;Default to Executioner
	mov ebx, OFFSET P2GuesserTag				;load guesser tag into ebx
	test al, 1
	cmovne edx, ebx
	call WriteString
	mov p2GuesserBool, 0
	test al, 1
	setne p2GuesserBool
	
    ret
roleAssignment endp

;PlayOneWord asks the guesser to input letters and provides feedback on the guess
;Terminates when the user has missed six letters or has completed the word
;TODO: provide a "Guess Word" option that awards extra points based on the number of missing letters
PlayOneWord proc
	;Reset game states
	mov failState, 0
	mov successState, 0
GuessLoop:
	call ClearStatusMessage
	call GetGuess
	call WriteChar
	call CheckGuess
	call DrawHangman
	call OutputGuesses
	call OutputDisplayWord
	call ClearStatusMessage

	mov dl, statusMessageX			;Go to the status message coordinates
	mov dh, statusMessageY
	call Gotoxy
	mov eax, failState            	;load the failure count into eax
	cmp eax, maxFailure            	;and compare it with the maximum failure count
	jl NoFail          				;If we're below the max, check if we have succeeded
	mov edx, OFFSET messageFail   	;Otherwise prep the failure message
									;Guesser has failed so we need to increment the executioner's score
	mov bl, player1Score			;load player1's score
	add bl, p2GuesserBool			;if player1 is executioner, then p2 is the guesser and the bool = 1, so p1 gets a point added
	mov player1Score, bl			;store p1 score	
	mov bl, player2Score			;load p2 score
	add bl, p1GuesserBool			;if p2 is executioner, then p1 is the guesser and the bool = 1, so p2 adds a point
	mov player2Score, bl
	jmp Output                    	;And skip to the output step
NoFail:
	mov eax, successState        		;Load the current number of successfully guessed letters
	cmp eax, targetWordLength    		;and compare it with the total number of letters in the word
	jl GuessLoop                        ;If the correct letters are fewer than the total letters, we ain't done yet. Skip to the end
	mov edx, OFFSET messageSuccess      ;Otherwise, the guesser has won so load the success message
	mov bl, player1Score				;Guesser has succeeded and needs a point
	add bl, p1GuesserBool				;If player 1 was the guesser, the bool will be one, otherwise it will be zero
	mov player1Score, bl				
	mov bl, player2Score
	add bl, p2GuesserBool
	mov player2Score, bl
	;jmp Output                    		;Don't currently need to jump to Output, but if this order changes we may
Output:
	call WriteString            		;Output fail or success message
	call Crlf
	ret
PlayOneWord endp

PlayHangman proc uses eax ebx ecx edx esi
	;Set up the game
    call GetNames
    call GetWordMaxLength
	call GetWinningScore
	call Clrscr
	;Play rounds
RoundStart:
	call roleAssignment			
	call DisplayUI
	call GetTargetWord
	call ClearStatusMessage
	call PlayOneWord
	call DisplayScore
	mov dl, statusMessageX	
	mov dh, statusMessageY
	inc dh
	call Gotoxy						;Go to the aux message coords
	mov edx, OFFSET promptNextRound	;Prompt them to press a key
	call WriteString
	call ReadChar					;Pause until they press a key so they can see the round results
	call ClearAuxMessage			;Get rid of the prompt
	xor ecx, ecx					;Clear registers via nop xor
	xor ebx, ebx
	
	mov cl, player1Score			;Note that we only USE CL for this storage, but we'll use CMOVCC later which requires CX as an operand 
	mov bl, player2Score			; Stash player2Score in BL. We'll need it later so we might as well do reg/reg comparisons instead of reg/mem
	cmp cl, bl						
	cmovb cx, bx					;Put the higher of the two scores into cx
	cmp cl, winningScore			;compare the high score with winning score
	jl RoundStart					;If the high score is less than the winning score, play another round
									;Otherwise, declare a winner and output the results
	
	xor eax, eax					;Clear registers via nop xor
	call ClearStatusMessage 		;Clear the status message
	mov dl, statusMessageX			;Go to the status message coordinates
	mov dh, statusMessageY	
	call Gotoxy
	mov ebx, OFFSET player1Name 	;Load p1's name into our alternate register
	mov edx, OFFSET player2Name		;Load p2's name by default
	;If we've gotten to this point, we should have have the winning score in CL
	cmp cl, player1Score			;If these are equal, p1 won
	cmove edx, ebx					;So move the address of their name into the display register. Otherwise it retains the address of p2's name
	call WriteString				;Print victorious player's name
	mov edx, OFFSET messageVictory0	;Print " defeats "
	call WriteString
	mov edx, OFFSET player2Name		;Our prior comparison should still hold, so reload edx with the address of p2's name
	cmp cl, player1Score			;repeat comparison
	cmovne edx, ebx					;This time replace p2 with p1 if p1 did NOT win
	call WriteString				;Print the losing player's name
	mov edx, OFFSET messageVictory1 ;Print " by a final score of "
	call WriteString
	mov al, cl
	call WriteDec					;CL should still have the high score in it, so copy it to AL and print it.
	mov edx, OFFSET messageVictory2	;Print " to "
	call WriteString	
	mov al, player1Score			;default to p1's score
	xor ebx, ebx					;zero ebx with a nop xor
	mov bl, player2Score			;p2 score is our potential replacement for al
	cmp cl, al						;Repeat comparison of high score (cl) to p1 score (al)
	cmove ax, bx					;If p1 won, then replace their score with the losing score
	call WriteDec					;Output losing score
	
    ret
PlayHangman endp

TestGetNames proc
    call GetNames
    mov edx, OFFSET playerNameSugar
    call WriteString
    mov edx, OFFSET player1Name
    call WriteString
    call Crlf
    mov edx, OFFSET playerNameSugar
    call WriteString
    mov edx, OFFSET player2Name
    call WriteString
    call Crlf
    ret
TestGetNames endp

TestGetWordMaxLength proc
    call GetWordMaxLength
    mov edx, OFFSET wordMaxLengthSugar
    call WriteString
    mov eax, wordMaxLength
    call WriteDec
    call Crlf
    ret
TestGetWordMaxLength endp

TestGetWinningScore proc
    call GetWinningScore
    mov edx, OFFSET winningScoreSugar
    call WriteString
    mov al, winningScore
    call WriteDec
    call Crlf
    ret
TestGetWinningScore endp

TestGetTargetWord proc
    call GetTargetWord
    mov edx, OFFSET targetWordSugar
    call WriteString
    mov edx, OFFSET targetWord
    call WriteString
    call Crlf
    ret
TestGetTargetWord endp

TestGetGuess proc
    call GetGuess
    xor eax, eax
    mov al, currentGuess
    call WriteChar
    call Crlf
    call CheckGuess
    ret
TestGetGuess endp

TestGuesses proc
    call GetTargetWord                ;Get a target word
    mov ecx, 10                        ;give us ten guesses
TestGuessLoop:
    call GetGuess                    ;Get a guess
    call CheckGuess                    ;Check it
    call OutputGuesses                ;Output the current list of guesses
    call Crlf
loop TestGuessLoop
    ret
TestGuesses endp

TestIo PROC
    call TestGetNames
    call TestGetWordMaxLength
    call TestGetWinningScore
    call TestGetTargetWord
    call TestGetGuess
    ret
TestIo ENDP

TestHangedMan proc
    mov startx, 10
    mov starty, 10
	;mov failState, 0
    call DrawHangman
    ret
TestHangedMan endp

main proc
    call PlayHangman
	;Go to the bottom of the screen
	mov dh, 24
	mov dl, 0
	call Gotoxy
    invoke ExitProcess,0
main endp
end main