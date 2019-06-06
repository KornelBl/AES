#include <stdio.h>
char kluczyk[17] = "tojestklucznikor\0";
char tekst[17] = "tojestzakodowane\0";
extern char* key_generation(char* klucz);
extern char* aes_encode(char* data, char* key);
extern char* aes_decode(char* coded_data, char* key);

int main()
{
	char* duzyklucz = key_generation(kluczyk);
	char* zakodowany_tekst = aes_encode(tekst, duzyklucz);
	char* odkodowany_tekst = aes_decode(zakodowany_tekst, duzyklucz);
	printf("char z asemblera: %s\nklucz rozszerzony:%s\nzakodowany tekst:%s\nodkodowany tekst:%s\n", tekst, duzyklucz, zakodowany_tekst,odkodowany_tekst);
	return 0;
}
