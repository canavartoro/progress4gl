DEF TEMP-TABLE Hareketler
      FIELD  HareketKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  HareketAd  AS CHARACTER FORMAT "X(128)":U  
      FIELD  Aciklama  AS CHARACTER FORMAT "X(128)":U  
      FIELD  HareketTur  AS CHARACTER FORMAT "X(32)":U        
      FIELD  OzelKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  HedefRaf  AS CHARACTER FORMAT "X(32)":U  
      FIELD  HedefDepo  AS CHARACTER FORMAT "X(32)":U  
      FIELD  KaynakRaf  AS CHARACTER FORMAT "X(32)":U  
      FIELD  KaynakDepo  AS CHARACTER FORMAT "X(32)":U  
      FIELD  GirisCikis  AS CHARACTER FORMAT "X(8)":U
      FIELD  CariZorunlu  AS CHARACTER FORMAT "X(8)":U
      FIELD  IrsaliyeZorunlu  AS LOGICAL
      FIELD  IsemriZorunlu AS CHARACTER FORMAT "X(8)":U
      FIELD  AlisSatis AS CHARACTER FORMAT "X(8)":U
      FIELD  Iade  AS CHARACTER FORMAT "X(8)":U
      FIELD  Fason  AS CHARACTER FORMAT "X(8)":U
      FIELD  HareketTanimId  AS INTEGER
      FIELD  HareketTurId  AS INTEGER
      FIELD  HedefRafId  AS INTEGER
      FIELD  KaynakRafId  AS INTEGER
      FIELD  HedefDepoId  AS INTEGER
      FIELD  KaynakDepoId  AS INTEGER. 

          
DEFINE DATASET HareketlerDS FOR Hareketler.
DEFINE OUTPUT PARAMETER DATASET FOR HareketlerDS.

DEFINE INPUT PARAMETER  xHareketKod AS CHARACTER.
DEFINE INPUT PARAMETER  xHareketAd AS CHARACTER.
DEFINE INPUT PARAMETER  xAciklama AS CHARACTER.
DEFINE INPUT PARAMETER  xAlisSatis AS CHARACTER.
DEFINE INPUT PARAMETER  xKaynakProgram AS CHARACTER.

DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

{Include3\Baglanti.i}

RUN Hareketler_run (OUTPUT TABLE Hareketler, 
                    INPUT xHareketKod, INPUT xHareketAd, INPUT xAciklama, INPUT xAlisSatis, 
                    INPUT xKaynakProgram, INPUT Firma, INPUT Limit).
