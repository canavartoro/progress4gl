/**********************
***********************/

   DEF TEMP-TABLE Nakliyeciler
      FIELD NakliyeciId AS INTEGER
      FIELD NakliyeciKod AS CHARACTER FORMAT "X(32)":U 
      FIELD AracKod AS CHARACTER FORMAT "X(32)":U 
      FIELD PlakaNo AS CHARACTER FORMAT "X(32)":U 
      FIELD Surucu AS CHARACTER FORMAT "X(32)":U
      FIELD AgirilikKapasite AS DECIMAL 
      FIELD HacimKapasite AS DECIMAL
      FIELD AracTel AS CHARACTER FORMAT "X(20)":U 
      FIELD CepTel AS CHARACTER FORMAT "X(20)":U
      FIELD Acikalama AS CHARACTER FORMAT "X(32)":U.
      
   
DEFINE DATASET NakliyecilerDS FOR Nakliyeciler.
DEFINE OUTPUT PARAMETER DATASET FOR NakliyecilerDS.

DEFINE INPUT PARAMETER  xId AS INTEGER.
DEFINE INPUT PARAMETER  xNakliyeciKod AS CHARACTER.
DEFINE INPUT PARAMETER  xAracKod AS CHARACTER.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

{Include3\Baglanti.i}

RUN Araclar_run (OUTPUT TABLE Nakliyeciler, INPUT xId, INPUT xNakliyeciKod, INPUT xAracKod, INPUT Firma, INPUT Limit).


