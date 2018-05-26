%define link 0
%macro update_link 0
%%link: dq link
%define link %%link
%endmacro


%macro native 3
section .data
w_%+ %2:
	update_link
	db %1, 0
	db %3
xt_%+ %2:
	dq i_%+ %2 

section .code
	i_%+ %2:
%endmacro


%macro native 2
	native %1, %2, 0
%endmacro



%macro colon 3
section .data
w_%+ %2:
	update_link
	db %1, 0
	db %3
xt_%+ %2:
	dq docol

%endmacro

%macro colon 2
	colon %1, %2, 0
%endmacro





%define w r15
%define pc r14
%define rstack r13 
