TITLE Hangman    (hangman.asm)
; Description:    A two-player ASCII art hangman game
; Authors: The Fighting Rutabagas featuring
;        Tersa Motbaynor Almaw
;        Andrew McNeill
;        Jude Battista

INCLUDE Irvine32.inc    

.data

;Test data
currentRoundmessage BYTE "Current Round:",0
guessSugar BYTE "The current guess is: ",0
playerNameSugar BYTE "The player's name is: ",0
targetWordSugar BYTE "The target word is: ",0
winningScoreSugar BYTE "The winning score is: ",0
wordMaxLengthSugar BYTE "The max word length is: ",0

;Production data
defaultMaxAnswerLength DWORD 16
currentRound DWORD 1

promptNamePlayer1 BYTE "Player 1 you will start as the executioner, please enter your name: ",0
promptNamePlayer2 BYTE "Player 2 you will start as the guesser, please enter your name: ",0
player1Name BYTE 16 DUP(0)
player2Name BYTE 16 DUP(0)
nameMaxLength DWORD 16

player1guesser BYTE "Guesser!",0
player2guesser BYTE "Guesser!",0

promptWordMaxLength BYTE "Input the maximum length of the words you wish to play with today: ",0
wordMaxLength DWORD 16

promptWinningScore BYTE "Input the score you would like to play to: ",0
winningScore DWORD 0

promptTargetWord BYTE "Executioner, input the target word: ",0
targetWord BYTE 100 DUP(0)
displayWord BYTE 100 DUP(0)
targetWordLength DWORD 0


promptGuess BYTE "Guesser, input the letter you would like to guess: ",0
currentGuess BYTE 0
messageAlreadyGuessed BYTE "That letter was already guessed.",0

failState DWORD 0
successState DWORD 0
maxFailure DWORD 6
messageFail BYTE "With a horrible snap, your virtual avatar's neck gives way to gravity's ceaseless urging.",0
messageSuccess BYTE "They laughed at you, but you always knew those neck curls would prove useful. The rope gives way before your neck does and you live to play again.",0

player1Score DWORD 0
player2Score DWORD 0

alphabet BYTE "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
alphaLeft BYTE "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0

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
; 
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

; creates void space for the "press any key to continue" 
    mov dh, starty
    add dh, 20
    mov dl, startx
    add dl, 20

    call Gotoxy
    mov al, 20h
    call WriteChar
    call crlf 

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
CallAndResponseInt proc USES eax ecx edx,
    promptAddress:DWORD,
    answerAddress:DWORD

    mov edx, promptAddress
    call WriteString
    call ReadInt
    mov ecx, answerAddress
    mov [ecx], eax
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
    call Clrscr
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
    ret
GetTargetWord endp

;Gets a letter from the guesser and store it in currentGuess
GetGuess proc
    ;First we need to get the guess from the user
    mov edx, OFFSET promptGuess
    call WriteString
    call ReadChar            ;store the guess in al
    and al, 0DFh            ;render the letter uppercase
    mov currentGuess, al    ;store the uppercase letter in currentGuess
    ret
GetGuess endp


CheckGuess proc USES eax ebx ecx edx edi esi
    xor eax, eax                ;clear eax
    xor edx, edx                ;clear edx
    xor edi, edi                ;clear edi, will be our running total of characters in the target word matched by guess
    mov al, currentGuess
    ;First we need to see if the letter has already been guessed
    mov bl, al                    ;Use bl to compare the guess to the index character in alphaLeft
    sub al, 41h                    ;Subtract 41h from the guess's ASCII code to convert the code to an index on alphaLeft        
    cmp    bl, alphaLeft[eax]

    je Unguessed                ;If they're the same (ZF set), the letter has not been previously guessed.
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

OutputGuesses proc USES eax ebx ecx esi
    mov ecx, 26                ;Need to check 26 letters
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

OutputDisplayWord proc uses eax ecx esi
    mov ecx, targetWordLength    ;load our loop counter
    xor esi, esi                ;clear our index
WalkDisplayWord:                ;walk the display word and output each character
    mov al, displayWord[esi]
    call WriteChar
    inc esi
loop WalkDisplayWord
    ret
OutputDisplayWord endp

