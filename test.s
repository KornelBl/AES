SYSEXIT		=1
SYSREAD		=3
SYSWRITE	=4
STDIN		=0
STDOUT		=1
EXIT_SUCCES	=0
n	 	=16 #key length in bytes
.align 32
		
.bss
	.comm key, 176		#176 bajtów dla 128bit klucz sekretnego 

.text
s_box:	.octa 	0x76abd7fe2b670130c56f6bf27b777c63 
	.octa	0xc072a49cafa2d4adf04759fa7dc982ca 
	.octa	0x1531d871f1e5a534ccf73f362693fdb7
	.octa	0x75b227ebe28012079a059618c323c704
	.octa	0x842fe329b3d63b52a05a6e1b1a2c8309
	.octa	0xcf584c4a39becb6a5bb1fc20ed00d153
	.octa	0xa89f3c507f02f94585334d43fbaaefd0
	.octa	0xd2f3ff1021dab6bcf5389d928f40a351
	.octa	0x73195d643d7ea7c41744975fec130ccd
	.octa	0xdb0b5ede14b8ee4688902a22dc4f8160
	.octa	0x79e4959162acd3c25c2406490a3a32e0
	.octa	0x08ae7a65eaf4566ca94ed58d6d37c8e7
	.octa	0x8a8bbd4b1f74dde8c6b4a61c2e2578ba
	.octa	0x9e1dc186b95735610ef6034866b53e70
	.octa	0xdf2855cee9871e9b948ed9691198f8e1
	.octa	0x16bb54b00f2d99416842e6bf0d89a18c

	#zapisane są bajtowo od tyłu, żeby w pamięci były po kolei,bo sie od tyłu układa

rcon:	.octa	0x009a4dabd86c361b8040201008040201


SECRET_KEY:  	.octa 0x637c777bf26b6fc53001672bfed7ab76 #16 bajtów przykladowy klucz prywatny
	 	
#s_box	=	637c777bf26b6fc53001672bfed7ab76 ca82c97dfa5947f0add4a2af9ca472c0 b7fd9326363ff7cc34a5e5f171d83115 
#		04c723c31896059a071280e2eb27b275 09832c1a1b6e5aa0523bd6b329e32f84 53d100ed20fcb15b6acbbe394a4c58cf 
#		d0efaafb434d338545f9027f503c9fa8 51a3408f929d38f5bcb6da2110fff3d2 cd0c13ec5f974417c4a77e3d645d1973 
#		60814fdc222a908846eeb814de5e0bdb e0323a0a4906245cc2d3ac629195e479 e7c8376d8dd54ea96c56f4ea657aae08 
#		ba78252e1ca6b4c6e8dd741f4bbd8b8a 703eb5664803f60e613557b986c11d9e e1f8981169d98e949b1e87e9ce5528df
#		8ca1890dbfe6426841992d0fb054bb16

.global _start
_start:
main:
	mov $key, %r8	# r8 to wskaznik na koniec utworzonego kawałka klucza
	add $n, %r8

#0		poczatek rozszerzonego klucza to oryginalny klucz sekretny
	movq SECRET_KEY, %rax
	movq %rax, key
	movq $8, %r9
	movq SECRET_KEY(%r9), %rax
	movq %rax, key(%r9)

	mov $0, %r9	#r9 to numer iteracji liczymy od 0 nie jak na stronie

generation:
#1 generacja kolejnych 4 bajtow		
#1.1	
	mov -4(%r8), %eax
#1.2	rotacja bajtow w lewo 
	rol $8, %eax		
#1.3	podstawienia rijndaela
	mov $0, %ebx

	movb %al, %bl
	mov s_box(%ebx), %al
	movb %ah, %bl
	mov s_box(%ebx), %ah
	rol $16, %eax

	movb %al, %bl
	mov s_box(%ebx), %al
	movb %ah, %bl
	mov s_box(%ebx), %ah
	rol $16, %eax

#1.4	operacja rcon z najbardziej lewym bajtem
	rol $8, %eax
	xor rcon(%r9), %al
	ror $8, %eax
#1.5
	mov -n(%r8),%ebx
	xor %ebx, %eax
	
	#dodanie utworzonych 4 bajtow do klucza
	mov %eax, (%r8)
	add $4, %r8	
#2	
	mov -4(%r8), %eax
	mov -n(%r8), %ebx
	xor %ebx, %eax
	mov %eax, (%r8)
	add $4, %r8

	mov -4(%r8), %eax
	mov -n(%r8), %ebx
	xor %ebx, %eax
	mov %eax, (%r8)
	add $4, %r8

	mov -4(%r8), %eax
	mov -n(%r8), %ebx
	xor %ebx, %eax
	mov %eax, (%r8)
	add $4, %r8

#5	zwiekszenie numeru iteracji
	
	inc %r9
	#porownanie ilosci iteracji	
	cmp $10 , %r9
	jne generation


	
koniec:
	mov $SYSEXIT, %rax
	mov $EXIT_SUCCES, %rbx
	int $0x80


