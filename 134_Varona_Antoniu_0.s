.data
numar_cerinta: .space 4
m1: .space 40000
m2: .space 40000
mres: .space 40000
cI: .space 4
lI: .space 4
n: .space 4
v: .space 400
index: .space 4
vf: .space 4
vf1: .space 4
vf2: .space 4
k: .space 4
formatScanf: .asciz "%ld"
formatPrintf: .asciz "%ld "
format2Printf: .asciz "%ld\n"
nL: .asciz "\n"
.text
.global main
matrix_mult:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	pushl %edi
	subl $20, %esp
	movl 8(%ebp), %ecx
	movl 12(%ebp), %ebx
	movl 16(%ebp), %edi
	movl $0, -12(%ebp)
	movl $0, -28(%ebp)
	mult:
	mov -12(%ebp), %eax
	mov 20(%ebp), %edx
	cmpl %edx, %eax
	jge final

	movl $0, -16(%ebp)
	for:
	movl -16(%ebp), %eax
	movl 20(%ebp), %edx
	cmpl %edx, %eax
	jge back1

	movl $0, -20(%ebp)
	calc:
	movl -20(%ebp), %eax
	movl 20(%ebp), %edx
	cmpl %edx, %eax
	jge back

	xorl %edx, %edx
	movl -12(%ebp), %eax
	mull 20(%ebp)
	addl -20(%ebp), %eax
	mov %eax, -24(%ebp)

	xorl %edx, %edx
	movl -20(%ebp), %eax
	mull 20(%ebp)
	addl -16(%ebp), %eax

	movl (%ebx, %eax, 4), %eax
	movl -24(%ebp), %edx
	movl (%ecx, %edx, 4), %edx

	mull %edx
	addl %eax, -28(%ebp)
	movl -20(%ebp), %edx
	incl %edx
	movl %edx, -20(%ebp)
	jmp calc

	back:
	movl -12(%ebp), %eax
	mull 20(%ebp)
	addl -16(%ebp), %eax

	movl -28(%ebp), %edx
	movl %edx, (%edi, %eax, 4)
	movl $0, -28(%ebp)

	movl -16(%ebp), %edx
	incl %edx
	movl %edx, -16(%ebp)
	jmp for

	back1:
	movl -12(%ebp), %edx
	incl %edx
	movl %edx, -12(%ebp)
	jmp mult

	final:
	addl $20, %esp
	popl %edi
	popl %ebx
	popl %ebp
	ret

main:

pushl $numar_cerinta
pushl $formatScanf
call scanf
popl %ebx
popl %ebx

pushl $n
pushl $formatScanf
call scanf
popl %ebx
popl %ebx

xorl %ecx, %ecx
for_citire:

cmpl n, %ecx
jge exit_for_citire
pushl %ecx
xorl %edx, %edx
lea v, %esi 
movl %ecx, %eax
movl $4, %ecx
mull %ecx
addl %esi, %eax



pushl %eax
pushl $formatScanf
call scanf
popl %ebx
popl %ebx

popl %ecx
incl %ecx
jmp for_citire

exit_for_citire:

xorl %ecx, %ecx

printare:
cmpl n, %ecx
jge selectare_cerinta

lea v, %esi
movl (%esi, %ecx, 4), %ebx
movl %ebx, index
xor %ebx, %ebx
for2:
cmpl index, %ebx
jge exit_for2

pushl %ebx
pushl %ecx
pushl $vf
pushl $formatScanf
call scanf
popl %ebx
popl %ebx
popl %ecx
popl %ebx

movl %ecx, %eax
movl $0, %edx
mull n
addl vf, %eax
lea m1, %edi
movl $1, (%edi, %eax, 4)
lea m2, %edi
movl $1, (%edi, %eax, 4)
incl %ebx
jmp for2

exit_for2:

incl %ecx
jmp printare

selectare_cerinta:
cmp $1, numar_cerinta
je cerinta2
cmp $2, numar_cerinta
je continuare1

continuare1:

pushl $k
pushl $formatScanf
call scanf
popl %ebx
popl %ebx

movl $1, %ecx

inmultire:

pushl %ecx
pushl n
pushl $mres
pushl $m2
pushl $m1
call matrix_mult
popl %ebx
popl %ebx
popl mres
popl %ebx
popl %ecx
incl %ecx

cmpl k, %ecx
je cerinta3

pushl %ecx
xorl %ecx, %ecx
movl n, %eax
xorl %edx, %edx
mull n
l1:
cmpl %eax, %ecx
jge inmultire_iesire
lea m2, %esi
lea mres, %edi
movl (%edi, %ecx, 4), %ebx
movl %ebx, (%esi, %ecx, 4)
movl $0, (%edi, %ecx, 4)
incl %ecx
jmp l1
inmultire_iesire:
popl %ecx
jmp inmultire

cerinta3:

pushl $vf1
pushl $formatScanf
call scanf
popl %ebx
popl %ebx

pushl $vf2
pushl $formatScanf
call scanf
popl %ebx
popl %ebx

lea mres, %edi
movl vf1, %eax
xorl %edx, %edx
mull n
addl vf2, %eax
movl (%edi, %eax, 4), %ebx

pushl %ebx
pushl $format2Printf
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

jmp exit

cerinta2:
movl $0, lI
for_lines1:
movl lI, %ecx
cmp %ecx, n
je exit
movl $0, cI
for_columns1:
movl cI, %ecx
cmp %ecx, n
je cont1
movl lI, %eax
movl $0, %edx
mull n
addl cI, %eax
lea m1, %edi
movl (%edi, %eax, 4), %ebx
pushl %ebx
pushl $formatPrintf
call printf
popl %ebx
popl %ebx
pushl $0
call fflush
popl %ebx
incl cI
jmp for_columns1
cont1:
pushl $nL
call printf
popl %ebx

#movl $4, %eax
#movl $1, %ebx
#movl $, %ecx
#movl $2, %edx
#int $0x80
incl lI
jmp for_lines1


exit:
mov $1, %eax
xorl %ebx, %ebx
int $0x80
