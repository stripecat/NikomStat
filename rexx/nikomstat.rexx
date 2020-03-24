/* Kommandot NikomStat
$VER: NikomStat 1.1 (17.7.19)

Skapat av Erik Zalitis.

F�r spridas och modfieras fritt s�l�nge mitt namn st�r kvar som originalutvecklare.

*/

Options Results
signal on syntax
LF='0a0d'x
DLF='0a0a0d'x

/* H�r deffas f�rgerna som skall anv�ndas */
sv = '[30m'
vi = '[37m'
Gu = '[33m'
Bl = '[34m'
Gr = '[32m'
Li = '[35m'
Ro = '[31m'

Sb = '[40m'
Rb = '[41m'
Gb = '[42m'
gub = '[43m'
bb = '[44m'
lb = '[45m'
cb = '[46m'
vb = '[47m'
sysop = userinfo(0,'n')
Cosysop = userinfo(1,'n')
Cybersysse = userinfo(289,'n')
clr='0c'x

/*
Fr�n NikomUS manual:

 i        Anger antalet po�ng f�r en inloggning
  r                --  ||  --         l�st text
  w                --  ||  --         skriven text
  u                --  ||  --         uppladdad fil
  d                --  ||  --         nerladdad fil
  t                --  ||  --         inloggad sekunder
  f        Anger filnamnet som listan ska ha. Default �r 'ram:temp.dat'
  p        En Progress-option. Med denna beordras NiKomUS att fortl�pande
           tala om vad den g�r. Bra vid test, v�rdel�st vid automatisk
           listtillverkning.
  q        Med q-optionen v�nder man p� listan. Dvs, en topplista blir en
           bottenlista. Varf�r just 'q'? Kunde inte hitta p� n�t passande.
           Du kommer s�kert inte att gl�mma bort den iaf!
*/

/* Definitioner */

bbs="THE ERICADE NETWORK"
listsuffix="LISTAN"

/* L�s in parametrarna */

/* Po�ng f�r olika handlingar. Anv�nds om parametrarna inte angivits */
inloggningar=1
last=0
skrivet=5
nedladdat=-20
uppladdat=20
inaktivaveckor=0
inloggadisekunder=0
filnamn='ram:temp.dat'
progress=0
uon=0
huvud=1
listprefix='GENERAL'

PARSE ARG parg.0 parg.1 parg.2 parg.3 parg.4 parg.5 parg.6 parg.7 parg.8 parg.9 parg.10 parg.11 parg.12 parg.13 parg.14

i=0
DO until ( i == 14 ) 
   if left(parg.i,1) == "i" then inloggningar = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "I" then inloggningar = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "r" then last = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "R" then last = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "w" then skrivet = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "W" then skrivet = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "u" then uppladdat = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "U" then uppladdat = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "d" then nedladdat = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "D" then nedladdat = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "n" then inaktivaveckor = trim(substr(parg.i,2,8)) /* Minuspo�ng per inaktiv vecka*/
   if left(parg.i,1) == "N" then inaktivaveckor = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "h" then huvud = trim(substr(parg.i,2,1))
   if left(parg.i,1) == "H" then huvud = trim(substr(parg.i,2,1))
   if left(parg.i,1) == "t" then inloggadisekunder = trim(substr(parg.i,2,8)) /* Inloggad i sekunder */
   if left(parg.i,1) == "T" then inloggadisekunder = trim(substr(parg.i,2,8))
   if left(parg.i,1) == "f" then filnamn = trim(substr(parg.i,2,64)) /* Filnamn */
   if left(parg.i,1) == "F" then filnamn = trim(substr(parg.i,2,64))
   if left(parg.i,1) == "p" then progress = trim(substr(parg.i,2,1)) /* Progressbar */
   if left(parg.i,1) == "P" then progress = trim(substr(parg.i,2,1))
   if left(parg.i,1) == "q" then uon = trim(substr(parg.i,2,1)) /* V�nd listan upp och ner */
   if left(parg.i,1) == "Q" then uon = trim(substr(parg.i,2,1))
   if left(parg.i,1) == "l" then listprefix = trim(substr(parg.i,2,40)) /* Listprefix. Exempel "General"=Generallistan */
   if left(parg.i,1) == "L" then listprefix = trim(substr(parg.i,2,40))
   i=i+1
   END
   
/* Huvudprogrammet! */

/* Steg 1 - Enumerera anv�ndare och f� ut deras stats */

/* H�gsta anv�ndarnummer. */
hanv=sysInfo('a')


/* s - skrivna texter
d - downloads
u - antal uploads
l - antal l�sta texter
i - antal inloggningar
*/

call open(test,'ram:nikomstat_temp.txt','w')

running=1
i=0
DO WHILE ( i<=hanv )
   number = i
   namn=userinfo(i,'n') 
	 inl=userinfo(i,'i')
	 las=userinfo(i,'l')
	 skriv=userinfo(i,'s')
	 upl=userinfo(i,'u')
	 down=userinfo(i,'d')
	 status=userinfo(i,'r')
	 iis=userinfo(i,'t')

if namn ~='-1' then do
	 senastinloggad=substr(userinfo(i,'e'),1,8)
	 if substr(senastinloggad,1,4) < 1977 then bdsenastinloggad=722085 /* Full workaround f�r datum f�re 1977, som arexx inte hanterar! */
	 else bdsenastinloggad=date(b,senastinloggad,s)
	 bdidag=date(b)
	 ina=trunc((bdidag-bdsenastinloggad)/7)
	
	 poang=((inl*inloggningar)+(las*last)+(skrivet*skriv)+(upl*uppladdat)+(down*nedladdat)+(iis*inloggadisekunder)+(ina*inaktivaveckor))
	 call writeln(test,poang||',N:'||namn||',S:'||status||',I:'||inl||',L:'||las||',K:'||skriv||',U:'||upl||',D:'||down||',E:')
