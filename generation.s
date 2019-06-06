n	=16 #key length in bytes


.data

.bss
	.comm key, 176
	.comm secret_key, 8 	#wskaznik na secret_key z c++

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


rcon:	.octa	0x009a4dabd86c361b8040201008040201


.global key_generation, key
.type key_generation, @function  # char* key_generation(char* secret_key)
key_generation:

#poczatki funkcji
	movq %rdi, secret_key
	push %rbp
	mov %rsp, %rbp
	push %rbx
	push %r9
	push %r8
	
	mov $key, %r8	# r8 to wskaznik na koniec utworzonego kawałka klucza


#0		poczatek rozszerzonego klucza to oryginalny klucz sekretny
	mov secret_key, %r9
	movq (%r9), %rax
	movq %rax, key
	add $8, %r8
	movq 8(%r9), %rax
	movq %rax, (%r8)
	add $8, %r8

	
	xor %r9, %r9	#r9 to numer iteracji liczymy od 0 nie jak na stronie

generation:
#1 generacja kolejnych 4 bajtow		
#1.1	
	mov -4(%r8), %eax
#1.2	rotacja bajtow w lewo 
	ror $8, %eax		
#1.3	podstawienia rijndaela
	xor %ebx, %ebx

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
	xor rcon(%r9), %al
#1.5
	mov -n(%r8),%ebx
	xor %ebx, %eax

pierwsza_kolumna:
	#dopisanie utworzonych 4 bajtow do klucza
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



#koniec funkcji
	pop %r8
	pop %r9
	pop %rbx
	mov %rbp, %rsp
	pop %rbp
	
	mov $key, %rax	
	ret
