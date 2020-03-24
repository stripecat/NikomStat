/* Skapar topplistor med hjälp av Nikomstat. */

/* say 'General...'*/
address command 'rx nikom:rexx/nikomstat.rexx i1 r0 w5 u20 d-20 t0 h1 lGENERAL fNiKom:Texter/svenska/Generallistan.txt'

/* say 'Login...'*/
address command 'rx nikom:rexx/nikomstat.rexx i1 r0 w0 u0 d0 t0 h1 lINLOGGNINGS fNiKom:Texter/svenska/Loginlistan.txt'

/* say 'Write..' */
address command 'rx nikom:rexx/nikomstat.rexx i0 r0 w1 u0 d0 t0 h1 lWRITE fNiKom:Texter/svenska/Writelistan.txt'

/* say 'Topp UL/DL..' */
address command 'rx nikom:rexx/nikomstat.rexx i0 r0 w0 u15 d-5 h1 t0 lUl/Dl- fNiKom:Texter/svenska/Topp-UpDownlistan.txt'

/* say 'Botten-UL/DL..' */
address command 'rx nikom:rexx/nikomstat.rexx i0 r0 w0 u15 d-5 h1 t0 q1 lBotten-Ul/Dl- fNiKom:Texter/svenska/Botten-UpDownlistan.txt'

/* say 'Aktiva användare..' */
address command 'rx nikom:rexx/nikomstat.rexx i1 r0 w5 u20 d-20 h1 t0 n-2 lAKTIVA- fNiKom:Texter/svenska/Aktiva.txt'