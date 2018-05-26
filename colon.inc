colon "or", or
	dq xt_not
	dq xt_swap
	dq xt_not
	dq xt_and
	dq xt_not
	dq xt_exit

colon ">=", greater_eq
	dq xt_less
	dq xt_not
	dq xt_exit

colon ">", greater
	dq xt_swap
	dq xt_less
	dq xt_exit
