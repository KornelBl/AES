SYSEXIT		=1
SYSREAD		=3
SYSWRITE	=4
STDIN		=0
STDOUT		=1
EXIT_SUCCES	=0

# Rijndael's S-Box
key_length 	=128
.align 32

.data		
s_box1:	.octa 0x637c777bf26b6fc53001672bfed7ab76, 0xca82c97dfa5947f0add4a2af9ca472c0	

	.ascii "abcaa"
	
.bss
	.comm KEY, 16		#128bit 

.text
s_box: 	.byte 0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76

#s_box = 0x637c777bf26b6fc5 3001672bfed7ab76 ca82c97dfa5947f0 add4a2af9ca472c0 b7fd9326363ff7cc 34a5e5f171d83115 04c723c31896059a071280e2eb27b27509832c1a1b6e5aa0523bd6b329e32f8453d100ed20fcb15b6acbbe394a4c58cfd0efaafb434d338545f9027f503c9fa851a3408f929d38f5bcb6da2110fff3d2cd0c13ec5f974417c4a77e3d645d197360814fdc222a908846eeb814de5e0bdbe0323a0a4906245cc2d3ac629195e479e7c8376d8dd54ea96c56f4ea657aae08ba78252e1ca6b4c6e8dd741f4bbd8b8a703eb5664803f60e613557b986c11d9ee1f8981169d98e949b1e87e9ce5528df8ca1890dbfe6426841992d0fb054bb16

.global _start
_start:
	
	mov %ebp , %edx
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $s_box, %ecx
	
	int $0x80

koniec:
	mov $SYSEXIT, %rax
	mov $EXIT_SUCCES, %rbx
	int $0x80


mov_data:
	


	ret