end

   i=i+1
   END
call close(test)

/* Sortera resultatet */

address command ('c:sort FROM ram:nikomstat_temp.txt TO ram:nikomstat_sorterad.txt NUMERIC')
address command ('c:delete ram:nikomstat_temp.txt')

/* L�sa tillbaka sorteringen */
/* SEEK( 'input', 0, 'E' ) */

i=0
     If Open(infile,'ram:nikomstat_sorterad.txt','r') Then Do
       Do While ~Eof(infile)
         users.i = Readln(infile)
         i=i+1
       End
		 End

close(infile)

i=i-1 

/*
                                190629 03:50:02

    Anv�ndare                    Status Po�ng      I      L      S    U    D

1   Erik Zalitis #0                100      0      0      0      0    0    0
2   Johan Hanson #1                 30      0      0      0      0    0    0
3   Ann O. Nym #2                    0      0      0      0      0    0    0

*/

i=i-1

imax=i

call open(slutfil,filnamn,'w')

if huvud == 1 then do

ltext='                         'bbs||' '||listprefix||listsuffix
call writeln(slutfil,ltext)
ptext='INLOGGNING = '||inloggningar||' / L�ST = '||last||' / SKRIVET = '||skrivet||' / UPPLADDAT = '||uppladdat||' / NERLADDAT = '||nedladdat
ptext=ptext||'/ TID = '||inloggadisekunder||' / INAKTIV VECKA = '||inaktivaveckor
call writeln(slutfil,ptext)
datum='                                '||date(s)||' '||time()
call writeln(slutfil,datum)
call writeln(slutfil,'')
call writeln(slutfil,'    Anv�ndare                    Status Po�ng      I      L      S    U    D')
call writeln(slutfil,'')
end

/* Normal ordning */
if uon == 0 then do

j=1
do while (i>=0)
/* sendstring pos("Namn:",users.i) */

slen=pos(",S:",users.i)-(pos("N:",users.i)+2)
namn=substr(users.i,pos("N:",users.i)+2,slen)

slen=pos(",I:",users.i)-(pos("S:",users.i)+2)
status=substr(users.i,pos("S:",users.i)+2,slen)

slen=pos(",N:",users.i)
poang=substr(users.i,1,slen-1)

slen=pos(",L:",users.i)-(pos("I:",users.i)+2)
inlogg=substr(users.i,pos("I:",users.i)+2,slen)

slen=pos(",K:",users.i)-(pos("L:",users.i)+2)
last=substr(users.i,pos("L:",users.i)+2,slen)

slen=pos(",U:",users.i)-(pos("K:",users.i)+2)
skrivet=substr(users.i,pos("K:",users.i)+2,slen)

slen=pos(",D:",users.i)-(pos("U:",users.i)+2)
uppladdat=substr(users.i,pos("U:",users.i)+2,slen)

slen=pos(",E:",users.i)-(pos("D:",users.i)+2)
nedladdat=substr(users.i,pos("D:",users.i)+2,slen)

call writeln(slutfil, left(j,4)||left(namn,32)||right(status,3)||right(poang,6)||right(inlogg,7)||right(last,7)||right(skrivet,7)||right(uppladdat,5)||right(nedladdat,5))

/* ||namn||lf */
i=i-1
j=j+1
end
end

/* Upp och ner */

if uon == 1 then do

i=0
j=1

do while (i<=imax)
/* sendstring pos("Namn:",users.i) */

slen=pos(",S:",users.i)-(pos("N:",users.i)+2)
namn=substr(users.i,pos("N:",users.i)+2,slen)

slen=pos(",I:",users.i)-(pos("S:",users.i)+2)
status=substr(users.i,pos("S:",users.i)+2,slen)

slen=pos(",N:",users.i)
poang=substr(users.i,1,slen-1)

slen=pos(",L:",users.i)-(pos("I:",users.i)+2)
inlogg=substr(users.i,pos("I:",users.i)+2,slen)

slen=pos(",K:",users.i)-(pos("L:",users.i)+2)
last=substr(users.i,pos("L:",users.i)+2,slen)

slen=pos(",U:",users.i)-(pos("K:",users.i)+2)
skrivet=substr(users.i,pos("K:",users.i)+2,slen)

slen=pos(",D:",users.i)-(pos("U:",users.i)+2)
uppladdat=substr(users.i,pos("U:",users.i)+2,slen)

slen=pos(",E:",users.i)-(pos("D:",users.i)+2)
nedladdat=substr(users.i,pos("D:",users.i)+2,slen)

call writeln(slutfil, left(j,4)||left(namn,32)||right(status,3)||right(poang,6)||right(inlogg,7)||right(last,7)||right(skrivet,7)||right(uppladdat,5)||right(nedladdat,5))

/* ||namn||lf */
i=i+1
j=j+1
end

end

call close (slutfil)
address command ('c:delete ram:nikomstat_sorterad.txt')

/* Felhantering f�r Arexx */

exit
syntax:
say '0a0d'x||errortext(rc)' p� rad 'sigl||'0a0d'x
say "'"sourceline(sigl)"'"||lf
say "Meddela SysOp!"||'0a0d'x