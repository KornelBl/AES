SYSEXIT		=1
SYSREAD		=3
SYSWRITE	=4
STDIN		=0
STDOUT		=1
EXIT_SUCCES	=0
n	 	=16 #key length in bytes
.align 32

.data
raw_data:
	.int 0x00112233
	.int 0x44556677
	.int 0x8899aabb
	.int 0xccddeeff


		
.bss
	.comm key, 176		#176 bajtów dla 128bit klucz sekretnego 
	.comm coded_data, 16
	.comm input_data, 16

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

mul_by_2:
	.byte 	0x00,0x02,0x04,0x06,0x08,0x0a,0x0c,0x0e,0x10,0x12,0x14,0x16,0x18,0x1a,0x1c,0x1e
	.byte	0x20,0x22,0x24,0x26,0x28,0x2a,0x2c,0x2e,0x30,0x32,0x34,0x36,0x38,0x3a,0x3c,0x3e
	.byte	0x40,0x42,0x44,0x46,0x48,0x4a,0x4c,0x4e,0x50,0x52,0x54,0x56,0x58,0x5a,0x5c,0x5e
	.byte	0x60,0x62,0x64,0x66,0x68,0x6a,0x6c,0x6e,0x70,0x72,0x74,0x76,0x78,0x7a,0x7c,0x7e
	.byte	0x80,0x82,0x84,0x86,0x88,0x8a,0x8c,0x8e,0x90,0x92,0x94,0x96,0x98,0x9a,0x9c,0x9e
	.byte	0xa0,0xa2,0xa4,0xa6,0xa8,0xaa,0xac,0xae,0xb0,0xb2,0xb4,0xb6,0xb8,0xba,0xbc,0xbe
	.byte	0xc0,0xc2,0xc4,0xc6,0xc8,0xca,0xcc,0xce,0xd0,0xd2,0xd4,0xd6,0xd8,0xda,0xdc,0xde
	.byte	0xe0,0xe2,0xe4,0xe6,0xe8,0xea,0xec,0xee,0xf0,0xf2,0xf4,0xf6,0xf8,0xfa,0xfc,0xfe
	.byte	0x1b,0x19,0x1f,0x1d,0x13,0x11,0x17,0x15,0x0b,0x09,0x0f,0x0d,0x03,0x01,0x07,0x05
	.byte	0x3b,0x39,0x3f,0x3d,0x33,0x31,0x37,0x35,0x2b,0x29,0x2f,0x2d,0x23,0x21,0x27,0x25
	.byte	0x5b,0x59,0x5f,0x5d,0x53,0x51,0x57,0x55,0x4b,0x49,0x4f,0x4d,0x43,0x41,0x47,0x45
	.byte	0x7b,0x79,0x7f,0x7d,0x73,0x71,0x77,0x75,0x6b,0x69,0x6f,0x6d,0x63,0x61,0x67,0x65
	.byte	0x9b,0x99,0x9f,0x9d,0x93,0x91,0x97,0x95,0x8b,0x89,0x8f,0x8d,0x83,0x81,0x87,0x85
	.byte	0xbb,0xb9,0xbf,0xbd,0xb3,0xb1,0xb7,0xb5,0xab,0xa9,0xaf,0xad,0xa3,0xa1,0xa7,0xa5
	.byte	0xdb,0xd9,0xdf,0xdd,0xd3,0xd1,0xd7,0xd5,0xcb,0xc9,0xcf,0xcd,0xc3,0xc1,0xc7,0xc5
	.byte	0xfb,0xf9,0xff,0xfd,0xf3,0xf1,0xf7,0xf5,0xeb,0xe9,0xef,0xed,0xe3,0xe1,0xe7,0xe5



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

	xor %r9, %r9	#r9 to numer iteracji liczymy od 0 nie jak na stronie

generation:
#1 generacja kolejnych 4 bajtow		
#1.1	
	mov -4(%r8), %eax
#1.2	rotacja bajtow w lewo 
	rol $8, %eax		
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
#---------------------SZYFROWANIE-------------------
#EAX EBX ECX EDX to dane
poczatek_szyfrowania:
		
	call wczytanie_128b		
#2 	
	mov $input_data, %r8	
	movl (%r8), %eax
	add $4, %r8
	movl (%r8), %ebx
	add $4, %r8
	movl (%r8), %ecx
	add $4, %r8
	movl (%r8), %edx

	mov $key, %r8 #r8 to wskaznik na czesc klucza ktora aktualnie uzywamy
		
	xorl (%r8), %eax
	add $4, %r8
	xorl (%r8), %ebx
	add $4, %r8	
	xorl (%r8), %ecx
	add $4, %r8	
	xorl (%r8), %edx
	add $4, %r8		
	
szyfrowanie:
#3	
#3.1
	xor %r9, %r9

	movb %al, %r9b
	mov s_box(%r9), %al
	ror $8, %eax
	movb %al, %r9b
	mov s_box(%r9), %al
	ror $8, %eax
	movb %al, %r9b
	mov s_box(%r9), %al
	ror $8, %eax
	movb %al, %r9b
	mov s_box(%r9), %al
	ror $8, %eax


	movb %bl, %r9b
	mov s_box(%r9), %bl
	ror $8, %ebx
	movb %bl, %r9b
	mov s_box(%r9), %bl
	ror $8, %ebx
	movb %bl, %r9b
	mov s_box(%r9), %bl
	ror $8, %ebx
	movb %bl, %r9b
	mov s_box(%r9), %bl
	ror $8, %eax


	movb %cl, %r9b
	mov s_box(%r9), %cl
	ror $8, %ecx
	movb %cl, %r9b
	mov s_box(%r9), %cl
	ror $8, %ecx
	movb %cl, %r9b
	mov s_box(%r9), %cl
	ror $8, %ecx
	movb %cl, %r9b
	mov s_box(%r9), %cl
	ror $8, %ecx


	movb %dl, %r9b
	mov s_box(%r9), %dl
	ror $8, %edx
	movb %dl, %r9b
	mov s_box(%r9), %dl
	ror $8, %edx
	movb %dl, %r9b
	mov s_box(%r9), %dl
	ror $8, %edx
	movb %dl, %r9b
	mov s_box(%r9), %dl
	ror $8, %edx
#3.2
	xor %r9, %r9	#3.2

	ror $8, %eax
	ror $8, %ebx
	ror $8, %ecx
	ror $8, %edx
	movw %ax, %r9w
	movw %bx, %ax
	movw %cx, %bx
	movw %dx, %cx
	movw %r9w, %dx

	ror $8, %eax
	ror $8, %ebx
	ror $8, %ecx
	ror $8, %edx
	movw %ax, %r9w
	movw %bx, %ax
	movw %cx, %bx
	movw %dx, %cx
	movw %r9w, %dx
	

	ror $8, %eax
	ror $8, %ebx
	ror $8, %ecx
	ror $8, %edx
	movb %al, %r9b
	movb %cl, %al
	movb %r9b, %cl
	movb %bl, %r9b
	movb %dl, %bl
	movb %r9b, %dl

	ror $8, %eax
	ror $8, %ebx
	ror $8, %ecx
	ror $8, %edx


	

	
koniec:
	mov $SYSEXIT, %rax
	mov $EXIT_SUCCES, %rbx
	int $0x80


wczytanie_128b:
	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $input_data , %ecx
	mov $16 , %edx
	int $0x80

	ret	
