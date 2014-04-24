
 
 
DEF TEMP-TABLE Vardiyalar
      FIELD  VardiyaId  AS INTEGER 
      FIELD  VardiyaKod  AS CHARACTER  
      FIELD  Aciklama  AS CHARACTER   
      FIELD  TakvimKod  AS CHARACTER         
      FIELD  Baslangic  AS INTEGER 
      FIELD  Bitis  AS INTEGER   
      FIELD  NetSure  AS INTEGER 
      FIELD  Baslangic2  AS CHARACTER  
      FIELD  Bitis2  AS CHARACTER  
      FIELD  BrutSure  AS INTEGER.

DEFINE DATASET VardiyalarDS FOR Vardiyalar.
DEFINE OUTPUT PARAMETER DATASET FOR VardiyalarDS. 

DEFINE INPUT PARAMETER  xKod AS CHARACTER.
DEFINE INPUT PARAMETER  xAciklama AS CHARACTER.

DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

{Include3\Baglanti.i}

RUN Vardiyalar_run (
    OUTPUT TABLE Vardiyalar, 
    INPUT xKod, INPUT xAciklama, Firma, INPUT Limit).
