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
   


DEFINE VARIABLE  xIsEmri AS CHARACTER NO-UNDO FORMAT "X(64)":U INITIAL "sil-nuri".

DEFINE VARIABLE Firma AS CHARACTER NO-UNDO FORMAT "X(64)":U INITIAL "ARMA2011".
DEFINE VARIABLE Limit AS INTEGER NO-UNDO INITIAL 100.

{Include3\Baglanti.i}

RUN C:\OpenEdge\BarsetProxy\Prosedurler\IsEmriReceteleri_run.p  (
    OUTPUT TABLE V_Receteler, 
    INPUT xIsEmri, INPUT Firma, INPUT Limit).

FOR EACH V_Receteler:
    DISPLAY V_Receteler.IsEmriNo V_Receteler.MalzemeKod V_Receteler.OperasyonKod V_Receteler.Birim.
END.
