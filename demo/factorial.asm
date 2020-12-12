label 0
push 6
call 1
onum
exit
label 1
push 1
swap
call 4
dup
dup
dup
push 2
sub
jn 3
pop
push -9
swap
push 1
sub
store
label 2
mul
push -9
dup
load
push 1
sub
dup
jz 3
store
jump 2
label 3
pop
pop
ret
label 4
copy 1
push 1
add
swap
copy 1
copy 1
sub
jn 4
pop
ret
