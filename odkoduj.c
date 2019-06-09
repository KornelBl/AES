#include <stdio.h>
char kluczyk[20];
char tekst[20];
char in_file_name[20];
char out_file_name[20];
extern char* key_generation(char* klucz);
extern char* aes_decode(char*data, char*datainna);

int main()
{
	printf("Podaj plik do odkodowania:\n");
	scanf("%s", in_file_name);
	printf("Podaj plik do zapisania odkodowanych danych\n");
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
	wynik = aes_decode(tekst, duzyklucz);
	i = 0;
	while(wynik[i] != EOF && i <16){
	fwrite(wynik + i, 1, 1, outplik);
	i++;
	}
	i = 0;
	}
            //do napotkania znaku końca pliku EOF
        znak = getc( plik );
    } 
	
    fclose( outplik );
    fclose( plik ); 

	return 0;
}
