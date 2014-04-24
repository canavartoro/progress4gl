/**********************
***********************/
   DEF TEMP-TABLE V_SiparisOkunanlar
      FIELD  MalzemeAd  AS CHARACTER FORMAT "X(128)":U  
      FIELD  MalzemeKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  CariMalzemeKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  BirimKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  Miktar  AS DECIMAL
      FIELD  Okunan  AS DECIMAL
      FIELD  Kalan  AS DECIMAL
      FIELD  OzelKod  AS CHARACTER FORMAT "X(32)":U  
      FIELD  SiparisId  AS INTEGER
      FIELD  SiparisDetayId  AS INTEGER
      FIELD  CariId  AS INTEGER
      FIELD  BirimId  AS DECIMAL
      FIELD  MalzemeId  AS INTEGER
      FIELD  SiraNo  AS INTEGER
      FIELD  DepoId  AS INTEGER
      FIELD  HizmetKartId  AS INTEGER
      FIELD  SatirTipi  AS INTEGER
      FIELD  TeslimTarihi AS CHARACTER FORMAT "X(12)":U
      FIELD  DepoKod  AS CHARACTER FORMAT "X(32)":U.  
      
      
DEFINE DATASET SiparisOkunanlarDS FOR V_SiparisOkunanlar.
DEFINE OUTPUT PARAMETER DATASET FOR SiparisOkunanlarDS.   

DEFINE INPUT PARAMETER xId AS INTEGER.
DEFINE INPUT PARAMETER xId2 AS INTEGER.
DEFINE INPUT PARAMETER xCariKod AS CHARACTER.
DEFINE INPUT PARAMETER xCariAd AS CHARACTER.
DEFINE INPUT PARAMETER xSipNo AS CHARACTER.
DEFINE INPUT PARAMETER xAlisSatis AS CHARACTER.
DEFINE INPUT PARAMETER xDepogoster AS LOGICAL.
DEFINE INPUT PARAMETER Firma AS CHARACTER INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

{Include3\Baglanti.i}

RUN V_SiparisOkunanlar_run (OUTPUT TABLE V_SiparisOkunanlar, 
                            INPUT xId, INPUT xId2, INPUT xCariKod, INPUT xCariAd, INPUT xSipNo, 
                            INPUT xAlisSatis, INPUT xDepogoster, INPUT Firma, INPUT Limit).
