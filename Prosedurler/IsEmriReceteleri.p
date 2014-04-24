/**********************
***********************/

DEF TEMP-TABLE V_Receteler
    FIELD ReceteId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
    FIELD IsEmriId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
    FIELD IsEmriNo AS CHARACTER FORMAT "X(32)":U
    FIELD IsEmriMiktar AS DECIMAL
    FIELD SatirNo AS INTEGER
    FIELD BirimId AS INTEGER
    FIELD Birim AS CHARACTER FORMAT "X(16)":U
    FIELD MalzemeId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
    FIELD MalzemeKod AS CHARACTER
    FIELD MalzemeAd AS CHARACTER
    FIELD OperasyonId AS INTEGER
    FIELD OperasyonNo AS INTEGER
    FIELD OperasyonKod AS CHARACTER
    FIELD BirimMiktar AS DECIMAL
    FIELD NetMiktar AS DECIMAL
    FIELD OzelKod AS CHARACTER
    FIELD PartiKod AS CHARACTER
    FIELD MiktarSekli AS LOGICAL
    FIELD HammaddeTakip AS INTEGER
    FIELD UstMalzemeId AS INTEGER FORMAT ">>>,>>>,>>>,>>9"
    FIELD UstMalzemeKod AS CHARACTER
    FIELD UstMalzemeAd AS CHARACTER.
   
DEFINE DATASET RecetelerDS FOR V_Receteler.
DEFINE OUTPUT PARAMETER DATASET FOR RecetelerDS.

DEFINE INPUT PARAMETER  xIsEmri AS CHARACTER FORMAT "X(64)":U.

DEFINE INPUT PARAMETER Firma AS CHARACTER FORMAT "X(64)":U INITIAL "ARMA2011".
DEFINE INPUT PARAMETER Limit AS INTEGER INITIAL 100.

{Include3\Baglanti.i}

RUN IsEmriReceteleri_run (
    OUTPUT TABLE V_Receteler, 
    INPUT xIsEmri, INPUT Firma, INPUT Limit).
