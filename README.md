# AES
AES implementation in AT&T assembler and C.

## Architecture
Generating extended key form private key (part of AES algorithm),as well as encoding and decoding a block of 16 bytes are all implemented with AT&T Assembler in following files:
- generation.s
- encode.s
- decode.s

Those functions are later used to encode and decode whole files in C language. This is implemented in the following:
- zakoduj.c
- odkoduj.c

Files named zakoduj and odkoduj are executable files linked and compiled on Ubuntu 14.04.

## Author
Kornel Błąkała
