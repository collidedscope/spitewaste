label 0
push 0
push 46
push 46
push 88
push 88
call 53
push 0
push 46
push 88
push 65
push 88
call 53
push 0
push 46
push 66
push 65
push 88
call 53
push 0
push 46
push 88
push 88
push 66
call 53
push 0
push 46
push 65
push 88
push 66
call 53
push 0
push 46
push 66
push 88
push 66
call 53
push 0
push 46
push 88
push 65
push 66
call 53
push 0
push 46
push 65
push 65
push 66
call 53
push 0
push 46
push 66
push 66
push 88
call 53
push 0
push 46
push 88
push 66
push 88
call 53
push 0
push 46
push 65
push 66
push 88
call 53
push 0
push 88
push 88
push 88
push 65
call 53
push 0
push 65
push 88
push 88
push 65
call 53
push 0
push 66
push 88
push 88
push 65
call 53
push 0
push 88
push 65
push 88
push 65
call 53
push 0
push 65
push 65
push 88
push 65
call 53
push 0
push 46
push 88
push 65
push 65
call 53
push 0
push 46
push 65
push 65
push 65
call 53
push 0
push 46
push 66
push 65
push 66
call 53
push 0
push 88
push 65
push 66
push 65
call 53
push 0
push 65
push 65
push 66
push 65
call 53
push 0
push 88
push 88
push 66
push 65
call 53
push 0
push 65
push 88
push 66
push 65
call 53
push 0
push 46
push 66
push 66
push 66
call 53
push 24
dup
dup
push 2
sub
jn 2
pop
push -9
swap
push 1
sub
store
label 1
call 60
push -9
dup
load
push 1
sub
dup
jz 2
store
jump 1
label 2
pop
pop
push 0
label 3
push -1
dup
ichr
load
jn 4
push -1
load
push 124
sub
jz 4
push 128
mul
push -1
load
push 56
add
add
jump 3
label 4
call 61
push -100
dup
store
push 0
label 5
copy 1
jz 10
copy 1
push 128
mod
call 60
swap
push 128
div
swap
call 6
jump 5
label 6
copy 2
copy 1
push 4
push 46
call 74
call 65
dup
push 4
mod
jz 7
pop
ret
label 7
slide 1
push 4
div
push -100
dup
call 87
load
copy 1
store
push 8
sub
jn 8
push 0
jump 9
label 8
push 128
copy 1
push 66
call 65
push 1
add
call 90
call 98
push 128
call 98
swap
push 0
push 66
push 65
push 88
call 53
push 0
push 95
push 49
push 48
call 53
call 75
call 85
swap
push 88
sub
jz 9
push -1
mul
label 9
push -100
dup
call 87
load
swap
store
push 0
ret
label 10
push -100
push 1
add
slide 3
dup
push -100
load
store
label 11
push 2
sub
dup
push -100
push 1
add
load
sub
jn 13
dup
load
push 3
sub
jz 12
jump 11
label 12
push -100
dup
call 87
load
copy 1
store
jump 11
label 13
push -100
push 2
add
slide 1
push -100
load
store
push -100
dup
store
label 14
push -100
dup
call 87
load
load
push -100
call 87
dup
jz 15
dup
push 1
sub
jz 19
dup
push 2
sub
jz 20
dup
push 3
sub
jz 21
dup
push 4
sub
jz 22
dup
push 5
sub
jz 26
dup
push 6
sub
jz 24
dup
push 7
sub
jz 25
dup
push 8
sub
jz 16
dup
push 9
sub
jz 17
dup
push 10
sub
jz 18
dup
push 11
sub
jz 28
dup
push 12
sub
jz 29
dup
push 13
sub
jz 30
dup
push 14
sub
jz 31
dup
push 15
sub
jz 32
dup
push 16
sub
jz 33
dup
push 17
sub
jz 34
dup
push 18
sub
jz 23
dup
push 19
sub
jz 35
dup
push 20
sub
jz 36
dup
push 21
sub
jz 37
dup
push 22
sub
jz 38
dup
push 23
sub
jz 39
pop
exit
label 15
pop
push -100
load
load
jump 14
label 16
pop
pop
jump 14
label 17
pop
dup
jump 14
label 18
pop
swap
jump 14
label 19
pop
push -100
load
load
call 48
jump 14
label 20
pop
push -100
load
load
call 47
jump 14
label 21
pop
jump 14
label 22
pop
push -100
push 2
add
dup
call 87
load
push -100
load
store
jump 27
label 23
pop
push -100
push -100
push 2
add
load
load
store
push -100
push 2
add
call 86
jump 14
label 24
pop
jz 27
jump 14
label 25
pop
jn 27
jump 14
label 26
pop
label 27
push -100
dup
load
load
push 1
add
push -100
push 1
add
load
sub
push 0
swap
sub
load
push 1
sub
store
jump 14
label 28
pop
add
jump 14
label 29
pop
sub
jump 14
label 30
pop
mul
jump 14
label 31
pop
div
jump 14
label 32
pop
mod
jump 14
label 33
pop
store
jump 14
label 34
pop
load
jump 14
label 35
pop
ichr
jump 14
label 36
pop
inum
jump 14
label 37
pop
ochr
jump 14
label 38
pop
onum
jump 14
label 39
pop
exit
label 40
push -10
dup
store
label 41
dup
jz 42
push -10
call 87
swap
push -10
load
swap
store
push 1
sub
jump 41
label 42
push 10
sub
load
swap
push -10
swap
store
label 43
dup
load
swap
push 1
add
dup
push 10
add
jz 44
jump 43
label 44
load
ret
label 45
dup
jz 46
swap
pop
push 1
sub
jump 45
label 46
pop
ret
label 47
swap
push -1
swap
store
call 45
push -1
load
ret
label 48
push -10
dup
store
label 49
dup
jz 50
swap
push -10
dup
call 87
load
swap
store
push 1
sub
jump 49
label 50
push 10
sub
dup
load
swap
copy 2
store
label 51
dup
push 9
add
jz 52
dup
load
swap
push 1
add
jump 51
label 52
pop
ret
label 53
push 0
label 54
swap
dup
jz 55
copy 1
push 128
mul
add
slide 1
jump 54
label 55
pop
call 61
ret
label 56
call 61
push 0
swap
label 57
dup
jz 58
dup
push 128
mod
swap
push 128
div
jump 57
label 58
pop
ret
label 59
dup
push 128
call 93
swap
push 128
mod
push 0
call 88
add
ret
label 60
push 128
copy 2
call 59
call 90
mul
add
ret
label 61
push 0
swap
label 62
dup
jz 63
swap
push 128
mul
copy 1
push 128
mod
add
swap
push 128
div
jump 62
label 63
pop
ret
label 64
swap
push 128
swap
call 90
copy 2
swap
div
swap
push 128
swap
call 90
mod
slide 1
ret
label 65
swap
push 0
label 66
copy 1
copy 3
call 59
push 0
swap
call 64
copy 3
sub
jz 68
push 1
add
swap
push 128
div
dup
jz 67
swap
jump 66
label 67
push -1
slide 3
ret
label 68
slide 2
ret
label 69
push 1
call 64
ret
label 70
push 0
swap
label 71
dup
jz 72
swap
copy 2
call 60
swap
push 1
sub
jump 71
label 72
swap
slide 2
ret
label 73
swap
copy 2
call 59
sub
push 0
call 96
call 70
ret
label 74
call 73
call 60
ret
label 75
push -3
swap
store
push -2
swap
store
dup
call 59
push -1
swap
store
call 56
push -1
load
push -9
push -1
store
swap
label 76
push -9
call 86
swap
dup
dup
push -9
load
sub
jz 77
call 40
call 78
jump 76
label 77
pop
pop
call 53
ret
label 78
dup
push -2
load
swap
call 65
dup
jn 79
push -3
load
swap
call 69
slide 1
ret
label 79
pop
ret
label 80
push 0
push 122
push 121
push 120
push 119
push 118
push 117
push 116
push 115
push 114
push 113
push 112
push 111
push 110
push 109
push 108
push 107
push 106
push 105
push 104
push 103
push 102
push 101
push 100
push 99
push 98
push 97
push 57
push 56
push 55
push 54
push 53
push 52
push 51
push 50
push 49
push 48
call 53
ret
label 81
swap
push 0
label 82
swap
dup
jz 84
swap
copy 2
copy 2
call 59
push 1
sub
call 90
copy 2
push 128
mod
call 80
swap
call 65
dup
jn 83
mul
add
swap
push 128
div
swap
jump 82
label 83
pop
pop
slide 1
swap
div
ret
label 84
swap
slide 2
ret
label 85
push 2
call 81
ret
label 86
dup
load
push 1
add
store
ret
label 87
dup
load
push 1
sub
store
ret
label 88
sub
jz 89
push 1
ret
label 89
push 0
ret
label 90
push 1
swap
label 91
dup
jz 92
swap
copy 2
mul
swap
push 1
sub
jump 91
label 92
swap
slide 2
ret
label 93
push -1
push 0
store
label 94
swap
copy 1
div
dup
jz 95
push -1
call 86
swap
jump 94
label 95
push -1
load
slide 2
ret
label 96
copy 1
copy 1
sub
jn 97
swap
label 97
slide 1
ret
label 98
push -1
swap
store
dup
push -1
load
div
swap
push -1
load
mod
ret