;Note that we use branching logic here.
;Since all of the values are set before the proc is called
;we should avoid any branch prediction issues
CheckState proc uses eax edx
    mov eax, failState            ;load the failure count into eax
    cmp eax, maxFailure            ;and compare it with the maximum failure count
    jle NoFail                    ;If we're below the max, check if we have succeeded
    mov edx, OFFSET messageFail        ;Otherwise prep the failure message
    inc player1Score
    jmp Output                    ;And skip to the output step
NoFail:
    mov eax, successState        ;Load the current number of successfully guessed letters
    cmp eax, targetWordLength    ;and compare it with the total number of letters in the word
    jl Fini                        ;If the correct letters are fewer than the total letters, we ain't done yet. Skip to the end
    mov edx, OFFSET messageSuccess        ;Otherwise, the guesser has won so load the success message
    inc player2Score
    ;jmp Output                    ;Don't currently need to jump to Output, but if this order changes we may
Output:
    call WriteString            ;Output fail or success message
    call Crlf
Fini: ;

    ret
CheckState endp

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
    mov eax, winningScore
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
    ;call TestGetNames
    call TestGetWordMaxLength
    call TestGetWinningScore
    call TestGetTargetWord
    call TestGetGuess
    ret
TestIo ENDP


TestGameLogic proc
    call TestGuesses
    ret
TestGameLogic endp    

TestGame proc
    call GetNames
    call GetTargetWord
    call Clrscr
    mov ecx, 100
GameLoop:
    call GetGuess
    call WriteChar
    call Crlf
    call CheckGuess
    call Crlf
    call TestDisplayUI


    mov eax, failState
    call WriteInt
    call Crlf
    mov eax, successState
    call WriteInt

    call Crlf
    call CheckState
    call DisplayScore
    call roleAssignment
loop GameLoop
    ret
TestGame endp


TestDisplayUI proc
    call Clrscr

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
    call Gotoxy
    mov failstate, 5
    call DrawHangman
; box around guessed letters
    mov dh, 16
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
    
; Display correct guesses
    mov dh, 10
    mov dl, 60
    Call Gotoxy
    Call OutputDisplayWord

    mov dh, 0
    mov dl, 0
    Call Gotoxy
    mov edx, OFFSET currentRoundmessage
    call WriteString

    mov dh, 0
    mov dl, 14
    Call Gotoxy
    mov eax, currentRound
    call WriteInt

TestDisplayUI endp

DisplayScore proc
    mov dh, 1
    mov dl, 53
    call Gotoxy
    mov eax, player1Score
    call WriteInt

    mov dh, 1
    mov dl, 56
    call Gotoxy
    mov eax, player2Score
    call WriteInt

    mov dh, 20
    mov dl, 0
    call Gotoxy
    ret
DisplayScore endp

TestHangedMan proc
    mov startx, 10
    mov starty, 10
 ;mov failState, 0
    call DrawHangman
    ret
TestHangedMan endp

checkRoles proc
    mov ECX, 100
    RolesCheck:
    ;
    ; here we check to see if the round is even or not, 
    ; player 1 start the game as executioner, player 2 as guesser
    ; so every even round, player 1 will be the guesser
    ; im not sure how to make it switch with each new round
    ;
    loop RolesCheck
    ret
checkRoles endp



roleAssignment proc
;
; i think there should probably be some kind of jump right here
; we can use the current round as an indicator for when to jump
; if the round is even then player 1 is the guesser, so the player1guesser message should pop up
;
; prints next to player 1s name when they are the guesser    
    mov dh, 1
    mov dl, 26
    call Gotoxy
    mov edx, OFFSET player1guesser
    call WriteString

; heres to clear out the player 2's guesser mark    
    mov ECX, 4
    mov dl, 76
    mov dh, 1
    mov al, 20h ; space
L1:
    call WriteChar
LOOP L1


; prints next to player 2s name when they are the guesser    
    mov dh, 1
    mov dl, 76
    call Gotoxy
    mov edx, OFFSET player2guesser
    Call WriteString

; heres to clear out player 1s guesser mark    
    mov ECX, 4
    mov dl, 26
    mov dh, 1
    mov al, 20h ; space
L2:
    call WriteChar
LOOP L2

; move gotoxy back to the end
    mov dh, 20
    mov dl, 0
    call Gotoxy

    ret
roleAssignment endp

main proc
    ;call DisplayScore
    ;call Getnames
    ;call TestNameBoxes
    ;call TestDisplayUI
    ;call TestIo
    ;call TestGameLogic
    call TestGame
    ;call TestHangedMan
    invoke ExitProcess,0
main endp
end main