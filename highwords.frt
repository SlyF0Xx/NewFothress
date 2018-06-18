: IMMEDIATE  last_word @ cfa 1 - dup c@ 1 or swap c! ;
: repeat here ; IMMEDIATE
: until here -
		8 /
		2 -
		' branch0 , , ; IMMEDIATE

: if 
	' branch0 ,
	2 ,
	' branch ,
	here 0  ,
	; IMMEDIATE

: else
	' branch ,
	here 0  ,
	here rot
	dup rot swap - 8 / 1 - 
	swap !
	; IMMEDIATE

: end_if
	here
	swap dup rot swap - 8 / 1 -
	swap !
	; IMMEDIATE

: for
	here
	' swap ,
	' dup ,
	' rot ,
	' dup ,
	' rot ,

	' < ,
	' branch0 ,
	here 0 ,
	; IMMEDIATE

: endfor
	' num ,
	1 ,
	' + ,
	' branch ,
	here rot swap - 8 / 1 - ,
	dup
	here swap  - 8 / 1 - swap !
		' drop ,
	' drop ,

	; IMMEDIATE