*-----------------------------------------------------------
* Title      : 	Simple formula solver
* Written by : 	William Hazell
* Date       : 	November 19, 2015
* Description: 	This program solves a simple equation:
*	       	=> 5x^2 + 2xy - z^2
*		Based on the three constants defined at the bottom of the file
*
*		This program demonstrates use of a transparent stack
*		to call functions, to ensure the program is reverted 
*		to the same state it had prior to the function call.
*		
*		The result of the equation is placed into the defined 
*		storage space W, defined at the bottom of the file.
*		
*
*		This program was assembled using the Easy68k simulator
*-----------------------------------------------------------
    ORG    $8000
START:  LEA $9100,SP
        MOVE.W X,-(SP) ;Push values onto the stack 
        MOVE.W Y,-(SP)
        MOVE.W Z,-(SP)
        PEA W 	;Push address of final value onto stack 
        JSR SQRT ;Jump to sub routine 
        LEA 10(SP),SP ;Revert the stack pointer to state before function call
        TRAP #14 
        
SQRT LINK A0,#-6 ; Need space for 3 word values (5x^2, 2xy, z^2)
     MOVEM.L D0-D1/A0/A6,-(SP) ;Save register state
     
     MOVE.W 16(A0),D0 ; Get the value of x off the stack
     MOVE.W D0,D1 ; save x for later
     MULS   D0,D0 ; square x and multiply by 5
     MULS   #5,D0
     MOVE.W D0,-2(A0) ; Put 5 * x * x into reserved space 
     CLR D0 ;Minimize the registers used so clear value out 
     
     MOVE.W 14(A0),D0 ;Grab the value of y off the stack
     MULS   D0,D1 ; x * y 
     MULS   #2,D1 ; 2*x*y
     MOVE.W D1,-4(A0) ; Put the result into the reserved space on stack frame
     CLR D0
     
     MOVE.W 12(A0),D0 ;Get value of z off the stack 
     MULS   D0,D0 
     MOVE.W D0,-6(A0) ;Add result back onto stack 
     
     ADD.W -2(A0),D1 ;5x^2 + 2xy (D1)
     SUB.W D0,D1 ;result - z*z
     
     MOVE.L 8(A0),A6 ;Get the address to place result into 
     MOVE.W D1,(A6) ; Move the result into this address
     MOVEM.L (SP)+,D0-D1/A0/A6 ;Revert the registers to their prior value
     
     UNLK A0 ;Remove stack frame and return from the function call
     RTS
     
    
    ORG $9000
X   DC.W 2
Y   DC.W 3
Z   DC.W 1
W   DS.W 1

    END    START        ; last line of source
