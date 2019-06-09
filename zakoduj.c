#include <stdio.h>
char kluczyk[20];
char tekst[20];
char* duzyklucz;
char in_file_name[20];
char out_file_name[20];
extern char* key_generation(char* klucz);
extern char* aes_encode(char* data, char* key);

int main()
{
	printf("Podaj plik do zakodowania:\n");
	scanf("%s", in_file_name);
	printf("Podaj plik do zapisania zakodowanego pliku\n");
	scanf("%s", out_file_name);
	printf("Podaj klucz (do 16 znakow)");
	scanf("%s", kluczyk);	

	char* duzyklucz = key_generation(kluczyk);

    char znak;
    char* wynik;
    FILE *plik = fopen(in_file_name, "r" );   // otwieramy plik do odczytu
    FILE *outplik = fopen(out_file_name, "w");
    int i=0;
    znak = getc( plik ); 
    while( znak != EOF )                  //pętla odczytująca po jednym znaku z pliku
    {
        tekst[i] = znak;
	i++;
	if(i==16){
	wynik = aes_encode(tekst, duzyklucz);
	i = 0;
	fwrite(wynik, 1, 16, outplik);
	}
            //do napotkania znaku końca pliku EOF
        znak = getc( plik );
    } 
    while(i<16){
	tekst[i] = znak;
	i++;
	znak = '\0';
}
	wynik = aes_encode(tekst, duzyklucz);
	wynik[16] = EOF;	
	fwrite(wynik, 1, 17, outplik);
	
    fclose( outplik );
    fclose( plik ); 

	return 0;
}
