DEF TEMP-TABLE MalzemeBirim
    FIELD MalzemeBirimId AS INTEGER
    FIELD BirimId AS INTEGER
    FIELD BirimKod AS CHARACTER FORMAT "X(8)":U
    FIELD MalzemeId AS INTEGER
    FIELD MalzemeKod AS CHARACTER FORMAT "X(8)":U
    FIELD Miktar AS DECIMAL FORMAT "->>>>,>>9.999<<<<"
    FIELD Miktar2 AS DECIMAL FORMAT "->>>>,>>9.999<<<<"
    FIELD SiraNo AS INTEGER
    FIELD En AS DECIMAL FORMAT ">>>,>>9.99"
    FIELD Boy AS DECIMAL FORMAT ">>>,>>9.99" 
    FIELD Yukekseklik AS DECIMAL FORMAT ">>>,>>9.99"
    FIELD Hacim AS DECIMAL FORMAT "->>>,>>9.99<<<<<" 
    FIELD Agirlik AS DECIMAL FORMAT ">>>,>>>,>>>.<<<<<".    
      
     
DEFINE DATASET MalzemeBirimDS FOR MalzemeBirim.
DEFINE OUTPUT PARAMETER DATASET FOR MalzemeBirimDS.   

DEFINE INPUT PARAMETER  AraBirimKod AS CHARACTER FORMAT "X(8)":U. 
DEFINE INPUT PARAMETER  AraMalzemeKod AS CHARACTER FORMAT "X(32)":U.
DEFINE INPUT PARAMETER  AraMalzemeId AS INTEGER FORMAT ">>>>>>>>>>>>>>>>>9.99".

DEFINE INPUT PARAMETER Firma AS CHARACTER FORMAT "x(8)":U INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

{Include3\Baglanti.i}

RUN MalzemeBirimler_run (OUTPUT TABLE MalzemeBirim, INPUT AraBirimKod, INPUT AraMalzemeKod, INPUT AraMalzemeId, INPUT Firma, INPUT Limit).
