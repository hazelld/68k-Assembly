*-----------------------------------------------------------
* Title      :	Matrix Reverse 
* Written by :  William Hazell
* Date       :	Nov. 5 2015
* Description:	This program will reverse a 2-D array of values,
*		stored in row-major order into a column-major
*		order array (see example below). This array of values 
*		is defined as MATRIX at the bottom of the file
*		
*		Row-Major:		Column Major:
*
*		1  2  3  4		1  5  9  13
*               5  6  7  8	=>      2  6  10 14
*               9  10 11 12             3  7  11 15
*               13 14 15 16             4  8  12 16
*
*		Old array spot = 4i + j
*		New array spot = i + 4j
*		
*		This program was assembled on the EASY68k emulator
*
*		Functionality to Add:
*		    ->Size value that is computed based on array size,
*		    as this will allow for the array to be changed, as 
*		    right now changing the size of the array will most
*		    likely break the program.
*-----------------------------------------------------------
    ORG    $8000
START:                  
    MOVE.B #-1,D0 ;i
    LEA MATRIX,A0 ; Push matrix into address register
    
LOOP1   ADD.B #1,D0 ; i++
        CMP #2,D0 ; if i > 2 then exit
        BGT EXIT
        MOVE.B D0,D1 ; j = i
        ADD.B #1,D1 ;j = i + 1

LOOP2   CMP #3,D1 ; j <= 3
        BGT LOOP1 ; Start outerloop again
        
        MOVE.B D0,D2 ; 4*i + j
        MULU #4,D2
        ADD.B D1,D2 ;Offset is now in D2
        
        MOVE.B (A0,D2),D4 ;Temp for matrix(i,j)
        
        MOVE.B D1,D3 ;Compute next offset (4j+i)
        MULU #4,D3
        ADD.B D0,D3 ;Next offset in D4

        MOVE.B (A0,D3),(A0,D2) ;matrix(i,j) = matrix(j,i)
        MOVE.B D4,(A0,D3) ;matrix(j,i) = temp
   
        ADD.B #1,D1 ;Increase loop counter
        BRA LOOP2 ;Always branch to inner loop 
        
EXIT TRAP #14

    ORG $9000
MATRIX  DC.B 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16

    END    START        ; last line of source
